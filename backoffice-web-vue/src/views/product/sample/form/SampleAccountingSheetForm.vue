<template>
  <div>
    <el-form :model="slotData" ref="accountingSheetForm">
      <el-tabs value="first" type="card">
        <el-tab-pane label="成本预算单" name="first">
          <el-row type="flex">
            <el-col :span="6">
              <el-radio v-model="slotData.isIncludeTax" @change="onIncludeTaxChange" :label="true">含税</el-radio>
              <el-radio v-model="slotData.isIncludeTax" @change="onIncludeTaxChange" :label="false">不含税</el-radio>
            </el-col>
            <el-col :span="12">
              <el-checkbox v-model="hasMaterial" :disabled="needMaterialAccounting">面辅料</el-checkbox>
              <el-checkbox v-model="hasSpecial" :disabled="true">特殊工艺</el-checkbox>
              <el-checkbox v-model="hasLabor" :disabled="true">工费及其他</el-checkbox>
            </el-col>
          </el-row>
          <div>
            <div class="d1">
              <template v-if="hasMaterial">
                <el-divider></el-divider>
                <el-row type="flex" align="center">
                  <el-col :span="1" class="form-column">
                    <h6 class="accounting-form-title">面辅料</h6>
                  </el-col>
                  <el-col :span="23">
                    <material-accounting-form :slotData="slotData.materialsEntries" :taxIncluded="slotData.isIncludeTax"
                      :sampleSpecEntries="sampleSpecEntries" />
                  </el-col>
                </el-row>
              </template>
              <el-divider></el-divider>
              <el-row type="flex" align="center">
                <el-col :span="1" class="form-column">
                  <h6 class="accounting-form-title">特殊工艺</h6>
                </el-col>
                <el-col :span="23">
                  <craft-accounting-form :slotData="slotData.specialProcessEntries"
                    :taxIncluded="slotData.isIncludeTax" />
                </el-col>
              </el-row>
              <el-divider></el-divider>
              <el-row type="flex" align="center">
                <el-col :span="1" class="form-column">
                  <h6 class="accounting-form-title">工费及其他</h6>
                </el-col>
                <el-col :span="23">
                  <other-accounting-form :slotData="slotData.laborCostEntries" :taxIncluded="slotData.isIncludeTax" />
                </el-col>
              </el-row>
              <div class="sheet-total">
                <el-row type="flex" align="center" justify="end">
                  <div class="sheet-total-title">
                    <el-row type="flex" justify="center" align="center">
                      <h6>总计价格</h6>
                    </el-row>
                  </div>
                  <div style="width:160px;text-align:center">
                    <h6>￥{{totalPrice}}</h6>
                  </div>
                </el-row>
              </div>
              <div class="sheet-total_2" style="margin-top:0px">
                <el-row type="flex" align="center" justify="end">
                  <div class="sheet-total-title_2">
                    <el-row type="flex">
                      <el-col :span="3" class="sheet-total-cell">销售单价</el-col>
                      <el-col :span="4" class="sheet-total-cell">{{unitPrice!=null?unitPrice:''}}元</el-col>
                      <el-col :span="3" class="sheet-total-cell">预计单价成本</el-col>
                      <el-col :span="4" class="sheet-total-cell">{{totalPrice}}</el-col>
                      <el-col :span="3" class="sheet-total-cell">预计单件利润</el-col>
                      <el-col :span="4" class="sheet-total-cell">
                        {{unitPrice!=null?(unitPrice-totalPrice).toFixed(2):''}}元</el-col>
                      <el-col :span="3" class="sheet-total-cell">预计单件利润率</el-col>
                    </el-row>
                  </div>
                  <div style="width:160px;text-align:center">
                    <h6 class="total_profit">{{countProfit()}}%
                    </h6>
                  </div>
                </el-row>
              </div>
              <div class="d2">
                <div class="divider" />
              </div>
            </div>
          </div>
          <el-row type="flex" align="center" style="margin-top:10px;">
            <el-col :span="1" class="form-column">
              <h6 class="accounting-form-title">备注</h6>
            </el-col>
            <el-col :span="23">
              <el-input v-model="slotData.remarks" placeholder="输入备注" type="textarea" :rows="5"></el-input>
            </el-col>
          </el-row>
          <el-row type="flex" justify="center" align="middle" style="margin-top: 10px">
            <el-button size="medium" class="sure-button" @click="onSave">提交</el-button>
          </el-row>
        </el-tab-pane>
      </el-tabs>
    </el-form>
  </div>
</template>

