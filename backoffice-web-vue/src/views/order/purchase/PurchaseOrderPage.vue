<template>
  <div class="animated fadeIn content">
    <el-dialog @open="getContract" @close="initContract" :visible.sync="dialogDetailVisible" width="85%"
      class="purchase-dialog" :close-on-click-modal="false">
      <purchase-order-details-page :contracts="contracts" :slotData="contentData" @onDetails="onDetails"
                                   :dialogDetailVisible="dialogDetailVisible" @onSearch="onSearch"
                                   @closeDialogDetailVisible="closeDialogDetailVisible"/>
    </el-dialog>
    <el-dialog :visible.sync="cannelMsgVisible" width="50%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <purchase-order-cannel-msg-dialog :contracts="contracts" :slotData="contentData"
                                        @closeCannelMsgVisible="closeCannelMsgVisible" @onSearch="onSearch"/>
    </el-dialog>
    <!-- <div class="report">
      <purchase-orders-report />
    </div> -->
    <el-card>
      <el-row>
        <el-col :span="2">
          <div class="orders-list-title">
            <h6>订单列表</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <purchase-order-toolbar @onNew="onNew" @onSearch="onSearch" @onAdvancedSearch="onAdvancedSearch" />
      <el-tabs v-model="activeStatus" @tab-click="handleClick">
        <template v-for="(item, index) in statues">
          <el-tab-pane :name="item.code" :key="index">
            <span slot="label">
              <tab-label-bubble :label="item.name" :num="0" />
            </span>
            <purchase-order-search-result-list :page="page" @onDetails="onDetails" @onSearch="onSearch"
              @onUpdate="onUpdate" @onAdvancedSearch="onAdvancedSearch" />
          </el-tab-pane>
        </template>
      </el-tabs>
    </el-card>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from "vuex";
  import Bus from '@/common/js/bus.js';

  const {
    mapGetters,
    mapActions,
    mapMutations
  } = createNamespacedHelpers(
    'PurchaseOrdersModule'
  );

  import PurchaseOrderToolbar from './toolbar/PurchaseOrderToolbar';
  import PurchaseOrderSearchResultList from './list/PurchaseOrderSearchResultList';
  import PurchaseOrderDetailsPage from './details/PurchaseOrderDetailsPage';
  import PurchaseOrdersReport from './components/PurchaseOrdersReport';
  import TabLabelBubble from '@/components/custom/TabLabelBubble';
  import http from '@/common/js/http';
  import PurchaseOrderCannelMsgDialog from './info/PurchaseOrderCannelMsgDialog';

  export default {
    name: 'PurchaseOrderPage',
    components: {
      PurchaseOrderCannelMsgDialog,
      PurchaseOrderToolbar,
      PurchaseOrderSearchResultList,
      // PurchaseOrdersReport,
      TabLabelBubble,
      PurchaseOrderDetailsPage
    },
    computed: {
      ...mapGetters({
        page: 'page',
        keyword: 'keyword',
        queryFormData: 'queryFormData',
        contentData: 'detailData'
      })
    },
    methods: {
      ...mapActions({
        search: 'search',
        searchAdvanced: 'searchAdvanced'
      }),
      ...mapMutations({
        setIsAdvancedSearch: 'isAdvancedSearch',
        setDetailData: 'detailData'
      }),
      onSearch (page, size) {
        const keyword = this.keyword;
        const statuses = this.statuses;
        const url = this.apis().getPurchaseOrders();
        this.setIsAdvancedSearch(false);
        this.search({
          url,
          keyword,
          statuses,
          page,
          size
        });
      },
      onAdvancedSearch (page, size) {
        this.setIsAdvancedSearch(true);
        const query = this.queryFormData;
        const url = this.apis().getPurchaseOrders();
        this.searchAdvanced({
          url,
          query,
          page,
          size
        });
      },
      onNew (formData) {
        // this.fn.openSlider('创建手工单', PurchaseOrderDetailsPage, formData);
      },
      handleClick (tab, event) {
        // console.log(tab.name);
        if (tab.name == 'ALL') {
          this.queryFormData.statuses = [];
          this.onAdvancedSearch();
        } else {
          this.queryFormData.statuses = [tab.name];
          this.onAdvancedSearch();
        }
      },
      async onDetails (row) {
        const url = this.apis().getPurchaseOrder(row.code);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        // this.contentData = result;
        this.setDetailData(result);
        if (result.status != 'CANCELLED' && (result.creator != null || result.creator != undefined)) {
          if ((result.creator.uid != this.$store.getters.currentUser.companyCode) && result.cannelStatus == 'APPLYING') {
            console.log(this.contentData);
            this.cannelMsgVisible = true;
            return;
          }
        }
        // this.fn.openSlider('生产订单：' + result.code, PurchaseOrderDetailsPage, result);
        this.dialogDetailVisible = true;
      },
      onNew (formData) {
        this.fn.openSlider('创建手工单', PurchaseOrderDetailsPage, formData);
      },
      async onUpdate(row) {
        const url = this.apis().getPurchaseOrder(row.code);
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        this.$router.push({
          name: "下单",
          params: {
            isUpdate: true,
            data: result
          }
        });
      },
      async getContract () {
        console.log(this.contentData);
        const url = this.apis().getContractsList();
        const result = await http.post(url, {
          orderCode: this.contentData.code
        }, {
          page: 0,
          size: 100
        });
        for (var i = 0; i < result.content.length; i++) {
          if (result.content[i].state != 'INVALID') {
            this.contracts.push(result.content[i]);
          }
        };
        console.log(this.contracts);
      },
      initContract () {
        this.contracts = [];
      },
      closeCannelMsgVisible () {
        this.cannelMsgVisible = false;
      },
      closeDialogDetailVisible () {
        this.dialogDetailVisible = false;
      }
    },
    data () {
      return {
        dialogDetailVisible: false,
        cannelMsgVisible: false,
        // contentData: {},
        formData: this.$store.state.PurchaseOrdersModule.formData,
        activeStatus: 'ALL',
        statues: [{
          code: 'ALL',
          name: '全部'
        }],
        contracts: []
      };
    },
    created () {
      this.onSearch();
      this.$store.state.EnumsModule.purchaseOrderStatuses.forEach(element => {
        this.statues.push(element);
      });
      Bus.$on('my-event', args => {
        // this.dialogDetailVisible = !this.dialogDetailVisible;
      });
    },
    mounted () {

    }
  };

</script>
<style>
  .report {
    margin-bottom: 10px;
  }

  .orders-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .purchase-dialog .el-dialog {
    border-radius: 10px !important;
  }

  .purchase-dialog-header {
    padding: 0px !important;
  }

  .purchase-dialog .el-dialog__header {
    padding: 0px !important;
  }

</style>
