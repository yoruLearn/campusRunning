<template>
  <div>
    <!-- 顶部搜索 -->
    <el-form :model="queryParms" ref="queryRef" :inline="true" label-width="70px">
      <el-form-item label="站点名称" prop="name">
        <el-input v-model="queryParms.name"
                  placeholder="请输入站点名称"
                  clearable
        />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <!-- 顶部按钮 -->
    <el-row :gutter="10" style="padding: 10px 0">
      <el-col :span="1.5">
        <el-button type="primary"
                   plain
                   icon="Plus"
                   @click="handleAdd"
        >新增
        </el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success"
                   plain
                   icon="Edit"
                   :disabled="single"
                   @click="handleUpdate"
        >
          修改
        </el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger"
                   plain
                   icon="Delete"
                   :disabled="miltiple"
                   @click="handleDelete"
        >
          删除
        </el-button>
      </el-col>
    </el-row>

    <!-- 表格 -->
    <el-table ref="tableRef" highlight-current-row border v-loading="loading" :data="stationList"
              @selection-change="handleSelectionChange" @row-click="clickRow">
      <el-table-column type="selection" width="55" align="center"/>
      <el-table-column label="序号" align="center" type="index" :index="indexMethod"/>
      <el-table-column label="站点名称" align="center" prop="name"/>
      <el-table-column label="排序" align="center" prop="sort"/>
      <el-table-column label="操作" align="center">
        <template #default="scope">
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)">修改</el-button>
          <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- 分页组件 -->
    <pagination :total="total" v-show="total > 0"
                v-model:page="queryParms.pageNum"
                v-model:limit="queryParms.pageSize"
                @pagination="getList"
    />

    <!-- 新增或修改时的表单对话框 -->
    <vxe-modal :title="title" v-model="open" width="600px" show-maximize showFooter resize>
      <el-form ref="stationRef" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="分类名称" prop="name">
          <el-input v-model="form.name" placeholder="请输入分类名称"/>
        </el-form-item>
        <el-form-item label="排序" prop="sort">
          <el-input-number style="width: 100%;" v-model="form.sort" placeholder="请输入排序"/>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button type="primary" @click="submitForm()">确定</el-button>
        <el-button @click="open = false">取消</el-button>
      </template>
    </vxe-modal>

  </div>
</template>

<script setup>
import {onMounted, ref} from 'vue'
import {addStation, deleteStation, getStation, listStation, updateStation} from "@/api/take/station.js";
import Pagination from "@/components/Pagination/index.vue";
import {ElMessage, ElMessageBox} from "element-plus";

//对话框title名称
const title = ref('')

//对话框是否打开
const open = ref(false)

//表单实例
const stationRef = ref()

//表单参数
const form = ref({})

//表单校验
const rules = ref({
  name: [{required: true, message: "站点名称不能为空", trigger: "blur"}],
  sort: [{required: true, message: "排序不能为空", trigger: "blur"}],
})

//新增按钮
const handleAdd = () => {
  reset()
  open.value = true
  title.value = '新增快递站点'
}

//修改按钮
const handleUpdate = (row) => {
  reset()
  const stationId = row.stationId || ids.value
  getStation(stationId).then(res => {
    form.value = res.data
    open.value = true
    title.value = '修改快递站点'
  })
}

//删除按钮
const handleDelete = (row) => {
  const stationIds = row.stationId || ids.value
  ElMessageBox.confirm(
      '是否确认删除该项数据?',
      '系统提示',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      }
  )
      .then(() => {
        deleteStation(stationIds).then(res => {
          ElMessage.success('删除成功')
          getList()
        })
      })
}

//表单重置
const reset = () => {
  form.value = {
    stationId: null,
    name: null,
    sort: null
  }
  if (stationRef.value) {
    stationRef.value.resetFields()
  }
}

//提交按钮
const submitForm = () => {
  stationRef.value.validate(valid => {
    if (valid) {
      if (form.value.stationId != null) {
        //修改时提交
        updateStation(form.value).then(res => {
          ElMessage.success('修改成功~')
          open.value = false
          getList()
        })
      } else {
        //新增时提交
        addStation(form.value).then(res => {
          ElMessage.success('新增成功~')
          open.value = false
          getList()
        })
      }
    }
  })
}

//顶部搜索表单实例
const queryRef = ref()

//表格实例
const tableRef = ref()

//加载状态
const loading = ref(false)

//当前选中的行的id数组
const ids = ref([])

//当前是否未选中单行
const single = ref(true)

//当前是否未选中多行
const miltiple = ref(true)

//查询参数
const queryParms = ref({
  pageNum: 1,
  pageSize: 10,
  name: null
})

//快递站点列表数据
const stationList = ref([])

//数据总数
const total = ref(0)

//当前选中的行
const selectedRow = ref({})

//点击行 获取行
const clickRow = (row) => {
  selectedRow.value = row
  const table = tableRef.value;
  //清除所有已选中的行
  table.clearSelection()
  //选中当前点击的行
  table.toggleRowSelection(row, true)
}

//自定义序号
const indexMethod = (index) => {
  let pageNum = queryParms.value.pageNum - 1
  if ((pageNum !== -1 && pageNum !== 0)) {
    return (index + 1) + (pageNum * queryParms.value.pageSize)
  } else {
    return (index + 1)
  }
}

//多选框选中数据
const handleSelectionChange = (selection) => {
  ids.value = selection.map(item => item.stationId)
  single.value = selection.length != 1
  miltiple.value = !selection.length
}

//搜索按钮
const handleQuery = () => {
  queryParms.value.pageNum = 1
  getList()
}

//重置按钮
const resetQuery = () => {
  queryRef.value.resetFields()
  handleQuery()
}

//查询数据
const getList = () => {
  loading.value = true
  listStation(queryParms.value).then(res => {
    stationList.value = res.rows
    total.value = res.total
    loading.value = false
  })
}

//组件挂载完成后执行
onMounted(() => {
  getList()
})
</script>

<style scoped>

</style>
