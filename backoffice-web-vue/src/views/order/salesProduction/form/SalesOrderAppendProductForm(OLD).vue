<template>
  <div class="animated fadeIn">
    <el-dialog :visible.sync="materialDialogVisible" width="90%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <sample-products-select-dialog v-if="materialDialogVisible" @onSelectSample="onSelectSample" />
    </el-dialog>
    <el-dialog :visible.sync="dialogVisible" width="90%" class="purchase-dialog" :close-on-click-modal="false"
      append-to-body>
      <sample-accounting-sheet-form v-if="dialogVisible" :slot-data="openAccountingSheet"
        @onSave="onAccountingSheetSave" :sampleSpecEntries="openSampleSpecEntries"
        :unitPrice="openAccountingSheetUnitPrice" />
    </el-dialog>
    <el-dialog :visible.sync="viewDialogVisible" width="90%" class="purchase-dialog" :close-on-click-modal="false"
      append-to-body>
      <sample-accounting-sheet :slot-data="openAccountingSheet" :sampleSpecEntries="openSampleSpecEntries"
        :unitPrice="openAccountingSheetUnitPrice" v-if="viewDialogVisible" :readOnly="readOnly" />
    </el-dialog>
    <el-form :model="appendProductForm" ref="appendProductForm" label-position="left" :disabled="readOnly">
      <template v-for="(entry, productIndex) in appendProductForm.sampleList">
        <div :key="productIndex">
          <el-row class="info-sales-row" type="flex" justify="space-between" align="middle" :gutter="20">
            <el-col :span="16">
              <el-row type="flex" align="middle">
                <el-col :span="14" style="padding-top:25px">
                  <el-form-item :prop="'sampleList.' + productIndex + '.product.name'" label="产品名" label-width="100px"
                    :rules="{required: true, message: '不能为空', trigger: 'blur'}">
                    <el-input placeholder="名称" v-model="entry.product.name" size="mini" :disabled="true"></el-input>
                  </el-form-item>
                </el-col>
                <el-col :span="2">
                  <el-button style="margin-left: 10px" @click="appendSample(productIndex)" size="mini"
                    :disabled="isUpdate">点击选择</el-button>
                </el-col>
              </el-row>
            </el-col>
            <el-col :span="2">
              <el-row type="flex" align="middle">
                <el-button class="remove-btn" v-if="productIndex!=0" @click="removeRow(productIndex)">删除</el-button>
              </el-row>
            </el-col>
          </el-row>
          <el-row type="flex" v-if="entry.product.code != null" class="info-order-row">
            <img class="purchase-product-img"
              :src="entry.product.thumbnail!=null&&entry.product.thumbnail.length!=0?entry.product.thumbnail.url:'static/img/nopicture.png'">
            <table cellspacing="2" width="100%" :height="(appendProductForm.sampleList.length+1)*50"
              class="order-table">
              <tr class="order-table-th_row">
                <td style="width: 40px">颜色</td>
                <template v-for="size in entry.sizes">
                  <th :key="size.name">{{size.name}}</th>
                </template>
                <th>小计</th>
              </tr>
              <template v-for="color in entry.colors">
                <tr :key="'tr'+color.code">
                  <td>{{color.name}}</td>
                  <template v-for="size in entry.sizes">
                    <td style="width:80px" :key="'td'+size.name">
                      <el-input class="order-table-input" type="number" @mousewheel.native.prevent :min="1"
                        v-model="getEntryByColorSize(color, size, entry.colorSizeEntries).quantity">
                      </el-input>
                    </td>
                  </template>
                  <td style="width:100px">{{countColorsAmount(color, entry.colorSizeEntries)}}</td>
                </tr>
              </template>
              <tr>
                <td :colspan="getColspanLength(entry.sizes.length)">合计</td>
                <td>{{countTotalAmount(entry.colorSizeEntries)}}</td>
              </tr>
            </table>
          </el-row>
          <el-row type="flex" :gutter="10">
            <el-col :span="8">
              <el-row type="flex" align="middle">
                <el-form-item :prop="'sampleList.' + productIndex + '.unitPrice'" label="订单报价" label-width="100px"
                  :rules="{required: true, message: '不能为空', trigger: 'blur'}">
                  <el-input placeholder="订单报价" v-model="entry.unitPrice" v-number-input.float="{ min: 0 ,decimal:2}"
                    size="mini">
                  </el-input>
                </el-form-item>
              </el-row>
            </el-col>
            <el-col :span="8">
              <el-row type="flex" align="middle">
                <el-form-item :prop="'sampleList.' + productIndex + '.deliveryDate'" label="交货日期" label-width="100px"
                  :rules="{required: true, message: '不能为空', trigger: 'blur'}">
                  <el-date-picker v-model="entry.deliveryDate" type="date" placeholder="选择日期">
                  </el-date-picker>
                </el-form-item>
              </el-row>
            </el-col>
          </el-row>
          <el-row style="margin-top:20px;">
            <sample-attach-orders-form :entries.sync="entry.materialsSpecEntries" :medias.sync="entry.medias"
              :productionProcessContent.sync="entry.productionProcessContent"
              :productsColors="getColorsByEntries(entry.colorSizeEntries)" />
          </el-row>
          <el-row style="margin-top:20px;" type="flex" align="center" :gutter="10">
            <el-col :span="4">
              <el-button class="product-form-btn" @click="onCreateAccountingSheet(productIndex)"
                :disabled="entry.costOrder.isIncludeTax!=null">创建成本核算单</el-button>
            </el-col>
            <el-col :span="2">
              <h6 style="padding-top:8px">核算单：</h6>
            </el-col>
            <el-col :span="18">
              <h6 class="account_sheet-btn" @click="onUpdateAccountingSheet(productIndex)"
                v-if="entry.costOrder.isIncludeTax!=null">
                {{entry.costOrder.id!=null?entry.costOrder.id:'成本核算单'}}
              </h6>
            </el-col>
          </el-row>
        </div>
      </template>
      <el-row type="flex" justify="center" class="info-order-row" align="middle" style="margin-top: 20px"
        v-if="!isUpdate">
        <el-col :span="24">
          <div class="order-purchase-table-btn_add" @click="addRow">
            +添加另一款产品
          </div>
        </el-col>
      </el-row>
    </el-form>
    <el-row type="flex" justify="center" style="margin-top: 20px" v-if="!readOnly">
      <el-button class="material-btn" @click="onSubmit">{{isUpdate?'保存':'添加产品'}}</el-button>
    </el-row>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';

  const {
    mapGetters,
    mapMutations,
    mapActions
  } = createNamespacedHelpers('SampleProductsModule');

  import SampleProductsSelectDialog from '@/views/product/sample/components/SampleProductsSelectDialog';
  import SampleAttachOrdersForm from '@/views/product/sample/form/SampleAttachOrdersForm';
  import SampleAccountingSheetForm from '@/views/product/sample/form/SampleAccountingSheetForm';
  import SampleAccountingSheet from '@/views/product/sample/components/SampleAccountingSheet';
  export default {
    name: 'SalesOrderAppendProductForm',
    components: {
      SampleAccountingSheetForm,
      SampleAccountingSheet,
      SampleAttachOrdersForm,
      SampleProductsSelectDialog,
    },
    props: {
      isUpdate: {
        type: Boolean,
        default: false
      },
      updataEntry: {
        type: Object,
      },
      readOnly: {
        type: Boolean,
        default: false
      }
    },
    computed: {
      ...mapGetters({
        slotData: 'newFormData'
      })
    },
    data() {
      return {
        materialDialogVisible: false,
        openAccountingSheet: {},
        openAccountingSheetUnitPrice: null,
        openSampleSpecEntries: [],
        appendProductForm: {
          sampleList: [{
            product: {

            },
            colorSizeEntries: [],
            unitPrice: '',
            deliveryDate: '',
            materialsSpecEntries: [],
            productionProcessContent: '',
            medias: [],
            costOrder: {},
          }],
        },
        currentProductIndex: 0,
        dialogVisible: false,
        viewDialogVisible: false,
      }
    },
    methods: {
      appendSample(index) {
        this.currentProductIndex = index;
        this.materialDialogVisible = true;
      },
      onSelectSample(data) {
        //构建颜色尺码行
        var colorSizeEntries = [];
        data.colorSizes.forEach(color => {
          color.sizes.forEach(size => {
            colorSizeEntries.push({
              color: {
                code: color.colorCode,
                name: color.colorName,
                id: color.colorId
              },
              size: {
                code: size.code,
                name: size.name,
                id: size.id
              },
              quantity: ''
            })
          });
        });

        //设置对应颜色，尺码数组                    
        var entry = {
          product: data,
          colorSizeEntries: colorSizeEntries,
          unitPrice: '',
          deliveryDate: '',
          materialsSpecEntries: data.entries,
          productionProcessContent: '',
          medias: [],
          costOrder: {},
          colors: this.getColorsByEntries(colorSizeEntries),
          sizes: this.getSizesByEntries(colorSizeEntries),
        }

        var newEntry = Object.assign(this.appendProductForm.sampleList[this.currentProductIndex], entry);

        //通过set 赋值刷新渲染视图
        this.$set(this.appendProductForm.sampleList, this.currentProductIndex, newEntry);

        this.materialDialogVisible = false;
      },
      //获取样衣颜色
      getColorsByEntries(colorSizeEntries) {
        var colors = [];
        colorSizeEntries.forEach(entry => {
          let index = colors.findIndex(element => element.code == entry.color.code);
          if (index == -1) {
            colors.push(entry.color);
          }
        });
        return colors;
      },
      //获取样衣尺码
      getSizesByEntries(colorSizeEntries) {
        var sizes = [];
        colorSizeEntries.forEach(entry => {
          let index = sizes.findIndex(element => element.code == entry.size.code);
          if (index == -1) {
            sizes.push(entry.size);
          }
        });
        return sizes;
      },
      getEntryByColorSize(color, size, colorSizeEntries) {
        let index = colorSizeEntries.findIndex(entry => entry.color.code == color.code && entry.size.code == size.code);
        if (index != -1) {
          return colorSizeEntries[index];
        } else {
          //没找到，则创建对应对象
          var newObj = {
            color: color,
            size: size,
            quantity: '',
          };
          colorSizeEntries.push(newObj);
          return newObj;
        }
      },
      removeRow(index) {
        this.appendProductForm.sampleList.splice(index, 1);
      },
      countColorsAmount(color, colorSizeEntries) {
        var amount = 0;
        colorSizeEntries.filter(entry => entry.color.code == color.code).forEach(entry => {
          let num = parseFloat(entry.quantity);
          if (!Number.isNaN(num)) {
            amount += num;
          }
        });
        return amount;
      },
      countTotalAmount(colorSizeEntries) {
        var amount = 0;
        colorSizeEntries.forEach(entry => {
          let num = parseFloat(entry.quantity);
          if (!Number.isNaN(num)) {
            amount += num;
          }
        });
        return amount;
      },
      getColspanLength(size) {
        return size + 1;
      },
      getColorSize(color, size, colorSizes) {
        var result = colorSizes.filter(item => {
          if (item.colorName == color.colorName) {
            const index = item.sizes.findIndex(val => val.name == size.name);
            return index > -1;
          }
        })
        if (result.length != 0) {
          for (let i = 0; i < result[0].sizes.length; i++) {
            if (result[0].sizes[i].name == size.name) {
              return result[0].sizes[i];
            }
          }
        } else {
          return null;
        }
      },
      onCreateAccountingSheet(productIndex) {
        this.currentProductIndex = productIndex;
        this.openAccountingSheetUnitPrice = this.appendProductForm.sampleList[productIndex].unitPrice;
        this.$set(this, 'openSampleSpecEntries', this.appendProductForm.sampleList[productIndex].materialsSpecEntries);
        // this.openSampleSpecEntries = this.appendProductForm.sampleList[productIndex].materialsSpecEntries;
        this.openAccountingSheet = {
          'isIncludeTax': true,
          'remarks': '',
          'totalPrice': 0,
          'materialsEntries': [],
          'specialProcessEntries': [],
          'laborCostEntries': []
        };
        this.$nextTick(() => {
          this.dialogVisible = true;
        });
      },
      onUpdateAccountingSheet(index) {
        this.currentProductIndex = index;
        this.openAccountingSheetUnitPrice = this.appendProductForm.sampleList[index].unitPrice;
        this.$set(this, 'openSampleSpecEntries', this.appendProductForm.sampleList[index].materialsSpecEntries);
        this.openAccountingSheet = this.appendProductForm.sampleList[index].costOrder;
        this.viewDialogVisible = true;
      },
      onAccountingSheetSave(sheet) {
        this.$set(this.appendProductForm.sampleList[this.currentProductIndex], 'costOrder', sheet);
        this.dialogVisible = false;
      },
      addRow() {
        var newEntry = {
          product: {

          },
          colorSizeEntries: [],
          unitPrice: '',
          deliveryDate: '',
          materialsSpecEntrie: [],
          productionProcessContent: '',
          medias: [],
          costOrder: {},
        };
        this.appendProductForm.sampleList.push(newEntry);
      },
      onSubmit() {
        //获取各层级form
        var forms = [];
        forms.push(this.$refs.appendProductForm);
        // 使用Promise.all 并行去校验结果
        Promise.all(forms.map(this.getFormPromise)).then(res => {
          const validateResult = res.every(item => !!item);
          if (validateResult) {
            this.$emit('onSave', this.appendProductForm.sampleList);
          } else {
            this.$message.error('请完善信息');
          }
        });
      },
      //封装Promise对象
      getFormPromise(form) {
        return new Promise(resolve => {
          form.validate(res => {
            resolve(res);
          })
        })
      }
    },
    created() {
      if (this.isUpdate && this.updataEntry != null) {
        var entryJson = JSON.stringify(this.updataEntry);
        var entry = JSON.parse(entryJson);
        var newEntry = Object.assign(this.appendProductForm.sampleList[0], entry);
        //通过set 赋值刷新渲染视图
        this.$set(newEntry, 'colors', this.getColorsByEntries(newEntry.colorSizeEntries));
        this.$set(newEntry, 'sizes', this.getSizesByEntries(newEntry.colorSizeEntries));
        this.$set(this.appendProductForm.sampleList, 0, newEntry);
      }
    }
  }

</script>
<style src="../css/sales-plan-append-product.css"></style>
