<template>
  <div class="animated fadeIn">
    <el-row>
      <div class="customer-list-title">
        <h6>{{titleName}}</h6>
      </div>
    </el-row>
    <div class="pt-4"></div>
    <div class="titleCardClass">
      <el-form ref="roleForm" :model="slotData" :rules="rules" :hide-required-asterisk="true">
        <div class="titleClass">
          <h6>基本信息</h6>
        </div>
        <div style="margin: 20px 20px 20px 40px">
          <el-row>
            <el-form-item prop="name">
              <template slot="label">
                <h6 class="titleTextClass">
                  角色名称
                  <span style="color: #F56C6C">*</span>
                </h6>
              </template>
              <el-row type="flex">
                <el-input placeholder="请填写角色名称" v-model="slotData.name" style="width: 250px"></el-input>
              </el-row>
            </el-form-item>
          </el-row>
        </div>
        <div class="titleClass">
          <h6>权限选择</h6>
        </div>
        <div style="margin: 20px 20px 40px 40px">
          <el-row>
            <b2-b-customer-authority-tree1 ref="authorityTree" :formData='slotData' :isRolePage="true"/>
          </el-row>
        </div>
      </el-form>
    </div>
    <el-row type="flex" justify="space-around">
      <el-button class="cannelbuttonClass" @click="onCannel">
        <h6>关闭</h6>
      </el-button>
      <el-button class="buttonClass" @click="onSave">
        <h6>保存</h6>
      </el-button>
    </el-row>
  </div>
</template>

<script>
  import B2BCustomerAuthorityTree1 from '../tree/B2BCustomerAuthorityTree1';

  export default {
    name: 'B2BCustomerEditRoleDialog',
    components: { B2BCustomerAuthorityTree1 },
    computed: {
    },
    props: [],
    data () {
      return {
        rules: {
          name: [{ required: true, message: '必填', trigger: 'blur' }]
        },
        titleName: '添加角色',
        count: 0,
        slotData: this.$store.state.B2BCustomersModule.roleGroupData
      };
    },
    methods: {
      handleCheckAllChange () {
        this.$refs.authorityTree.handleCheckAllChange();
      },
      onReset () {
        this.$refs.authorityTree.onReset([]);
      },
      onSave () {
        this.$refs['roleForm'].validate((valid) => {
          if (valid) {
            if (!this.slotData.roleIds || this.slotData.roleIds.length < 0) {
              this.$message.error('请选择角色的权限');
              return;
            }
            let formData = {
              id: this.slotData.id == '' ? null : this.slotData.id,
              name: this.slotData.name,
              roleIds: this.distinct(this.slotData.roleIds)
            }
            this.$emit('saveRole', formData);
          } else {
            this.$message.error('请完善表单信息');
          }
        });
      },
      onCannel () {
        this.$emit('cannelNewRole');
      },
      // 数组去重
      distinct (arr) {
        let result = []
        let obj = {};
        for (let i of arr) {
          if (!obj[i]) {
            result.push(i)
            obj[i] = 1
          }
        }
        return result
      }
    },
    watch: {
      slotData: {
        handler (val) {
          if (val) {
            this.$emit('watchCount');
          }
        },
        deep: true
      }
    },
    created () {
      if (this.slotData.id != '') {
        this.titleName = '编辑角色';
      }
    }
  };
</script>

<style scoped>
  .titleClass {
    padding: 10px 0px 1px 10px;
    background-color: #DCDCDC;
  }

  .titleCardClass{
    border-style: solid;
    border-width: 1px;
    border-top: white;
    border-color: #DCDCDC;
  }

  .customer-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .titleTextClass {
    text-align: justify;
    text-align-last: justify;
    display: inline-block;
    width: 70px;
    font-size: 14px;
  }

  .buttonClass{
    padding: 10px 120px 0px 120px;
    margin-top: 40px;
    background-color: #ffd60c;
    color: #0b0e0f;
    border-radius: 8px;
  }

  .cannelbuttonClass{
    padding: 10px 120px 0px 120px;
    margin-top: 40px;
    background-color: #ffffff;
    color: #0b0e0f;
    border-radius: 8px;
  }

</style>