<script>
  import MaterialAccountingForm from "./MaterialAccountingForm";
  import CraftAccountingForm from "./CraftAccountingForm";
  import OtherAccountingForm from "./OtherAccountingForm";

  export default {
    name: "SampleAccountingSheetForm",
    props: {
      slotData: {
        type: Object,
      },
      sampleSpecEntries: {
        type: Array,
        default: () => {
          return [];
        }
      },
      unitPrice: {},
      needMaterialAccounting: {
        type: Boolean,
        default: true
      }
    },
    components: {
      MaterialAccountingForm,
      CraftAccountingForm,
      OtherAccountingForm,
    },
    computed: {
      totalPrice: function () {
        let price1 = 0;
        let price2 = 0;
        let price3 = 0;

        if (this.slotData.materialsEntries != null) {
          this.slotData.materialsEntries.forEach(element => {
            let sum = parseFloat(element.materialsSpecEntry.unitQuantity * (1 + parseFloat(element
              .materialsSpecEntry
              .lossRate)) * (this
              .slotData
              .isIncludeTax ?
              element.unitPriceIncludingTax : element.unitPriceExcludingTax));
            if (sum != null && !isNaN(sum)) {
              price1 += sum;
            }
          });
        }
        if (this.slotData.specialProcessEntries != null) {
          this.slotData.specialProcessEntries.forEach(element => {
            let sum = parseFloat(this
              .slotData
              .isIncludeTax ? element.unitPriceIncludingTax : element.unitPriceExcludingTax);
            if (sum != null && !isNaN(sum)) {
              price2 += sum;
            }
          });
        }

        if (this.slotData.laborCostEntries != null) {
          this.slotData.laborCostEntries.forEach(element => {
            let sum = parseFloat(this
              .slotData
              .isIncludeTax ? element.unitPriceIncludingTax : element.unitPriceExcludingTax);
            if (sum != null && !isNaN(sum)) {
              price3 += sum;
            }
          });
        }

        return (price1 + price2 + price3).toFixed(2);
      }
    },
    methods: {
      onSave() {
        this.$refs['accountingSheetForm'].validate((valid) => {
          if (valid) {
            //设置总价
            this.$set(this.slotData, 'totalPrice', this.totalPrice);
            this.$emit('onSave', this.slotData);
          } else {
            this.$message.error('请完善表格');
            return false;
          }
        });
      },
      onIncludeTaxChange(val) {
        // this.$refs['accountingSheetForm'].validate();
      },
      countProfit() {
        if (this.unitPrice == null || this.unitPrice == '') {
          return '';
        }
        let result = (((parseFloat(this.unitPrice) - this.totalPrice) / parseFloat(this.unitPrice)) * 100).toFixed(2);

        if (Number.isNaN(result)) {
          return '';
        } else {
          return result;
        }
      }
    },

    data() {
      return {
        remark: '',
        hasMaterial: this.needMaterialAccounting,
        hasSpecial: true,
        hasLabor: true
      };
    },
    created() {
      //若有物料项
      if (this.slotData.materialsEntries != null && this.slotData.materialsEntries.length > 0) {
        this.hasMaterial = true;
      }
    }
  };

</script>
<style scoped>
  .accounting-form-title {
    width: 20px;
    text-align: center;
    line-height: 20px;
  }

  .form-column {
    align-items: center;
    display: flex;
    display: -webkit-flex;
    justify-content: center;
  }

  .sheet-total-title {
    flex-grow: 1;
  }

  .sheet-total-title_2 {
    flex-grow: 1;
  }

  .sheet-total {
    padding-top: 8px;
    padding-bottom: 5px;
    margin-top: 24px;
    border-top: 1px solid #DCDFE6;
    border-bottom: 1px solid #DCDFE6;
  }

  .sheet-total_2 {
    margin-top: 24px;
    border-bottom: 1px solid #DCDFE6;
  }

  .d1 {
    z-index: 1;
    position: relative;
  }

  .d2 {
    z-index: 100;
  }

  .divider {
    position: absolute;
    border-left: 1px solid #DCDFE6;
    height: 100%;
    width: 1px;
    top: 0px;
    right: 160px;
    /* margin-right: 110px; */
  }

  .sure-button {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 90px;
    height: 35px;
  }


  .sheet-total-cell {
    border-right: 1px solid #DCDFE6;
    line-height: 100%;
    height: 100%;
    padding-top: 10px;
    padding-bottom: 10px;
    text-align: center;
  }

  .total_profit {
    padding-top: 10px;
    color: red;
  }

</style>
