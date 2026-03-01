<template>
  <div class="orders-container">
    <div class="main-content">
      <el-tabs v-model="activeTab" class="order-tabs" @tab-click="handleTabClick">
        <el-tab-pane label="全部" name="all"/>
        <el-tab-pane label="待接单" name="待接单"/>
        <el-tab-pane label="配送中" name="配送中"/>
        <el-tab-pane label="已完成" name="已完成"/>
        <el-tab-pane label="已取消" name="已取消"/>
      </el-tabs>

      <div>
        <template v-if="orderList.length > 0">
          <div v-for="order in orderList"
               :key="order.orderId"
               class="order-card"
          >
            <div class="card-header">
              <div class="order-meta">
                <span>{{ order.createTime }}</span>
                <span>订单号: {{ order.orderId }}</span>
              </div>
              <div>
                <el-tag type="warning" v-if="order.status === '待接单'">{{ order.status }}</el-tag>
                <el-tag type="primary" v-if="order.status === '配送中'">{{ order.status }}</el-tag>
                <el-tag type="success" v-if="order.status === '已完成'">{{ order.status }}</el-tag>
                <el-tag type="danger" v-if="order.status === '已取消'">{{ order.status }}</el-tag>
              </div>
            </div>

            <div class="card-body">
              <div class="route-info">
                <div class="station-point">
                  <div class="dot start">取</div>
                  <span>{{ order.station }}</span>
                  <span class="code-badge">取件码: {{ order.code }}</span>
                </div>
                <div class="divider-line"/>
                <div class="station-point">
                  <div class="dot end">送</div>
                  <span>{{ order.building }} - {{ order.room }}</span>
                </div>
              </div>

              <div class="package-info">
                <div class="info-item">
                  <span class="label">规格</span>
                  <span class="val">{{ order.size }}</span>
                </div>
                <div class="info-item">
                  <span class="label">骑手</span>
                  <span class="val">{{ order.rider ? order.rider : '暂无骑手' }}</span>
                </div>
                <div class="info-item price-box">
                  <span class="label">实付</span>
                  <span class="price">¥{{ order.totalPrice }}</span>
                </div>
              </div>
            </div>

            <div class="card-footer">
              <div class="remark-text" v-if="order.remark">
                备注: {{ order.remark }}
              </div>
              <div>
                <el-button v-if="order.status === '待接单'" type="danger" @click="cancel(order.orderId)">
                  取消订单
                </el-button>
                <el-button v-if="order.status === '配送中'" type="success" @click="handelReceive(order)">
                  确认送达
                </el-button>
              </div>
            </div>
          </div>
        </template>

        <el-empty v-else description="暂无相关订单"/>
      </div>

      <div class="pagination-box" v-if="orderList.length > 0">
        <pagination
            v-show="total>0"
            :total="total"
            v-model:page="query.pageNum"
            v-model:limit="query.pageSize"
            @pagination="getList"
        />
      </div>
    </div>
  </div>
</template>

<script setup>
import {cancelOrder, receive, selectMyOrderList} from "@/api/take/order.js";
import {ElMessage, ElMessageBox} from "element-plus";


//当前激活的标签页
const activeTab = ref('all')

//查询参数
const query = ref({
  pageNum: 1,
  pageSize: 10,
  status: null
})

//数据总数
const total = ref(0)

//订单列表数据
const orderList = ref([])

//确认送达
const handelReceive = (order) => {
  ElMessageBox.confirm('确认已经收到包裹了吗？', '系统提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(() => {
    receive(order.orderId).then(res => {
      getList()
      ElMessage.success("订单已完成~")
    })
  }).catch(() => {})
}

//取消订单
const cancel = (orderId) => {
  ElMessageBox.confirm('是否确认取消订单？', '系统提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(() => {
    cancelOrder(orderId).then(res => {
      getList()
      ElMessage.success("取消成功")
    })
  }).catch(() => {})
}

//根据状态筛选
const handleTabClick = (tab) => {
  activeTab.value = tab.paneName
  if (activeTab.value === 'all') {
    query.value.status = null
    getList()
  } else {
    query.value.status = activeTab.value
    getList()
  }
}

//查询数据
const getList = () => {
  selectMyOrderList(query.value).then(res => {
    total.value = res.total
    orderList.value = res.rows
  })
}

onMounted(() => {
  getList()
})
</script>

<style scoped>
/* 订单容器 - 整个页面布局容器 */
.orders-container {
  min-height: calc(100vh - 70px); /* 最小高度为视窗高度减去70px，确保页脚位置合适 */
  padding: 30px 0; /* 上下内边距30px */
  display: flex; /* 使用flex布局 */
  justify-content: center; /* 水平居中 */
}

/* 主要内容区域 */
.main-content {
  width: 1100px; /* 固定宽度1100px */
  padding: 0 20px; /* 左右内边距20px */
}

/* 页面标题样式（未使用，保留） */
.page-header h2 {
  margin: 0;
  font-size: 24px;
  color: #333;
}

/* 深度选择器：修改Element Plus Tabs组件的激活状态样式 */
:deep(.el-tabs__item.is-active) {
  color: #3AAE6E; /* 激活标签文字颜色 - 绿色 */
}

/* 深度选择器：修改Element Plus Tabs组件的激活条样式 */
:deep(.el-tabs__active-bar) {
  background-color: #3AAE6E; /* 激活条颜色 - 绿色 */
}

/* 订单标签页样式 */
.order-tabs {
  margin-bottom: 20px; /* 底部外边距20px */
}

