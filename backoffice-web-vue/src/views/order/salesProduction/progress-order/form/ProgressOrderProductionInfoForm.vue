<template>
  <div>
    <el-row class="progress-row" align="middle">
      <el-row>
        <el-col>
          <h6>生产信息</h6>
        </el-col>
      </el-row>
      <el-row type="flex" justify="start" class="progress-basic-row">
        <el-col>
          <el-form-item label="产品名：">
            <h6 style="margin-bottom: 0px;margin-top: 8px">{{formData.product.name}}</h6>
          </el-form-item>
        </el-col>
      </el-row>
<!--        <el-col :span="6">-->
<!--          <el-form-item label="产品名">-->
<!--            <el-input :disabled="true"></el-input>-->
<!--          </el-form-item>-->
<!--        </el-col>-->
<!--        <el-col :span="4">-->
<!--          <el-button>点击选择</el-button>-->
<!--        </el-col>-->
    </el-row>
    <el-row class="info-basic-row" type="flex">
      <el-col :span="2" :offset="2">
        <img width="60px" height="60px"
             :src="formData.product.thumbnail!=null && formData.product.thumbnail.length != 0 ?
             formData.product.thumbnail.url : 'static/img/nopicture.png'">
      </el-col>
      <!-- 商品color/size表 -->
      <el-col :span="20">
        <el-row>
          <el-table :data="showData" border  :span-method="arraySpanMethod"
                    :header-cell-style="{'text-align':'center'}"
                    :cell-style="{'text-align':'center'}">
            <el-table-column label="属性" prop="colorName"></el-table-column>
            <template v-for="(item, index) in sizeList">
              <el-table-column :label="item" :prop="item"></el-table-column>
            </template>
            <el-table-column label="合计" prop="colorCount"></el-table-column>
          </el-table>
        </el-row>
        <el-row type="flex" justify="center" align="center" class="info-basic-row">
          <i class="iconfont icon_arrow" v-if="!showTable" @click="onClickShowTable">&#xe714;&nbsp;展开列表</i>
          <i class="iconfont icon_arrow" v-if="showTable" @click="onClickShowTable">&#xe713;&nbsp;收回列表</i>
        </el-row>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: 'ProgressOrderProductionInfoForm',
    props: {
      formData: {
        type: Object
      },
      isRead: {
        type: Boolean,
        default: false
      }
    },
    methods: {
      // 构建color/size表数据
      initColorSizeData () {
        this.colorSizeData = [];
        let row = {};
        let tableCount = 0;
        let index;
        let indexS;
        this.formData.colorSizeEntries.forEach(item => {
          index = this.colorSizeData.findIndex(val => val.colorName == item.color.name);
          if (index > -1) {
            this.colorSizeData[index][item.size.name] = item.quantity;
            this.colorSizeData[index].colorCount += item.quantity;
            tableCount += item.quantity;
          } else {
            row.colorName = item.color.name;
            row[item.size.name] = item.quantity;
            row.colorCount = item.quantity;
            tableCount += item.quantity;
            this.colorSizeData.push(row);
            row = {};
          }
          indexS = this.sizeList.findIndex(val => val == item.size.name);
          if (indexS < 0) {
            this.sizeList.push(item.size.name);
          }
        })
        this.colorSizeData.push({
          colorName: '合计',
          colorCount: tableCount
        });
        // this.formData.entries.forEach(item => {
        //   let index = this.colorSizeData.findIndex(val => val.colorName == item.product.color.name);
        //   if (index > -1) {
        //     this.colorSizeData[index][item.product.size.name] = item.quantity;
        //     this.colorSizeData[index].colorCount += item.quantity;
        //     tableCount += item.quantity;
        //   } else {
        //     row.colorName = item.product.color.name;
        //     row[item.product.size.name] = item.quantity;
        //     row.colorCount = item.quantity;
        //     tableCount += item.quantity;
        //     this.colorSizeData.push(row);
        //     row = {};
        //   }
        //   let indexS = this.sizeList.findIndex(val => val == item.product.size.name);
        //   if (indexS < 0) {
        //     this.sizeList.push(item.product.size.name);
        //   }
        // })
        // this.colorSizeData.push({
        //   colorName: '合计',
        //   colorCount: tableCount
        // });
        this.showData = [this.colorSizeData[0]];
      },
      // 展开/收起列表行
      onClickShowTable () {
        this.showTable = !this.showTable;
        if (this.showTable) {
          this.showData = this.colorSizeData;
          return;
        }
        this.showData = [this.colorSizeData[0]];
      },
      arraySpanMethod ({ row, column, rowIndex, columnIndex }) {
        if (rowIndex == this.colorSizeData.length - 1) {
          const length = this.sizeList.length + 1;
          if (columnIndex === 0) {
            return [1, length];
          } else if (columnIndex != length) {
            return [0, 0];
          }
        }
      }
    },
    data () {
      return {
        showData: [],
        colorSizeData: [],
        showTable: false,
        sizeList: []
      }
    },
    watch: {
      'formData.colorSizeEntries': function (newVal, oldVal) {
        if (newVal.length > 0) {
          this.initColorSizeData();
        }
      }
    },
    created () {
      this.initColorSizeData();
    }
  }
</script>

<style scoped>
  .progress-row {
    padding-left: 10px;
    margin-top: 20px;
  }

  .progress-basic-row {
    padding-left: 20px;
  }

  .icon_arrow {
    font-family: "iconfont" !important;
    font-size: 12px;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.65);
    font-style: normal;
    -webkit-font-smoothing: antialiased;
    -webkit-text-stroke-width: 0.2px;
    -moz-osx-font-smoothing: grayscale;
    cursor: pointer;
  }

  .info-basic-row {
    margin-top: 10px;
  }

  /deep/ .el-table--enable-row-hover .el-table__body tr:hover > td {
    background-color: #FFFFFF !important;
  }
</style>
