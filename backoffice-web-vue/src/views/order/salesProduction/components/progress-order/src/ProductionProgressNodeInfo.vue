<template>
  <div>
    <el-dialog :visible.sync="updateFormVisible" width="70%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <progress-report v-if="updateFormVisible" :slotData="selectProgressModel" :belong="slotData"
        @callback="onCallback" @editSubmit="onEditSubmit" />
    </el-dialog>
    <el-row type="flex" justify="space-between">
      <el-steps :active="activeNodeIndex" align-center style="width:100%" finish-status="success">
        <template v-for="(item,index) in slotData.progresses">
          <step :title="item.progressPhase.name" :key="index" @onClick="onEdit(item)">
            <div slot="description">
              <el-row type="flex" justify="center">
                预计完成日期:{{item.estimatedDate | timestampToTime}}
              </el-row>
              <el-row type="flex" justify="center">
                实际完成日期:{{item.finishDate|timestampToTime}}
              </el-row>
              <el-row type="flex" justify="center" style="color: #F56C6C">
                {{getTip(item)}}
              </el-row>
            </div>
          </step>
        </template>
      </el-steps>
    </el-row>
  </div>
</template>

<script>
  // import {
  //   hasPermission
  // } from '@/auth/auth';

  import ProgressReport from './report/ProgressReport';
  import Step from './Step';
  import {
    store,
    mutations
  } from './store';

  export default {
    name: 'ProductionProgressNodeInfo',
    props: ['slotData'],
    components: {
      ProgressReport,
      Step
    },
    computed: {
      selectProgressModel: function () {
        return store.currentProgress;
        // return this.$store.state.ProgressOrdersModule.currentProgress;
      },
      activeNodeIndex: function () {
        if (this.slotData.status == 'COMPLETED') {
          return this.slotData.progresses.length;
        }
        let index = 0;
        if (this.slotData.currentPhase) {
          index = this.slotData.progresses.findIndex(val => val.progressPhase.id == this.slotData.currentPhase.id);
        }
        return index;
      },
    },
    methods: {
      updateProgressModel: mutations.setProgress,
      onEdit(item) {
        item.updateOnly = true;
        this.updateProgressModel(item);
        this.updateFormVisible = !this.updateFormVisible;
      },
      async onEditSubmit() {
        // if (this.compareDate(new Date(), new Date(this.selectProgressModel.estimatedDate))) {
        //   this.$message.error('预计完成时间不能小于当前时间');
        //   return false;
        // }
        // const url = this.apis().updateProgressOfPurchaseOrder(this.slotData.code, this.selectProgressModel.id);
        // this.updateProgressModel(this.selectProgressModel);
        // const result = await this.$http.put(url, this.selectProgressModel);
        // if (result['errors']) {
        //   this.$message.error(result['errors'][0].message);
        //   return;
        // }
        // this.$message.success('更新成功');
        this.updateFormVisible = false;
      },
      async onProgressFinish(item, index) {
        item.updateOnly = false;
        const url = this.apis().updateProgressOfPurchaseOrder(this.slotData.code, item.id);
        const result = await this.$http.put(url, item);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('更新成功');
        this.updateFormVisible = false;
        this.$emit('callback');
      },
      async onCallback() {
        if (this.slotData.orderId != null && this.slotData.orderId != '') {
          //获取对应生产工单详情
          const url = this.apis().getProductionOrderDetail(this.slotData.orderId);
          const result = await this.$http.get(url);
          if (result["errors"]) {
            this.$message.error(result["errors"][0].message);
            return;
          }
          let productionOrder = Object.assign({}, result.data);

          //更新当前生产进度节点详情
          if (productionOrder.taskOrderEntries != null && productionOrder.taskOrderEntries[0] != null) {
            //更新        
            let index = productionOrder.taskOrderEntries[0].progressWorkSheet.progresses.findIndex(item => item.id ==
              this
              .selectProgressModel.id);
            if (index != -1) {
              this.updateProgressModel(productionOrder.taskOrderEntries[0].progressWorkSheet.progresses[index]);
            }
          }
          this.$emit('callback', productionOrder);
        }
      },
      getTip (item) {
        if (this.slotData.status === 'COMPLETED') {
          return '';
        } else if (this.slotData.currentPhase && this.slotData.currentPhase.name === item.progressPhase.name) {
          return item.delayedDays > 0 ? '已延期' + item.delayedDays + '天' : '倒计时' + item.delayedDays + '天';
        }
        return '';
      },
    },
    data() {
      return {
        updateFormVisible: false,
        hackSet: true,
      };
    },
    created() {}
  };

</script>
<style scoped>
  .progress-status {
    font-weight: 500;
    color: rgba(0, 0, 0, 0.85);
    font-size: 12px;
  }

  .progress-vertical-line {
    height: 100px;
    width: 1px;
    background-color: aqua;
  }

  .progress-icon-container {
    background-color: #ffd60c;
    /* background-color: rgb(87, 84, 68); */
    border-radius: 50%;
    width: 35px;
    height: 35px;
    text-align: center;
    line-height: 35px;
  }

  .progress-icon-container_doing {
    background-color: rgba(5, 0, 1, 0.45);
    border-radius: 50%;
    width: 35px;
    height: 35px;
    text-align: center;
    line-height: 35px;
  }

  .progress-icon-container_text {
    font-size: 10px;
    color: #fff;
    line-height: 35px;
  }

  .progress-icon-container_none {
    background-color: #F2EFF0;
    /* background-color: rgb(87, 84, 68); */
    border-radius: 50%;
    width: 35px;
    height: 35px;
    text-align: center;
    line-height: 35px;
  }


  .progress-icon {
    font-size: 24px;
  }

  .progress-line-horizon {
    width: 100%;
    height: 2px;
    border-top: 2px dashed #FFD60C;
  }

  .progress-line-horizon_none {
    width: 100%;
    height: 2px;
    /* border-top: 1px dashed #FFD60C; */
  }

  .progress-line-horizon_grey {
    width: 100%;
    height: 2px;
    border-top: 2px dashed #F2EFF0;
  }

  .progress-line-vertical {
    width: 1px;
    height: 50px;
    border-left: 0.5px solid #FFD60C;
    margin-left: 3px;
    /* margin-left:  */
  }

  .progress-line-vertical_none {
    width: 1px;
    height: 50px;
    border-left: 0.5px solid #F2EFF0;
    margin-left: 3px;
    /* margin-left:  */
  }

  .progress-img {
    width: 90px;
    height: 50px;
    border-radius: 5px;
  }

  .progress-info {
    font-weight: 400;
    color: rgba(0, 0, 0, 0.65);
    font-size: 10px;
  }

  .progress-row {
    margin-top: 2px;
  }

  .progress-info-row {
    text-align: center;
  }

  .progress-block {
    padding-top: 10px;
    padding-bottom: 10px;
  }


  .progress-block-modal {
    position: absolute;
    background-color: rgba(255, 214, 12, 0.35);
    /* width: 100%; */
    height: 80%;
    /* left: 0px; */
    top: 0px;
    z-index: 2;
  }

  .progress-block-modal-row {
    height: 100%;
    width: 100%;
  }

</style>
