<template>
  <div class="animated fadeIn">
    <el-form ref="form" label-position="top" :model="slotData" :rules="rules">
      <el-row :gutter="10">
        <el-col :span="6">
          <el-form-item label="工厂名称" prop="name">
            <el-input v-model="slotData.name"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="经营地址" prop="contactAddress">
            <el-input v-model="address" :disabled="true">
              <el-button slot="append" icon="el-icon-search" @click="onAddressInput"></el-button>
            </el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="联系人" prop="contactPerson">
            <el-input v-model="slotData.contactPerson"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="联系电话" prop="contactPhone">
            <el-input v-model="slotData.contactPhone"></el-input>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="10">
        <el-col :span="6">
          <el-form-item label="邮箱" prop="email">
            <el-input v-model="slotData.email"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="座机" prop="phone">
            <el-input v-model="slotData.phone"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="合作品牌" prop="cooperativeBrand">
            <el-input v-model="slotData.cooperativeBrand"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="开发能力" prop="developmentCapacity">
            <el-radio-group v-model="slotData.developmentCapacity">
              <el-radio :label="true">是</el-radio>
              <el-radio :label="false">否</el-radio>
            </el-radio-group>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="10">
        <el-col :span="6">
          <el-form-item label="月均产能" prop="monthlyCapacityRange">
            <el-select v-model="slotData.monthlyCapacityRange" class="w-100">
              <el-option v-for="item in monthlyCapacityRanges" :key="item.code" :label="item.name"
                         :value="item.code"></el-option>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="产值规模" prop="scaleRange">
            <el-select v-model="slotData.scaleRange" class="w-100">
              <el-option v-for="item in scaleRanges" :key="item.code" :label="item.name" :value="item.code"></el-option>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="合作方式" prop="cooperationModes">
            <el-select v-model="slotData.cooperationModes" class="w-100" multiple>
              <el-option v-for="item in cooperationModes" :key="item.code" :label="item.name"
                         :value="item.code"></el-option>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="公司规模" prop="populationScale">
            <el-select v-model="slotData.populationScale" class="w-100">
              <el-option v-for="item in populationScales"
                         :key="item.code"
                         :label="item.name"
                         :value="item.code">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="10">
        <el-col :span="6">
          <el-form-item label="车位数量" prop="latheQuantity">
            <el-input-number class="w-100" v-model="slotData.latheQuantity" :min="0"></el-input-number>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="生产大类" prop="categories">
            <el-select class="w-100" v-model="slotData.categories" value-key="code" multiple>
              <el-option v-for="item in categories" :label="item.name" :key="item.code" :value="item">
                {{item.name}}
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="优势品类" prop="adeptAtCategories">
            <el-select class="w-100"
                       placeholder="请选择"
                       v-model="slotData.adeptAtCategories"
                       value-key="code" multiple>
              <el-option-group
                v-for="group in adeptAtCategories"
                :key="group.code"
                :label="group.name">
                <el-option
                  v-for="item in group.children"
                  :key="item.code"
                  :label="item.name"
                  :value="item">
                </el-option>
              </el-option-group>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="标签" prop="labels">
            <el-select class="w-100" v-model="slotData.labels" value-key="id" multiple>
              <el-option v-for="item in labels"
                         :label="item.name"
                         :key="item.id"
                         :value="item">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="10">
        <el-col :span="6">
          <el-form-item label="产业集群" prop="industrialCluster">
            <el-select class="w-100"
                       placeholder="请选择"
                       v-model="slotData.industrialCluster"
                       value-key="code">
              <el-option-group
                v-for="label in industrialClusterLabels"
                :key="label.id"
                :label="label.name">
                <el-option
                  v-for="cluster in label.clusters"
                  :key="cluster.code"
                  :label="cluster.name"
                  :value="cluster">
                </el-option>
              </el-option-group>
            </el-select>
          </el-form-item>
        </el-col>
      </el-row>
    </el-form>
  </div>
</template>

<script>
  import AddressForm from "@/views/shared/user/address/AddressForm";

  export default {
    name: 'FactoryBasicForm',
    props: ['slotData'],
    components: {AddressForm},
    computed: {
      address: function () {
        if (!this.addressFormData) {
          return '';
        }
        const region = this.addressFormData.region;
        const city = this.addressFormData.city;
        const cityDistrict = this.addressFormData.cityDistrict;
        const line1 = this.addressFormData.line1;

        // 省份和城市相同的情况
        if (region.name === city.name) {
          return region.name + cityDistrict.name + line1;
        }

        return region.name + city.name + cityDistrict.name + line1;
      }
    },
    methods: {
      validate() {
        this.$refs['form'].validate(valid => {
          if (!valid) {
            this.$message.error('验证失败');
            return false;
          }

          return true;
        });
      },
      onAddressInput() {
        this._copyContactAddress();
        this.addressDialogVisible = true;
      },
      onAddressInputCanceled() {
        this.addressDialogVisible = false;
      },
      onAddressInputConfirmed() {
        if (this.$refs['addressForm'].validate()) {
          this.$set(this.slotData, 'contactAddress', this.addressFormData);
          if(this.addressFormData.longitude){
            this.slotData.longitude = this.addressFormData.longitude;
            this.slotData.latitude = this.addressFormData.latitude;
          }
          this.addressDialogVisible = false;
        }
      },
      async getMinorCategories() {
        const url = this.apis().getMinorCategories();
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.adeptAtCategories = result;
      },
      async getCategories() {
        const url = this.apis().getMajorCategories();
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.categories = result;
      },
      async getLabels() {
        const url = this.apis().getGroupLabels('FACTORY');
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.labels = result;
      },
      async getIndustrialClusterLabels() {
        const url = this.apis().getIndustrialClusterLabels();
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.industrialClusterLabels = result;
      },
      _copyContactAddress() {
        if (this.slotData.contactAddress) {
          this.addressFormData = Object.assign({}, this.slotData.contactAddress);
        } else {
          this.addressFormData = this.$store.state.FactoriesModule.addressFormData;
        }
      }
    },
    data() {
      return {
        labels: [],
        industrialClusterLabels: [],
        categories: [],
        adeptAtCategories: [],
        addressFormData: this.$store.state.FactoriesModule.addressFormData,
        addressDialogVisible: false,
        rules: {
          name: [{required: true, message: '必填', trigger: 'blur'}],
          contactPerson: [{required: true, message: '必填', trigger: 'blur'}],
          contactPhone: [
            {required: false, message: '手机号码不正确', trigger: 'blur', pattern: 11 && /^((13|14|15|17|18)[0-9]{1}\d{8})$/}
          ],
          contactAddress: [{required: true, message: '必填', trigger: 'blur'}],
          email: [
            {
              message: '邮箱格式不正确',
              trigger: 'blur',
              pattern: /^([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+\.[a-zA-Z]{2,3}$/
            }
          ]
        },
        cooperationModes: this.$store.state.EnumsModule.cooperationModes,
        scaleRanges: this.$store.state.EnumsModule.scaleRanges,
        monthlyCapacityRanges: this.$store.state.EnumsModule.monthlyCapacityRanges,
        populationScales: this.$store.state.EnumsModule.populationScales,
      };
    },
    created() {
      this.getCategories();
      this.getMinorCategories();
      this.getLabels();
      this.getIndustrialClusterLabels();
      this._copyContactAddress();
    }
  };
</script>
