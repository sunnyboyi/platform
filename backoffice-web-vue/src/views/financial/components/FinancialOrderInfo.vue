<template>
  <div>
    <el-row type="flex" :gutter="10">
      <el-col :span="18">
        <el-row type="flex" justify="start" style="margin-left: 15px;">
          <h6 style="margin: 0px;">订单基本信息</h6>
        </el-row>
        <el-row type="flex" justify="start" style="margin: 15px 0px 0px 24px;">
          <el-col :span="9">
            <h6>合作商：{{cooperatorName}}</h6>
          </el-col>
          <el-col :span="5">
            <h6>合作方式：{{getEnum('machiningTypes', formData.productionOrder.cooperationMode)}}</h6>
          </el-col>
          <el-col :span="6">
            <h6>是否开票：{{formData.productionOrder.invoiceNeeded ? '是' : '否'}}<span style="margin-left:5px"
                v-if="formData.productionOrder.invoiceNeeded">{{formData.productionOrder.invoiceTaxPoint * 100}}%</span></h6>
          </el-col>
          <el-col :span="4">
            <h6>订单数量：{{productionCount}}</h6>
          </el-col>
        </el-row>
        <el-row type="flex" justify="start" style="margin: 10px 0px 0px 24px;">
          <el-col :span="9">
            <h6>订单金额：{{formData.orderAmount}}</h6>
          </el-col>
          <el-col :span="5">
            <h6 class="hide-text" :title="charge">
              负责人：{{charge}}
            </h6>
          </el-col>
          <el-col :span="6">
            <h6 class="hide-text" :title="approver">
              审批人：{{approver}}
            </h6>
          </el-col>
        </el-row>
      </el-col>
      <el-col :span="6" class="financial-border-container">
          <production-contract :slotData="formData.productionOrder" :contracts="contracts" :canSign="false" :readOnly="true"/>
      </el-col>
    </el-row>
    <!-- <div class="financial-info-box">
      <div class="financial-border-container financial-info-one">
        <el-row type="flex" justify="start" align="middle" class="basic-row">
          <h6>订单基本信息</h6>
        </el-row>
        <el-row type="flex" justify="start" align="middle" class="basic-row">
          <el-col :span="11">
            <h6>合作方式：{{getEnum('machiningTypes', formData.productionOrder.cooperationMode)}}</h6>
          </el-col>
          <el-col :span="8">
            <h6>是否开票：{{formData.productionOrder.invoiceNeeded ? '是' : '否'}}</h6>
          </el-col>
          <el-col :span="5" v-if="formData.productionOrder.invoiceNeeded">
            <h6>税率：{{formData.productionOrder.invoiceTaxPoint}}</h6>
          </el-col>
        </el-row>
        <el-row type="flex" justify="start" align="middle" class="basic-row">
          <el-col :span="11">
            <h6>订单数量：{{productionCount}}</h6>
          </el-col>
          <el-col :span="12">
            <h6>订单总金额(元)：{{formData.orderAmount}}</h6>
          </el-col>
        </el-row>
        <div v-if="formData.productionOrder.payPlan">
          <el-row type="flex" justify="start" align="middle" class="basic-row">
            <h6>财务方案</h6>
          </el-row>
          <el-row type="flex" justify="start" align="middle" class="basic-row" v-popover:popover>
            <el-col :span="11">
              <h6>定金：有定金</h6>
            </el-col>
            <el-col :span="12">
              <h6>尾款期数：一期尾款</h6>
            </el-col>
            <el-popover ref="popover" placement="top-start" width="500" trigger="hover">
              <pay-plan-info :form="payPlan"></pay-plan-info>
            </el-popover>
          </el-row>
        </div>
      </div>
      <div style="margin-left: 10px"></div>
      <div class="financial-border-container financial-info-two">
        <el-row type="flex" justify="start" align="middle" class="basic-row">
          <h6>合作商：{{cooperatorName}}</h6>
        </el-row>
        <el-row type="flex" justify="start" align="middle" class="basic-row">
          <el-col :span="12">
            <h6 class="hide-text" :title="cooperatorCharge">
              负责人：{{cooperatorCharge}}
            </h6>
          </el-col>
          <el-col :span="12">
            <h6>联系方式：{{cooperatorPhone}}</h6>
          </el-col>
        </el-row>
        <el-row type="flex" justify="start" align="middle" class="basic-row">
          <h6>人员设置</h6>
        </el-row>
        <el-row type="flex" justify="start" align="middle" class="basic-row">
          <el-col :span="12">
            <h6 class="hide-text" :title="charge">
              负责人：{{charge}}
            </h6>
          </el-col>
          <el-col :span="12">
            <h6 class="hide-text" :title="approver">
              审批人：{{approver}}
            </h6>
          </el-col>
        </el-row>
      </div>
      <div style="margin-left: 10px"></div>
      <div class="financial-border-container financial-info-three">
            <production-contract :slotData="formData.productionOrder" :contracts="contracts" :canSign="false" :readOnly="true"/>
      </div>
    </div> -->
  </div>
