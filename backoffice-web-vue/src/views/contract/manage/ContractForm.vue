<template>
  <div>
    <contract-steps :step="2"/>
    <!-- 合同模板选择 -->
    <el-dialog :destroy-on-close="true" :visible.sync="dialogTemplateVisible" width="80%" class="purchase-dialog"
               append-to-body :close-on-click-modal="false">
      <Authorized :permission="['AGREEMENT_TMPL_CREATE']">
        <el-button class="product-select-btn" @click="onCreateTemp">创建模板</el-button>
      </Authorized>
      <el-divider direction="vertical"></el-divider>
      <el-button class="product-select-btn" @click="onFileSelectSure">确定</el-button>
      <contract-template-select :tempType="tempType" @fileSelectChange="onFileSelectChange" ref="contractTemplateSelect"/>
    </el-dialog>
    <!-- 合同模板 创建 -->
    <el-dialog :visible.sync="tempFormVisible" class="purchase-dialog" width="80%" append-to-body :close-on-click-modal="false">
      <template-form v-if="tempFormVisible" @contractTemplateSelect="contractTemplateSelect"
                     :tempFormVisible="tempFormVisible" :slotData="templateData" :templateId="templateId"
                     v-on:turnTempFormVisible="turnTempFormVisible"/>
    </el-dialog>
    <!-- 订单选择 -->
    <el-dialog :visible.sync="dialogOrderVisible" width="80%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <contract-order-select v-if="dialogOrderVisible" @onOrderSelectChange="onOrderSelectChange"/>
    </el-dialog>
    <!-- 选择框架合同 -->
    <el-dialog :visible.sync="dialogContractVisible" width="80%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <el-button-group>
        <el-button class="product-select-btn" @click="onContractSelectSure">确定</el-button>
      </el-button-group>
      <contract-select :mockData="mockData" @fileSelectChange="onContractSelectChange"/>
    </el-dialog>
    <!-- 预览合同 -->
    <el-dialog :visible.sync="dialogPreviewVisible" width="80%" :close-on-click-modal="false">
      <el-row slot="title">
        <el-button>生成合同</el-button>
      </el-row>
      <contract-preview/>
    </el-dialog>
    <!-- 合同详情pdf -->
    <el-dialog :visible.sync="pdfVisible" :show-close="true" style="width: 100%" :close-on-click-modal="false">
      <contract-preview-pdf :fileUrl="fileUrl" :slotData="thisContract"/>
    </el-dialog>
    
    <el-form ref="requirementForm" label-position="left" label-width="88px" hide-required-asterisk>
      <el-row type="flex" justify="center" align="middle">
        <span class="create-contract-title">委托生产合同</span>
      </el-row>
      <contract-type-select :isSignedPaper="isSignedPaper" @contractTypeChange="onContractTypeChange" class="contractTypeSelect"/>
      <el-row class="create-contract-row" type="flex" justify="start" v-if="contractType!='3'">
        <el-col :push="2" :span="8">
          <span class="tips">合同类型</span>
          <el-radio v-model="contractType" label="1" :disabled="isSignedPaper">模板合同</el-radio>
          <el-radio v-model="contractType" label="2">自定义合同上传</el-radio>
        </el-col>
      </el-row>
      <el-row class="create-contract-row">
        <el-col :span="20" :offset="2">
          <el-input size="small" placeholder="选择订单" :value="ordersCodeStr" :disabled="true">
            <template slot="prepend">关联订单</template>
            <el-button slot="append" :disabled="orderReadOnly" @click="dialogOrderVisible=true" class="select-btn">选择订单</el-button>
          </el-input>
        </el-col>
      </el-row>
      <el-row class="create-contract-row" v-if="contractType=='1'">
        <el-col :span="20" :offset="2">
          <el-input size="small" placeholder="选择合同模板" v-model="selectFile.title" :disabled="true">
            <template slot="prepend">合同模板</template>
            <el-button slot="append" @click="selectTemp('')" class="select-btn">选择模板</el-button>
          </el-input>
        </el-col>
      </el-row>
      <el-row class="create-contract-row" v-if="contractType!='1'">
        <el-col :span="20" :offset="2">
          <el-input size="small" placeholder="请输入合同编号" v-model="contractCode">
            <template slot="prepend">合同编号</template>
          </el-input>
        </el-col>
      </el-row>
      <el-row class="create-contract-row" v-if="contractType === '2'">
        <el-col :span="8" :offset="2">
          <p-d-f-upload ref="pdfUpload" :vFileList.sync="pdfFile" :fileLimit="1"></p-d-f-upload>
          <!-- <el-upload name="file" :action="mediaUploadUrl" list-type="picture-card" :data="uploadFormData"
                     :before-upload="onBeforeUpload" :on-success="onSuccess" :headers="headers"
                     :on-exceed="handleExceed"
                     :file-list="fileList" :on-preview="handlePreview" multiple :limit="1" :on-remove="handleRemove">
            <div slot="tip" class="el-upload__tip" v-if="contractType !== '3'">只能上传PDF文件</div>
            <i class="el-icon-plus"></i>
            <div slot="file" slot-scope="{file}">
              <img class="el-upload-list__item-thumbnail" src="static/img/pdf.png" alt="">
              <span class="el-upload-list__item-actions">
                <span v-if="!disabled" class="el-upload-list__item-delete" @click="handleRemove(file)">
                  <i class="el-icon-delete"></i>
                </span>
                <span v-if="!disabled" class="el-upload-list__item-file-name">
                  {{file.name}}
                </span>
              </span>
            </div>
          </el-upload> -->
        </el-col>
      </el-row>
      <el-row class="create-contract-row" v-if="contractType === '3'">
        <el-col :span="22" :offset="2">
          <images-upload ref="imagesUpload" :slotData="paperList" :limit="99" :uploadType="uploadType"></images-upload>
        </el-col>
      </el-row>
      <!--      <el-row class="create-contract-row" v-if="contractType=='1'" type="flex" justify="start">-->
      <!--        <el-col :push="2" :span="8">-->
      <!--          <span class="tips">合同类型</span>-->
      <!--          <el-radio v-model="hasFrameworkContract" :label="false">无框架合同</el-radio>-->
      <!--          <el-radio v-model="hasFrameworkContract" :label="true">有框架合同</el-radio>-->
      <!--        </el-col>-->
      <!--        <el-col v-if="hasFrameworkContract" :span="5" :offset="2">-->
      <!--          <el-input size="small" placeholder="选择框架协议" v-model="selectContract.title" :disabled="true">-->
      <!--            <el-button slot="prepend" @click="openKJHTSelect">选择已签协议</el-button>-->
      <!--          </el-input>-->
      <!--        </el-col>-->
      <!--      </el-row>-->
      <!-- <el-row class="create-contract-row" type="flex" justify="start">
        <el-col :push="2" :span="8">
          <span class="tips">我的身份</span>
          <el-radio v-model="partyA" :label="true">我是甲方</el-radio>
          <el-radio v-model="partyA" :label="false">我是乙方</el-radio>
        </el-col>
      </el-row> -->
      <el-row class="create-contract-row" type="flex" justify="center">
        <el-col :span="4" :offset="-2">
          <!--          <el-button class="create-contract-button" @click="dialogPreviewVisible=true">预览合同</el-button>-->
        </el-col>
        <el-col :span="4" :offset="2">
          <el-button v-if="contractType == '1'" class="create-contract-button" @click="onSave">生成合同</el-button>
          <el-button v-else class="create-contract-button" @click="onSavePdf">生成合同</el-button>
        </el-col>
      </el-row>
    </el-form>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';
  import ContractTypeSelect from './components/ContractTypeSelect';
  import ContractTemplateSelect from './components/ContractTemplateSelect';
  import ContractPreview from './components/ContractPreview';
  import ContractOrderSelect from './components/ContractOrderSelect';
  import http from '@/common/js/http';
  import TemplateForm from '../../contract/template/components/TemplateForm';
  import Bus from '@/common/js/bus.js';
  import ContractPreviewPdf from './components/ContractPreviewPdf'
  import ContractSelect from './components/ContractSelect';
  import { ImagesUpload, PDFUpload } from '@/components'
  import ContractSteps from './components/ContractSteps'
  const {
    mapGetters,
    mapActions
  } = createNamespacedHelpers(
    'ContractModule'
  );

  export default {
    name: 'ContractForm',
    props: ['slotData', 'templateData', 'templateId', 'isSignedPaper'],
    components: {
      ContractTypeSelect,
      ContractTemplateSelect,
      ContractPreview,
      ContractOrderSelect,
      TemplateForm,
      ContractPreviewPdf,
      ContractSelect,
      ImagesUpload,
      PDFUpload,
      ContractSteps
    },
    computed: {
      ...mapGetters({
        page: 'page',
        keyword: 'keyword'
      }),

      uploadFormData: function () {
        return {
          fileFormat: 'DefaultFileFormat',
          conversionGroup: 'DefaultProductConversionGroup'
        };
      },
      headers: function () {
        return {
          Authorization: this.$store.getters.token
        }
      },
      ordersCodeStr: function () {
        var result = '';
        this.orderSelectFiles.forEach(element => {
          result += element.code + ' ';
        });
        return result;
      }
    },
    methods: {
      ...mapActions({
        search: 'search',
        refresh: 'refresh'
      }),
      selectTemp (str) {
        if (this.hasFrameworkContract) {
          this.tempType = 'CGDD';
        } else {
          this.tempType = 'WTSCHT';
        }
        this.dialogTemplateVisible = true;
      },
      onContractTypeChange (val) {
        if (val != null || val != '') {
          this.contractType = val;
        }
        if (val !== '3') {
          this.orderSelectFiles = [];
        }
      },
      // 文件选择（缓存，并未确定）
      onFileSelectChange (data) {
        this.cacheSelectFile = data;
      },
      onContractSelectChange (data) {
        this.cacheSelectContract = data;
      },
      // 订单选择
      onOrderSelectChange (data) {
        if (!data || data[0] == '' || data.length <= 0) {
          this.$message.warning('请选择订单！');
          return;
        }

        this.orderContractClick(data).then(value => {
          if (value) {
            this.dialogOrderVisible = false;
            this.orderSelectFiles = data;
          }
        });
      },
      // 文件选择确定
      onFileSelectSure () {
        this.dialogTemplateVisible = false;
        this.selectFile = this.cacheSelectFile;
      },
      onContractSelectSure () {
        this.dialogContractVisible = false;
        this.selectContract = this.cacheSelectContract;
      },
      handleExceed (files, fileList) {
        if (fileList > 1) {
          this.$message.warning(`已达最大文件数`);
          return false;
        }
      },
      handleRemove (file) {
        this.fileList = [];
        this.pdfFile = [];
      },
      async onSavePdf () {
        var agreementType = null;
        if (this.contractType == '3') {
          agreementType = 'CUSTOMIZE_COMPLETED';
          if (this.$refs.imagesUpload.isUploading()) {
            this.$message.warning('图片正在上传，请稍后再试！');
            return;
          }
        }
        if (this.contractType == '2') {
          agreementType = 'CUSTOMIZE';
          if (this.$refs.pdfUpload.isUploading()) {
            this.$message.warning('PDF文件正在上传，请稍后再试！');
            return;
          }
        }
        if (this.orderSelectFiles.length == 0) {
          this.$message.error('请选择订单');
          return;
        }
        if (this.contractType == '2' && (!this.pdfFile || this.pdfFile.length <= 0)) {
          this.$message.error('请先上传PDF文件');
          return;
        }
        if (this.contractType == '3' && (!this.paperList || this.paperList.length <= 0)) {
          this.$message.error('请先上传已签纸质合同');
          return;
        }
        if (this.contractCode == null || this.contractCode == '') {
          this.$message.error('请输入自定义合同编号');
          return;
        }
        
        let role = '';
        if (this.partyA) {
          role = 'PARTYA';
        } else {
          role = 'PARTYB';
        }

        let data = {
          // 'pdf': this.pdfFile[0],
          'role': role,
          'title': '',
          'customizeCode': this.contractCode,
          'agreementType': agreementType,
          // 'orderCodes': this.orderSelectFiles.map((order) => order.code)
          'items': this.orderSelectFiles.map((order) => order.id),
          'customizeType': 'WTSCHT'
        }

        if (this.contractType === '2') {
          this.$set(data, 'pdf', this.pdfFile[0]);
        } else if (this.contractType === '3') {
          this.$set(data, 'files', this.paperList)
        }
        
        const url = this.apis().saveContract();
        let formData = Object.assign({}, data);
        const result = await http.post(url, formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        if (result.code == 1) {
          this.$message.success(result.msg);
        } else if (result.code == 0) {
          this.$message.error(result.msg);
          return;
        }

        if (result.data != null && result.data != '') {
          var url1 = this.apis().getContractDetail(result.data);
          const result1 = await http.get(url1);
          if (result1['errors']) {
            this.$message.error(result1['errors'][0].message);
            return;
          }
          this.thisContract = result1.data;
          console.log(this.thisContract);

          this.$emit('openPreviewPdf', this.thisContract, '');
        }

        this.$emit('onSearch');
        this.$emit('closeContractFormDialog');
        this.$emit('closeContractTypeDialog');
      },
      async onSave () {
        if (this.orderSelectFiles.length === 0) {
          this.$message.error('请选择订单');
          return;
        }

        // if (!this.isOrderClickPass) {
        //   this.$message.error('订单的相关品牌与工厂不一致，请重新选择');
        //   return;
        // }

        // let bool = false;
        // this.orderSelectFiles.every((file) => {
        //   if (file.status == 'PENDING_CONFIRM' || file.status == 'CANCELLED') {
        //     bool = true;
        //   }
        // });
        // if (bool) {
        //   this.$message.error('当前选择的订单不能是待确认状态和已取消状态');
        //   return;
        // }

        if (this.selectFile.id == null || this.selectFile.id == '') {
          this.$message.error('请选择合同模板');
          return;
        }
        let role = '';
        if (this.partyA) {
          role = 'PARTYA';
        } else {
          role = 'PARTYB';
        }
        var frameAgreementCode = '';
        if (this.hasFrameworkContract) {
          this.agreementType = '';
          if (this.selectContract.code == null || this.selectContract.code == '') {
            return;
          }

          if (this.selectContract.code != null && this.selectContract.code != '') {
            frameAgreementCode = this.selectContract.code;
          }
        }

        let data = {
          'userTempCode': this.selectFile.code,
          'role': role,
          'title': '',
          'frameAgreementCode': frameAgreementCode,
          // 'orderCodes': this.orderSelectFiles.map((order) => order.code)
          'items': this.orderSelectFiles.map((order) => order.id),
          'customizeType': 'WTSCHT'
        }
        console.log(data);
        const url = this.apis().saveContract();
        let formData = Object.assign({}, data);
        const result = await http.post(url, formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        if (result.code == 1) {
          this.$message.success(result.msg);
        } else if (result.code == 0) {
          this.$message.error(result.msg);
          return;
        }

        if (result.data != null && result.data != '') {
          var url1 = this.apis().getContractDetail(result.data);
          const result1 = await http.get(url1);
          if (result1['errors']) {
            this.$message.error(result1['errors'][0].message);
            return;
          }
          this.thisContract = result1.data;
          console.log(this.thisContract);

          this.$emit('openPreviewPdf', this.thisContract, '');
        }

        this.$emit('onSearch');
        this.$emit('closeContractFormDialog');
        this.$emit('closeContractTypeDialog');
      },
      onSetOrderCode () {
        if (this.slotData && this.slotData.code) {
          this.orderSelectFiles.push(this.slotData);
          this.orderReadOnly = true;
          if (this.currentUser.type == 'BRAND') {
            this.partyA = true;
          } else {
            this.partyA = false;
          }
        }
      },
      onCreateTemp () {
        // this.dialogTemplateVisible = false;
        this.fn.closeSlider(false);
        // this.$router.push("templateForm");
        // this.fn.openSlider('创建', TemplateForm);
        this.tempFormVisible = true;
      },
      handlePreview (file) {
        this.dialogImageUrl = file.url;
        this.dialogVisible = true;
      },
      onBeforeUpload (file) {
        if (file.type !== 'application/pdf') {
          this.$message.error('选择的文件不是PDF文件');
          return false;
        }
        return true;
      },
      onSuccess (response) {
        this.pdfFile[0] = response;
      },
      async getContractList (uid) {
        const url = this.apis().getContractsList();
        const result = await http.post(url, {
          isFrame: true,
          partyACompany: uid,
          state: 'COMPLETE'
        }, {
          page: 0,
          size: 100
        });
        this.mockData = result.content;
      },
      openKJHTSelect () {
        if (this.orderSelectFiles.length == null) {
          return;
        }

        if (this.currentUser.type == 'BRAND') {
          if (this.orderSelectFiles[0].purchaser != null) {
            this.companyUid = this.orderSelectFiles[0].purchaser.uid;
          }
        } else {
          if (this.orderSelectFiles[0].belongTo != null) {
            this.companyUid = this.belongTo.uid;
          }
        }
        this.getContractList(this.companyUid);
        this.dialogContractVisible = true;
      },
      //  订单验证
      async orderContractClick (selectFile) {
        // 选择 已签纸质合同不需要订单校验
        if (this.contractType === '3') {
          return true;
        }
        var flag = false
        if (this.contractType != '1') {
          flag = true
        }
        let data = {
          // 'orderCodes': selectFile.map((order) => order.code),
          'items': selectFile.map((order) => order.id),
          'type': 'WTSCHT',
          'isPdfAgreement': flag
        }
        const url = this.apis().orderContractClick();
        const result = await http.post(url, data);
        if (result.code === 0) {
          this.$message.error(result.msg);
          return false;
        } else if (result.code === 1) {
          return true;
        }
      },
      turnTempFormVisible () {
        this.tempFormVisible = !this.tempFormVisible;
      },
      contractTemplateSelect () {
        this.$refs.contractTemplateSelect.onSearchTemp();
      },
      async getContract (code) {
        var url = this.apis().getContractDetail(code);
        const result = await http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.thisContract = result.data;
        console.log(result);
        console.log(this.thisContract);
      }
    },
    data () {
      return {
        currentUser: this.$store.getters.currentUser,
        contractType: '1',
        hasFrameworkContract: false,
        partyA: true,
        dialogTemplateVisible: false,
        dialogOrderVisible: false,
        cacheSelectFile: {},
        orderSelectFiles: [],
        selectFile: {},
        selectContract: {},
        fileList: [],
        paperList: [],
        dialogPreviewVisible: false,
        orderReadOnly: false,
        input1: '',
        mockData: [],
        // orderPage: [],
        disabled: false,
        pdfFile: [],
        pdfVisible: false,
        fileUrl: '',
        thisContract: '',
        agreementType: '',
        tempType: '',
        tempData: [],
        allData: [],
        companyUid: '',
        dialogContractVisible: false,
        cacheSelectContract: '',
        contractCode: '',
        isOrderClickPass: false,
        tempFormVisible: false,
        uploadType: ''
      };
    },
    created () {
      if (this.isSignedPaper) {
        this.contractType = '3';
      }
    },
    mounted () {
      this.onSetOrderCode();
    },
    watch: {
      paperList: function (nval, oval) {
        if (nval && nval.length === 1) {
          this.uploadType = nval[0].mediaType;
        } else if (nval && nval.length === 0) {
          this.uploadType = '';
        }
      }
      // dialogOrderVisible: function (n, o) {
      //   if (!n) {
      //     this.orderContractClick();
      //   }
      // }
    }
  };
</script>
<style scoped>
  .create-contract-title {
    font-weight: bold;
    font-size: 18px;
    margin-bottom: 50px;
    margin-top: 20px;
  }

  .create-contract-type_select {
    width: 280px;
    height: 100px;
    background: rgba(255, 164, 3, 1);
    opacity: 0.85;
    border-radius: 9px;
  }

  .dropdown-menu {
    width: 280px;
    height: 100px;
  }

  .card-body {
    background-color: #FAFBFC;
  }

  .contractTypeSelect {
    margin-bottom: 50px;
  }

  .create-contract-row {
    margin-top: 20px;
  }

  .create-contract-row_button {
    background-color: #ffd60c;
    border-color: #ffd60c;
  }

  .create-contract-button {
    background-color: #ffd60c;
    border-color: #ffd60c;
    color: #000;
    width: 100%;
    height: 40px;
  }

  .create-contract-button_2 {
    width: 100%;
    height: 40px;
  }

  /deep/ .el-upload__tip {
    margin-top: 10px;
  }

  /* .upload_img {
    vertical-align: middle;
    display: inline-block;
    width: 70px;
    height: 70px;
    float: left;
    position: relative;
    z-index: 1;
    margin-left: -80px;
    background-color: #FFF
  } */

  /deep/ .el-upload-list--picture-card .el-upload-list__item {
    overflow: hidden;
    background-color: #fff;
    border: 0px solid #c0ccda !important;
    border-radius: 6px;
    -webkit-box-sizing: border-box;
    box-sizing: border-box;
    width: 100px;
    height: 100px;
    margin: 0 8px 8px 0;
    display: inline-block;
  }

  /deep/ .el-upload--picture-card {
    background-color: #fbfdff;
    border: 1px dashed #c0ccda;
    border-radius: 6px;
    box-sizing: border-box;
    width: 100px;
    height: 100px;
    line-height: 100px;
    vertical-align: top;
  }

  /deep/ .el-upload-list__item-file-name {
    position: absolute;
    right: 25px;
    top: 50px;
    font-size: 12px;
    color: #ffffff;
    display: none
  }

  .product-select-btn {
    width: 70px;
    height: 30px;
    background: #FFD60C;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.85);
    font-size: 10px;
    border-radius: 0px;
    border: 0px solid #FFD60C;
    margin-top: 10px;
    margin-left: 10px;
    margin-bottom: 10px;
  }

  .tips {
    margin-right: 15px;
    margin-left: 5px;
  }

  .select-btn {
    background-color: #ffd60c!important;
    color: #606266!important;
  }
</style>
