<template>
  <el-form :inline="true">
    <el-row type="flex" justify="start">
        <el-form-item label="工单信息" prop="name">
          <el-input placeholder="工单号，产品名或货号" v-model="queryFormData.keyword"></el-input>
        </el-form-item>
        <el-form-item label="部门/人员" prop="name">
          <!-- <el-input placeholder="跟单员姓名" v-model="queryFormData.operatorName"></el-input> -->
          <dept-person-select ref="deptPersonSelect" :dataQuery="dataQuery" width="170"
                                :selectDept="queryFormData.depts" :selectPerson="queryFormData.users"/>
        </el-form-item>
        <el-form-item label="交货日期">
          <el-date-picker
            v-model="dateArr"
            value-format="timestamp"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期">
          </el-date-picker>
        </el-form-item>
        <el-button-group>
          <el-button type="primary" class="toolbar-search_input" @click="onAdvancedSearch">搜索</el-button>
          <el-button native-type="reset" @click="onReset">重置</el-button>
        </el-button-group>
    </el-row>
  </el-form>
</template>

<script>
  import { DeptPersonSelect } from '@/components'
  export default {
    name: 'ProgressOrderToolbar',
    props: ['queryFormData', 'dataQuery'],
    components: {
      DeptPersonSelect
    },
    computed: {

    },
    methods: {
      onAdvancedSearch () {
        this.$emit('onAdvancedSearch');
      },
      onReset () {
        this.queryFormData.keyword = '';
        this.queryFormData.statuses = '';
        this.queryFormData.operatorName = '';
        this.dateArr = null;
        this.$refs.deptPersonSelect.clearSelectData();
        this.$emit('onResetQuery');
      }
    },
    data () {
      return {
        dateArr: ''
      }
    },
    watch: {
      dateArr: function (newVal, oldVal) {
        if (newVal == null) {
          this.queryFormData.expectedDeliveryDateFrom = null;
          this.queryFormData.expectedDeliveryDateTo = null;
        } else {
          this.queryFormData.expectedDeliveryDateFrom = newVal[0];
          this.queryFormData.expectedDeliveryDateTo = newVal[1];
        }
      }
    },
    created () {

    },
    mounted () {

    }
  }
</script>

<style scoped>
  /deep/ .el-date-editor .el-range-separator {
     padding: 0px;
  }

  /deep/ .el-form-item {
     margin-bottom: 5px;
  }

  .toolbar-search_input{
    background-color: #ffd60c;
    border-color: #ffd60c;
  }
</style>
