<template>
  <div class="animated fadeIn">
    <el-table v-if="isHeightComputed" ref="resultTable" stripe :data="page.content" :height="autoHeight">
      <el-table-column label="名称" prop="name"></el-table-column>
      <el-table-column label="平台组" prop="group">
        <template slot-scope="scope">
          {{getEnum('carouselGroups', scope.row.group)}}
        </template>
      </el-table-column>
      <el-table-column label="类型" prop="type">
        <template slot-scope="scope">
          {{getEnum('carouselTypes', scope.row.type)}}
        </template>
      </el-table-column>
      <el-table-column label="跳转动作" prop="action"></el-table-column>
      <el-table-column label="描述" prop="description"></el-table-column>
      <el-table-column label="是否可用" prop="active">
        <template slot-scope="scope">
          {{scope.row.active==true?"是":"否"}}
        </template>
      </el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button type="text" icon="el-icon-edit" @click="onDetails(scope.row)">明细</el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination class="pagination-right"
                   layout="total, sizes, prev, pager, next, jumper"
                   @size-change="onPageSizeChanged"
                   @current-change="onCurrentPageChanged"
                   :current-page="page.number + 1"
                   :page-size="page.size"
                   :page-count="page.totalPages"
                   :total="page.totalElements">
    </el-pagination>
  </div>
</template>

<script>
  export default {
    name: 'CarouselList',
    props: ["page"],
    computed: {},
    methods: {
      onPageSizeChanged(val) {
        this._reset();

        this.$emit('onSearch', 0, val);
      },
      onCurrentPageChanged(val) {
        this.$emit('onSearch', val - 1);
      },
      _reset() {
        this.$refs.resultTable.clearSort();
        this.$refs.resultTable.clearFilter();
        this.$refs.resultTable.clearSelection();
      },
      onDetails(row) {
        this.$emit('onDetails', row);
      },
    },
    data() {
      return {
      }
    }
  }
</script>