</template>

<script>
  import {PayPlanInfo} from '@/components/index.js'
  import ProductionContract from '@/views/order/salesProduction/components/ProductionContract'

  export default {
    name: 'FinancialOrderInfo',
    props: ['formData', 'payPlan', 'belongTo'],
    components: {
      PayPlanInfo,
      ProductionContract
    },
    computed: {
      // 已签合同列表
      contracts: function () {
        if (this.formData.productionOrder.agreements) {
          return this.formData.productionOrder.agreements.filter(item => item.state !== 'INVALID');
        }
        return [];
      },
      cooperatorName: function () {
        if (this.belongTo == 'RECEIVABLE_PAGE' && this.formData.productionOrder.originCooperator) {
          return this.formData.productionOrder.originCooperator.type === 'ONLINE' ? 
            this.formData.productionOrder.originCooperator.partner.name : this.formData.productionOrder.originCooperator.name; 
        } else if (this.belongTo == 'PAYABLE_PAGE' && this.formData.productionOrder.targetCooperator) {
          return this.formData.productionOrder.targetCooperator.type === 'ONLINE' ? 
            this.formData.productionOrder.targetCooperator.partner.name : this.formData.productionOrder.targetCooperator.name; 
        } else {
          return '';
        }
      },
      cooperatorCharge: function () {
        if (this.belongTo == 'RECEIVABLE_PAGE') {
          return this.formData.productionOrder.merchandiser ? this.formData.productionOrder.merchandiser.name : '';
        } else {
          return this.formData.productionOrder.creator ? this.formData.productionOrder.creator.name : '';
        }
      },
      cooperatorPhone: function () {
        if (this.belongTo == 'RECEIVABLE_PAGE') {
          return this.formData.productionOrder.merchandiser ? this.formData.productionOrder.merchandiser.mobileNumber : '';
        } else {
          return this.formData.productionOrder.creator ? this.formData.productionOrder.creator.mobileNumber : '';
        }
      },
      charge: function () {
        if (this.belongTo == 'RECEIVABLE_PAGE') {
          return this.formData.productionOrder.creator ? this.formData.productionOrder.creator.name : '';
        } else {
          return this.formData.productionOrder.merchandiser ? this.formData.productionOrder.merchandiser.name : '';
        }
      },
      approver: function () {
        if (this.belongTo == 'RECEIVABLE_PAGE') {

        } else {
          
        }
      },
      productionCount: function () {
        let count = 0;
        this.formData.productionTaskList.forEach(item => {
          count += item.quantity;
        })
        return count;
      }
    },
    methods: {
    },
    data () {
      return {
      }
    },
    created () {
    },
    destroyed () {
      
    }
  }
</script>

<style scoped>
  .basic-row {
    margin-bottom: 5px;
  }

  .financial-info-box {
    display:table;
    margin:0 auto;
    width: 100%;
  }
  
  .financial-info-one {
    width: 40%;
    display: table-cell;
  }

  .financial-info-two {
    width: 35%;
    display: table-cell;
  }
  
  .financial-info-three {
    width: 25%;
    display: table-cell;
  }

  .financial-border-container{
    border: 2px solid #E5E5E5;
    border-radius: 5px;
    padding: 10px 10px 10px 10px;
  }

  .hide-text {
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    width: 170px;
  }
</style>