<template>
  <div class="animated fadeIn">
    <el-card :shadow="shadow">
      <el-row type="flex" justify="space-between">
        <el-col :span="4">
          <div class="title">
            <h6>对账任务单</h6>
          </div>
        </el-col>
        <el-col :span="6">
          <h6>单号：{{formData.code}}</h6>
        </el-col>
        <el-col :span="4">
          <h6>创建时间：{{formData.creationtime | timestampToTime}}</h6>
        </el-col>
        <el-col :span="4">
          <div>
            <h6>状态: {{getEnum('ReconciliationTaskState',formData.state)}}</h6>
          </div>
        </el-col>
      </el-row>
      <el-form :inline="true" label-position="left" label-width="70px">
        <template v-if="showOrderInfo">
          <el-row type="flex" justify="start" class="basic-row">
            <el-col :span="3">
              <img width="100px" height="100px"
                :src="formData.product!=null?formData.product.thumbnail.url:'static/img/nopicture.png'">
            </el-col>
            <el-col :span="21">
              <el-row type="flex" style="padding: 10px 0px">
                <el-col :span="8">
                  <h6>产品名称：{{formData.product?formData.product.name:''}}</h6>
                </el-col>
                <el-col :span="8">
                  <h6>货号：{{formData.product?formData.product.skuID:''}}</h6>
                </el-col>
              </el-row>
              <el-row type="flex" style="padding-bottom: 10px">
                <el-col :span="8">
                  <h6>发货方：{{formData.shipParty!=null?formData.shipParty.name:''}}</h6>
                </el-col>
                <el-col :span="8">
                  <h6>收货方：{{formData.receiveParty!=null?formData.receiveParty.name:''}}</h6>
                </el-col>
                <el-col :span="8">
                  <h6>发货负责人：{{formData.merchandiser?formData.merchandiser.name:''}}</h6>
                </el-col>
              </el-row>
              <el-row type="flex" style="padding-bottom: 10px">
                <el-col :span="12">
                  <h6>收货地址：{{formData.deliveryAddress?formData.deliveryAddress.details:''}}</h6>
                </el-col>
              </el-row>
            </el-col>
          </el-row>
        </template>
        <el-row type="flex" justify="start" class="basic-row">
          <el-col :span="24">
            <reconciliation-tasks-quantity-table :formData="formData" />
          </el-col>
        </el-row>
        <el-row type="flex" justify="end">
          <el-col :span="2" v-if="isReceiveOperator">
            <authorized :permission="['RECONCILIATION_SHEET_CREATE_UPDATE']">
              <el-button @click="onCreate">创建对账单</el-button>
            </authorized>
          </el-col>
        </el-row>
        <el-row type="flex" justify="start">
          <el-col :span="24">
            <reconciliation-tasks-orders-list :formData="formData" @onCreate="onCreate" />
          </el-col>
        </el-row>
      </el-form>
    </el-card>
  </div>
</template>

<script>
  import Bus from '../../js/bus'

  import ReconciliationTasksQuantityTable from '../table/ReconciliationTasksQuantityTable'
  import ReconciliationTasksOrdersList from '../list/ReconciliationTasksOrdersList'
  export default {
    name: 'ReconciliationTasksDetail',
    props: {
      id: {

      },
      shadow: {
        type: String,
        default: 'always'
      },
      showOrderInfo: {
        type: Boolean,
        default: true
      }
    },
    components: {
      ReconciliationTasksQuantityTable,
      ReconciliationTasksOrdersList
    },
    computed: {
      //是否为收货方跟单员
      isReceiveOperator: function () {
        if (this.currentUser != null && this.formData.originMerchandiser != null) {
          return this.currentUser.uid == this.formData.originMerchandiser.uid;
        } else {
          return false;
        }
      },
      canFinish: function () {
        // TODO 判断是否能对账完结
        return true;
      }
    },
    methods: {
      async getDetail() {
        // TODO 获取发货任务详情
        const url = this.apis().reconciliationTaskDetail(this.id);
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        } else if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.formData = result.data;
      },
      onCreate() {
        let productionOrder = Object.assign({
          product: this.formData.product
        }, this.formData.productionTaskOrder);

        this.$router.push({
          name: '创建对账单',
          params: {
            taskId: this.id,
            productionTaskOrder: productionOrder,
            receiveDispatchTaskId: this.formData.receiveDispatchTask.id
          }
        });
      },
      onSumbit() {
        this.$confirm('确认对账完结后，不能再创建对账单了，表示该对账任务完结，是否确认该操作?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this._onSumbit();
        });
      },
      _onSumbit() {

      }
    },
    data() {
      return {
        currentUser: this.$store.getters.currentUser,
        formData: {
          online: false,
          carrier: ''
        },
        taskData: '',
        carriers: ''
      }
    },
    created() {
      this.getDetail();

      //监听刷新通知
      Bus.$on('reconciliation-task-details_onRefresh', args => {
        this.getDetail();
      });
    },
    destroyed() {

    }
  }

</script>

<style scoped>
  .title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .basic-row {
    padding-left: 10px;
    margin-top: 20px;
  }

  .basic-label {
    font-size: 14px;
    color: #606266;
  }

  /deep/ .el-form-item {
    margin-bottom: 0px;
  }

  .sumbit-btn {
    width: 125px;
    height: 40px;
    border-radius: 10px;
  }

</style>