/* 订单卡片样式 */
.order-card {
  background: #fff; /* 白色背景 */
  border-radius: 12px; /* 圆角12px */
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.04); /* 浅色阴影 */
  margin-bottom: 20px; /* 底部外边距20px */
  border: 1px solid #eee; /* 浅灰色边框 */
  transition: all 0.3s ease; /* 所有属性过渡效果0.3秒，缓动函数 */
  overflow: hidden; /* 隐藏溢出内容，保持圆角效果 */
}

/* 订单卡片悬停效果 */
.order-card:hover {
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08); /* 悬停时加深阴影 */
  transform: translateY(-2px); /* 悬停时向上移动2px，产生浮起效果 */
}

/* 卡片头部样式 */
.card-header {
  background: #fdfdfd; /* 浅灰色背景 */
  padding: 15px 25px; /* 内边距 */
  border-bottom: 1px solid #f5f5f5; /* 底部边框 */
  display: flex; /* flex布局 */
  justify-content: space-between; /* 两端对齐 */
  align-items: center; /* 垂直居中 */
}

/* 订单元信息样式 */
.order-meta {
  font-size: 13px; /* 字体大小13px */
  color: #999; /* 浅灰色文字 */
  display: flex; /* flex布局 */
  gap: 20px; /* 子元素间距20px */
}

/* 卡片主体样式 */
.card-body {
  padding: 25px; /* 内边距25px */
  display: flex; /* flex布局 */
  justify-content: space-between; /* 两端对齐 */
  align-items: center; /* 垂直居中 */
}

/* 配送路线信息容器 */
.route-info {
  flex: 1; /* 占据剩余空间 */
}

/* 站点信息样式（取件点/送达点） */
.station-point {
  display: flex; /* flex布局 */
  align-items: center; /* 垂直居中 */
  gap: 12px; /* 子元素间距12px */
  font-size: 15px; /* 字体大小15px */
  font-weight: 500; /* 中等字重 */
  color: #333; /* 深灰色文字 */
  padding: 8px 0; /* 上下内边距8px */
}

/* 圆形标识点样式 */
.dot {
  width: 24px; /* 宽度24px */
  height: 24px; /* 高度24px */
  border-radius: 4px; /* 4px圆角（实际上是圆角矩形） */
  font-size: 12px; /* 字体大小12px */
  display: flex; /* flex布局 */
  align-items: center; /* 垂直居中 */
  justify-content: center; /* 水平居中 */
  color: #fff; /* 白色文字 */
  flex-shrink: 0; /* 防止缩小 */
}

/* 起点标识点样式 */
.dot.start {
  background: #3AAE6E; /* 绿色背景 */
}

/* 终点标识点样式 */
.dot.end {
  background: #ff9900; /* 橙色背景 */
}

/* 取件码徽章样式 */
.code-badge {
  background: #f0f9f4; /* 浅绿色背景 */
  color: #3AAE6E; /* 绿色文字 */
  font-size: 12px; /* 字体大小12px */
  padding: 2px 8px; /* 内边距 */
  border-radius: 4px; /* 4px圆角 */
  margin-left: 10px; /* 左外边距10px */
  border: 1px solid rgba(58, 174, 110, 0.2); /* 半透明绿色边框 */
}

/* 路线分隔线样式 */
.divider-line {
  width: 2px; /* 宽度2px */
  height: 15px; /* 高度15px */
  background: #e4e7ed; /* 浅灰色背景 */
  margin-left: 11px; /* 左外边距11px，对齐圆点中心 */
  margin-top: -5px; /* 负上外边距，向上移动 */
  margin-bottom: -5px; /* 负下外边距，向下移动 */
}

/* 包裹信息容器 */
.package-info {
  display: flex; /* flex布局 */
  gap: 40px; /* 子元素间距40px */
  padding-left: 40px; /* 左内边距40px */
  border-left: 1px dashed #eee; /* 左侧虚线边框 */
}

/* 信息项样式 */
.info-item {
  display: flex; /* flex布局 */
  flex-direction: column; /* 垂直方向排列 */
  align-items: flex-end; /* 右对齐 */
}

/* 信息标签样式 */
.info-item .label {
  font-size: 12px; /* 字体大小12px */
  color: #999; /* 浅灰色文字 */
  margin-bottom: 4px; /* 底部外边距4px */
}

/* 信息值样式 */
.info-item .val {
  font-size: 14px; /* 字体大小14px */
  color: #333; /* 深灰色文字 */
  font-weight: 500; /* 中等字重 */
}

/* 价格盒子样式 */
.price-box .price {
  font-size: 20px; /* 字体大小20px */
  color: #f56c6c; /* 红色文字 */
  font-weight: bold; /* 粗体 */
}

/* 价格前面的¥符号样式 */
.price-box .price::before {
  font-size: 12px; /* 字体大小12px */
  margin-right: 1px; /* 右外边距1px */
}

/* 卡片底部样式 */
.card-footer {
  padding: 15px 25px; /* 内边距 */
  border-top: 1px solid #f9f9f9; /* 顶部边框 */
  display: flex; /* flex布局 */
  justify-content: space-between; /* 两端对齐 */
  align-items: center; /* 垂直居中 */
}

/* 备注文字样式 */
.remark-text {
  font-size: 12px; /* 字体大小12px */
  color: #999; /* 浅灰色文字 */
  display: flex; /* flex布局 */
  align-items: center; /* 垂直居中 */
  gap: 5px; /* 子元素间距5px */
}

/* 分页容器样式 */
.pagination-box {
  display: flex; /* flex布局 */
  justify-content: center; /* 水平居中 */
  margin-top: 30px; /* 顶部外边距30px */
}
</style>
