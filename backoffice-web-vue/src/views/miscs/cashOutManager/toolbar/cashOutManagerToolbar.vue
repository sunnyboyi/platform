<template>
  <el-form :inline="true">
    <el-form-item label="">
      <el-input placeholder="请输入名称" v-model="keyword"></el-input>
    </el-form-item>
    <el-button-group>
      <el-button type="primary" icon="el-icon-search" @click="onSearch"></el-button>
      <!--<el-button type="primary" icon="el-icon-plus" @click="onNew">新增</el-button>-->
    </el-button-group>
  </el-form>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapMutations} = createNamespacedHelpers('CashOutManagerModule');

  export default {
    name: 'CashOutManagerToolbar',
    components: {},
    computed: {},
    methods: {
      ...mapMutations({
        setKeyword: 'keyword'
      }),
      onSearch() {
        this.setKeyword(this.keyword);
        this.$emit('onSearch', 0);
      },
      onNew() {
        let formData = {};
        this.formData.infos=[];
        Object.assign(formData, this.formData);

        this.$emit('onNew', formData);
      },
    },
    data() {
      return {
        keyword: '',
        formData: this.$store.state.CashOutManagerModule.formData,
        categories: [],
      }
    }
  }
</script>
