<template>
  <div class="animated fadeIn">
    <el-form ref="form"
             label-position="top"
             :model="slotData"
             :disabled="readOnly">
      <el-row :gutter="10">
        <el-col :span="8">
          <el-form-item label="备注" prop="code">
            <el-input v-model="slotData.remarks"></el-input>
          </el-form-item>
        </el-col>
      </el-row>
    </el-form>
  </div>
</template>

<script>
  export default {
    name: 'QuoteBaseForm',
    props: ['slotData', 'readOnly'],
    methods: {},
    data() {
      return {}
    },
    created() {
    }
  }
</script>
