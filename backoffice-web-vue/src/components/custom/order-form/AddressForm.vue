<template>
  <!-- 订单表单组件:地址选择 -->
  <div style="width:100%">
    <el-form ref="address" :model="address" label-position="left" :disabled="readOnly">
      <el-row type="flex" align="middle" :gutter="10" justify="space-between">
        <el-col :span="5">
          <el-form-item :rules="[{ required: !readOnly, message: '请选择省', trigger: 'change'}]" :prop="'region'" label=''
            label-width="10px" style="width:100%">
            <el-select v-model="address.region" value-key="isocode" @change="(val)=>onRegionChanged(val)"
              style="width:100%" placeholder="选择省份">
              <el-option v-for="item in regions" :key="item.isocode" :label="item.name" :value="item">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="5">
          <el-form-item :rules="[{ required: !readOnly, message: '请选择市', trigger: 'change'}]" prop="city" label=''
            label-width="10px" style="width:100%">
            <el-select v-model="address.city" @change="(val)=>onCityChanged(val)" value-key="code" placeholder="选择城市"
              style="width:100%">
              <el-option v-for="item in cities" :key="item.code" :label="item.name" :value="item">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="5">
          <el-form-item :rules="[{ required: !readOnly, message: '请选择区', trigger: 'change'}]" prop="cityDistrict"
            label='' label-width="10px" style="width:100%">
            <el-select v-model="address.cityDistrict" value-key="code" placeholder="选择县区" style="width:100%">
              <el-option v-for="item in cityDistricts" :key="item.code" :label="item.name" :value="item">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="9">
          <el-form-item :rules="[
                { required: !readOnly, message: '请详细地址', trigger: 'change'}]" prop="line1" label='' label-width="10px"
            style="width:100%">
            <el-input placeholder="详细地址" v-model="address.line1" style="width:100%">
            </el-input>
          </el-form-item>
        </el-col>
      </el-row>
    </el-form>
  </div>
</template>

<script>
  export default {
    name: 'AddressForm',
    components: {

    },
    props: {
      vAddress: {
        type: Object,
        default: () => {
          return {
            region: '',
            city: '',
            cityDistrict: '',
            line1: ''
          };
        }
      },
      readOnly: {
        type: Boolean,
        default: false
      }
    },
    methods: {
      async onAddressSelect(val) {
        this.addressSelectVisible = false;
        this.address = val;
        this.getCities(val.region);
        const url = this.apis().getDistricts(val.city.code);
        const result = await this.$http.get(url);

        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.cityDistricts = result;
      },
      async getRegions() {
        const url = this.apis().getRegions();
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.regions = result;
      },
      onRegionChanged(current) {
        if (!current || current.isocode == '') {
          return;
        }

        this._onRegionChanged(current);
      },
      _onRegionChanged(current) {
        this.cities = [];
        this.$set(this.address, 'city', {
          code: '',
          name: ''
        });
        this.$set(this.address, 'cityDistrict', {
          code: '',
          name: ''
        });
        this.getCities(current);
        if (this.address.city && this.address.city.code) {
          this.onCityChanged(this.address.city.code);
        }
      },
      async getCities(region) {
        const url = this.apis().getCities(region.isocode);
        const result = await this.$http.get(url);

        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.cities = result;
      },
      onCityChanged(current) {
        if (!current) {
          return;
        }
        this._onCityChanged(current);
      },
      async _onCityChanged(city) {
        this.cityDistricts.clear;
        const url = this.apis().getDistricts(city.code);
        const result = await this.$http.get(url);

        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.cityDistricts = result;
      }

    },
    data() {
      return {
        address: {
          region: '',
          city: '',
          cityDistrict: '',
          line1: ''
        },
        regions: [],
        cities: [],
        cityDistricts: [],
        addressSelectVisible: false
      };
    },
    watch: {
      vAddress: function (newVal, oldVal) {
        this.address = newVal;
      },
      address: function (newVal, oldVal) {
        this.$emit('update:vAddress', newVal);
      }
    },
    created() {
      this.getRegions();
      this.address = this.vAddress
      // 手动加载选中市区数据
      if (this.address != null && this.address.region != null && this.address.region != '') {
        this.getCities(this.address.region);
        this.onCityChanged(this.address.city);
      }
    }
  }

</script>

<style>

</style>
