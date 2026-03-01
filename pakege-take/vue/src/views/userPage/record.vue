<template>
  <div class="record-container">
    <div class="main-content">
      <div class="filter-bar">
        <el-radio-group v-model="activeStatus" size="small" @change="handleFilterChange">
          <el-radio-button label="all">全部</el-radio-button>
          <el-radio-button label="配送中">配送中</el-radio-button>
          <el-radio-button label="已完成">已完成</el-radio-button>
          <el-radio-button label="已取消">已取消</el-radio-button>
        </el-radio-group>
      </div>

      <div>
        <template v-if="orderList.length > 0">
          <div v-for="record in orderList"
               :key="record.orderId"
               class="record-card"
          >
            <div class="card-header">
              <div class="order-info">
                <span class="order-id">订单号: {{ record.orderId }}</span>
                <el-tag type="warning" v-if="record.status === '待接单'">{{ record.status }}</el-tag>
                <el-tag type="primary" v-if="record.status === '配送中'">{{ record.status }}</el-tag>
                <el-tag type="success" v-if="record.status === '已完成'">{{ record.status }}</el-tag>
                <el-tag type="danger" v-if="record.status === '已取消'">{{ record.status }}</el-tag>
              </div>
              <div style="font-size: 13px;color: #999">{{ record.createTime }}</div>
            </div>
            <div class="card-body">
              <div class="route-info">
                <div class="station-point">
                  <div class="dot start">取</div>
                  <span>{{ record.station }}</span>
                  <span class="code-badge">取件码: {{ record.code }}</span>
                </div>
                <div class="divider-line"/>
                <div class="station-point">
                  <div class="dot end">送</div>
                  <span>{{ record.building }} - {{ record.room }}</span>
                </div>
              </div>

              <div class="package-info">
                <div class="info-item">
                  <span class="label">规格</span>
                  <span class="val">{{ record.size }}</span>
                </div>
                <div class="info-item price-box">
                  <span class="label">收入</span>
                  <span class="price">¥{{ (record.totalPrice * 0.7).toFixed(2) }}</span>
                </div>
              </div>
            </div>

            <div class="card-footer" v-if="record.remark">
              <div class="remark-text">
                <el-icon style="color: #ecce97"><CollectionTag/></el-icon>
                备注: {{ record.remark }}
              </div>
            </div>
          </div>
        </template>

        <el-empty v-else description="暂无接单记录"/>
      </div>

      <div v-if="orderList.length > 0" style="display: flex;justify-content: center">
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
import {ref, onMounted} from "vue";
import {selectOrderListByRiderToUserId} from "@/api/take/order.js";
import {CollectionTag} from "@element-plus/icons-vue";

//当前激活的筛选状态
const activeStatus = ref('all')

//订单列表数据
const orderList = ref([])

//数据总数
const total = ref(0)

//查询参数
const query = ref({
  pageNum: 1,
  pageSize: 10,
  status: null
})

//根据状态筛选
const handleFilterChange = () => {
  if (activeStatus.value === 'all') {
    query.value.status = null
    getList()
  } else {
    query.value.status = activeStatus.value
    getList()
  }
}

//查询数据
const getList = () => {
  selectOrderListByRiderToUserId(query.value).then(res => {
    orderList.value = res.rows
    total.value = res.total
  })
}

onMounted(() => {
  getList()
})
</script>

<style scoped>
/*
 * 主容器样式
 * 与接单页面保持一致的设计规范
 */
.record-container {
  min-height: calc(100vh - 70px); /* 视口高度减去导航栏 */
  padding: 30px 0; /* 上下内边距 */
  display: flex; /* 弹性布局 */
  justify-content: center; /* 水平居中 */
}

/*
 * 主要内容区域
 * 固定宽度，保持页面一致性
 */
.main-content {
  width: 1100px; /* 固定宽度 */
  padding: 0 20px; /* 左右内边距 */
}

/*
 * 筛选栏样式
 * 顶部固定筛选区域
 */
.filter-bar {
  background: #fff; /* 白色背景 */
  padding: 15px 20px; /* 内边距 */
  border-radius: 12px; /* 圆角 */
  margin-bottom: 20px; /* 底部外边距 */
  display: flex; /* 弹性布局 */
  justify-content: space-between; /* 两端对齐 */
  align-items: center; /* 垂直居中 */
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.02); /* 轻微阴影 */
}

/*
 * 记录卡片样式
 * 每一条接单记录的卡片容器
 */
.record-card {
  background: #fff; /* 白色背景 */
  border-radius: 12px; /* 圆角 */
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.04); /* 轻微阴影 */
  margin-bottom: 20px; /* 卡片间距 */
  border: 1px solid #eee; /* 边框 */
  transition: all 0.3s ease; /* 过渡动画 */
  overflow: hidden; /* 内容溢出隐藏 */
}

/* 卡片悬停效果 */
.record-card:hover {
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08); /* 加深阴影 */
  transform: translateY(-2px); /* 轻微上浮 */
}

/*
 * 卡片头部样式
 * 包含订单基本信息和状态
 */
