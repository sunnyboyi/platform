<template>
  <div>
    <el-form :inline="true" label-position="left">
      <el-row type="flex" justify="space-between">
        <el-col :span="20">
          <el-form-item label="订单信息" prop="name">
            <el-input placeholder="订单号，订单名称" v-model="queryFormData.keyword" class="input-item"></el-input>
          </el-form-item>
          <!-- </el-col> -->
          <!-- <el-col :span="5"> -->
          <el-form-item label="部门/人员" prop="name">
            <!-- <el-input placeholder="跟单员姓名" v-model="queryFormData.planLeader" class="input-item"></el-input> -->
            <dept-person-select ref="deptPersonSelect" :dataQuery="dataQuery" width="170"
                                :selectDept="queryFormData.depts" :selectPerson="queryFormData.users"/>
          </el-form-item>
          <!-- </el-col> -->
          <!-- <el-col :span="5"> -->
          <el-form-item label="合作商" prop="name">
            <el-input placeholder="合作商名称" v-model="queryFormData.originCooperator" class="input-item"></el-input>
          </el-form-item>
          <!-- </el-col> -->
          <!-- <el-col :span="1" style="margin-right:10px"> -->
          <el-button-group>
            <el-button type="primary" class="toolbar-search_input" @click="onAdvancedSearch">搜索</el-button>
            <el-button native-type="reset" @click="onReset">重置</el-button>
          </el-button-group>
        </el-col>
        <el-col :span="5" v-if="isPending">
          <el-row type="flex" justify="end">
            <el-button-group>
              <authorized :permission="['SALES_PLAN_CREATE']">
                <el-button size="small" @click="createSalesOrder">创建外接订单</el-button>
              </authorized>
              <authorized :permission="['SALES_PLAN_CREATE']">
                <el-button type="primary" size="small" @click="onUniqueCodeImport">唯一码导入</el-button>
              </authorized>
            </el-button-group>
          </el-row>
        </el-col>
        <el-col :span="4" v-if="!isPending">
          <el-row type="flex" justify="end">
            <el-button-group>
              <authorized :permission="['SALES_PLAN_CREATE']">
                <el-button size="small" @click="createSalesPlan">创建企划订单</el-button>
              </authorized>
            </el-button-group>
          </el-row>
        </el-col>
      </el-row>
    </el-form>
    <el-dialog :visible.sync="uniqueCodeImportFormVisible" width="50%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <unique-code-import-form @callback="onImportCallback" />
    </el-dialog>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';
  import SalesProductionStatusBar from '../components/SalesProductionStatusBar';
  import UniqueCodeImportForm from '../form/UniqueCodeImportForm';
  import { DeptPersonSelect } from '@/components'

  const {
    mapMutations
  } = createNamespacedHelpers('SalesProductionOrdersModule');

  export default {
    name: 'SalesProductionToolbar',
    props: {
      isPending: {
        type: Boolean,
        default: false
      },
      queryFormData: {
        type: Object
      },
      dataQuery: {
        type: Object
      }
    },
    components: {
      SalesProductionStatusBar,
      UniqueCodeImportForm,
      DeptPersonSelect
    },
    computed: {},
    data() {
      return {
        statuses: this.$store.state.EnumsModule.SalesProductionStatuses,
        uniqueCodeImportFormVisible: false
      }
    },
    methods: {
      ...mapMutations({
        setKeyword: 'keyword',
      }),
      createSalesPlan() {
        this.$emit('createSalesPlan');
      },
      createSalesOrder() {
        this.$emit('createSalesOrder');
      },
      onUniqueCodeImport() {
        this.uniqueCodeImportFormVisible = true;
      },
      onImportCallback() {
        this.uniqueCodeImportFormVisible = false;
        this.$emit('onAdvancedSearch', 0);
      },
      onAdvancedSearch() {
        this.$emit('onAdvancedSearch', 0);
      },
      async getFactories(query) {
        const url = this.apis().getFactories();
        const result = await this.$http.post(url, {
          keyword: query
        }, {
          page: 0,
          size: 10
        });
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.factories = result.content;
      },
      async getBrands(query) {
        const url = this.apis().getBrands();
        const result = await this.$http.post(url, {
          keyword: query
        }, {
          page: 0,
          size: 10
        });
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.brands = result.content;
      },
      onDateChange(values) {
        this.queryFormData.createdDateFrom = values[0];
        this.queryFormData.createdDateTo = values[1];
        this.onAdvancedSearch();
      },
      async getCategories() {
        const url = this.apis().getMinorCategories();
        const results = await this.$http.get(url);
        if (!results['errors']) {
          this.categories = results;
        }
      },
      onReset() {
        this.queryFormData.keyword = '';
        this.queryFormData.planLeader = '';
        this.queryFormData.originCooperator = '';
        this.$refs.deptPersonSelect.clearSelectData();
        this.$emit('onResetQuery');
      }
    },
    created() {
      this.getCategories();
      if (this.isTenant()) {
        this.getFactories();
        this.getBrands();
      }
    },
    watch: {
      dateTime: function (newVal, oldVal) {
        if (newVal == null) {
          this.queryFormData.createdDateFrom = null;
          this.queryFormData.createdDateTo = null;
        } else {
          this.queryFormData.createdDateFrom = newVal[0];
          this.queryFormData.createdDateTo = newVal[1];
        }
      }
    }
  }

</script>
<style scoped>
  .input-item {
    width: 170px;
  }

  .toolbar-search_input {
    background-color: #ffd60c;
    border-color: #ffd60c;
  }

  .create-button {
    background-color: #ffd60c;
    border-color: #DCDFE6;
    width: 100px;
    height: 40px;
    color: #606266;
  }

  .create-button_blue {
    /* background-color: #ecf5ff;
    border-color: #b3d8ff; */
    /* width: 50px; */
    height: 25px;
    /* color: #409eff; */
  }

  .el-form-item--mini.el-form-item,
  .el-form-item--small.el-form-item {
    margin-bottom: 5px !important;
  }

</style>