.card-header {
  background: #fdfdfd; /* 浅灰色背景 */
  padding: 15px 25px; /* 内边距 */
  border-bottom: 1px solid #f5f5f5; /* 底部边框 */
  display: flex; /* 弹性布局 */
  justify-content: space-between; /* 两端对齐 */
  align-items: center; /* 垂直居中 */
}

/* 订单信息容器 */
.order-info {
  display: flex; /* 弹性布局 */
  align-items: center; /* 垂直居中 */
  gap: 15px; /* 子元素间距 */
}

/* 订单号文本样式 */
.order-id {
  font-size: 14px; /* 中等字号 */
  color: #666; /* 深灰色文字 */
}

/*
 * 卡片主体样式
 * 包含配送路线和包裹信息
 */
.card-body {
  padding: 25px; /* 内边距 */
  display: flex; /* 弹性布局 */
  justify-content: space-between; /* 两端对齐 */
  align-items: center; /* 垂直居中 */
}

/* 路线信息容器 */
.route-info {
  flex: 1; /* 占据剩余空间 */
}

/*
 * 站点信息样式
 * 取件点和送件点的统一样式
 */
.station-point {
  display: flex; /* 弹性布局 */
  align-items: center; /* 垂直居中 */
  gap: 12px; /* 子元素间距 */
  font-size: 15px; /* 中等字号 */
  font-weight: 500; /* 中等粗细 */
  color: #333; /* 深黑色文字 */
  padding: 8px 0; /* 上下内边距 */
}

/*
 * 圆点标识样式
 * 取件和送件的视觉标识
 */
.dot {
  width: 24px; /* 固定宽度 */
  height: 24px; /* 固定高度 */
  border-radius: 4px; /* 小圆角 */
  font-size: 12px; /* 小字号 */
  display: flex; /* 弹性布局 */
  align-items: center; /* 垂直居中 */
  justify-content: center; /* 水平居中 */
  color: #fff; /* 白色文字 */
  flex-shrink: 0; /* 防止收缩 */
}

/* 取件点圆点样式 - 绿色 */
.dot.start {
  background: #3AAE6E; /* Element Plus 成功色 */
}

/* 送件点圆点样式 - 橙色 */
.dot.end {
  background: #ff9900; /* 橙色，突出显示 */
}

/*
 * 取件码徽章样式
 * 重要信息突出显示
 */
.code-badge {
  background: #f0f9f4; /* 浅绿色背景 */
  color: #3AAE6E; /* 绿色文字 */
  font-size: 12px; /* 小字号 */
  padding: 2px 8px; /* 内边距 */
  border-radius: 4px; /* 圆角 */
  margin-left: 10px; /* 左外边距 */
  border: 1px solid rgba(58, 174, 110, 0.2); /* 半透明绿色边框 */
}

/*
 * 分隔线样式
 * 连接取件和送件点的垂直线
 */
.divider-line {
  width: 2px; /* 线宽 */
  height: 15px; /* 线高 */
  background: #e4e7ed; /* 浅灰色 */
  margin-left: 11px; /* 左外边距，对齐圆点中心 */
  margin-top: -5px; /* 负上外边距，向上移动 */
  margin-bottom: -5px; /* 负下外边距，向下移动 */
}

/*
 * 包裹信息容器
 * 右侧区域，包含规格和收入
 */
.package-info {
  display: flex; /* 弹性布局 */
  gap: 40px; /* 子元素间距 */
  padding-left: 40px; /* 左内边距 */
  border-left: 1px dashed #eee; /* 左侧虚线分隔 */
}

/* 信息项样式 */
.info-item {
  display: flex; /* 弹性布局 */
  flex-direction: column; /* 垂直排列 */
  align-items: flex-end; /* 右对齐 */
}

/* 信息标签样式 */
.info-item .label {
  font-size: 12px; /* 小字号 */
  color: #999; /* 浅灰色 */
  margin-bottom: 4px; /* 底部外边距 */
}

/* 信息值样式 */
.info-item .val {
  font-size: 14px; /* 中等字号 */
  color: #333; /* 深灰色 */
  font-weight: 500; /* 中等粗细 */
}

/*
 * 价格框特殊样式
 * 骑手收入突出显示
 */
.price-box .price {
  font-size: 20px; /* 大字号 */
  color: #67C23A; /* Element Plus 成功色 */
  font-weight: bold; /* 加粗 */
}

/* 价格符号样式（如果使用伪元素） */
.price-box .price::before {
  font-size: 12px; /* 小字号 */
  margin-right: 1px; /* 右外边距 */
}

/*
 * 卡片底部样式
 * 备注信息区域
 */
.card-footer {
  padding: 15px 25px; /* 内边距 */
  border-top: 1px solid #f9f9f9; /* 顶部边框 */
  background: #fafafa; /* 浅灰色背景 */
}

/* 备注文本样式 */
.remark-text {
  font-size: 12px; /* 小字号 */
  color: #999; /* 浅灰色 */
  display: flex; /* 弹性布局 */
  align-items: center; /* 垂直居中 */
  gap: 5px; /* 子元素间距 */
  padding: 5px 0; /* 上下内边距 */
}
</style>
