<template>
  <div>
    <el-row :gutter="20" style="margin-bottom: 20px">
      <el-col :span="6">
        <el-card>
          <div class="card-content">
            <div class="card-icon" style="background-color: #4e92e7">
              <el-icon><Document/></el-icon>
            </div>
            <div>
              <p class="title">总订单数</p>
              <div>
                <span>{{ homeCount.orderCount }}</span>
                <span>单</span>
              </div>
            </div>
          </div>
        </el-card>
      </el-col>

      <el-col :span="6">
        <el-card>
          <div class="card-content">
            <div class="card-icon" style="background-color: #40bd56">
              <el-icon><User/></el-icon>
            </div>
            <div>
              <p class="title">用户总数</p>
              <div>
                <span>{{ homeCount.userCount }}</span>
                <span>人</span>
              </div>
            </div>
          </div>
        </el-card>
      </el-col>

      <el-col :span="6">
        <el-card>
          <div class="card-content">
            <div class="card-icon" style="background-color: #fbbf24">
              <el-icon><Bicycle/></el-icon>
            </div>
            <div>
              <p class="title">配送员数</p>
              <div>
                <span>{{ homeCount.riderCount }}</span>
                <span>人</span>
              </div>
            </div>
          </div>
        </el-card>
      </el-col>

      <el-col :span="6">
        <el-card>
          <div class="card-content">
            <div class="card-icon" style="background-color: #f65c85">
              <el-icon><Document/></el-icon>
            </div>
            <div>
              <p class="title">通知公告</p>
              <div>
                <span>{{ homeCount.noticeCount }}</span>
                <span>条</span>
              </div>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="20">
      <el-col :span="14">
        <el-card>
          <template #header>
            <span>近14天订单统计趋势</span>
          </template>
          <div ref="orderChartRef" style="height: 550px; width: 100%;"/>
        </el-card>
      </el-col>
      <el-col :span="10">
        <el-card>
          <template #header>
            <span>订单状态分布</span>
          </template>
          <div ref="statusChartRef" style="height: 550px; width: 100%;"/>
        </el-card>
      </el-col>
    </el-row>

  </div>
</template>

<script setup>
import {Bicycle, Document, User} from "@element-plus/icons-vue";
import {selectHomeCount, selectOrderStatusChart, selectOrderTrend} from "@/api/take/homePage.js";
import * as echarts from 'echarts'

//图表实例
const orderChartRef = ref()
const statusChartRef = ref()
let orderChart = null
let statusChart = null

//初始化订单状态分布图表
const initStatusChart = () => {
  let statusData = []

  selectOrderStatusChart().then(res => {
    statusData = res.data.map(item => ({
      name: item.status,
      value: item.count
    }))

    //初始化图表
    statusChart = echarts.init(statusChartRef.value)

    const option = {
      tooltip: {
        trigger: 'item'
      },
      legend: {
        orient: 'vertical',
        left: 'left'
      },
      series: [{
        name: '订单状态',
        type: 'pie',
        radius: ['40%', '70%'],
        avoidLabelOverlap: false,
        itemStyle: {
          borderRadius: 5,
          borderColor: '#fff',
          borderWidth: 1
        },
        label: {
          show: true,
          formatter: '{b}: {d}%'
        },
        emphasis: {
          itemStyle: {
            shadowBlur: 10,
            shadowOffsetX: 0,
          }
        },
        data: statusData
      }]
    }
    statusChart.setOption(option)

  })
}

//初始化订单图表
const initOrderChart = () => {
  selectOrderTrend().then(res => {
    //初始化图表
    orderChart = echarts.init(orderChartRef.value)

    const option = {
      tooltip: {
        trigger: 'axis'
      },
      xAxis: {
        type: 'category',
        data: res.data.dates
      },
      yAxis: {
        type: 'value'
      },
      series: [{
        data: res.data.counts,
        type: 'line',
        smooth: true,
        itemStyle: {
          color: '#409EFF'
        }
      }]
    }

    orderChart.setOption(option)

  })
}

//统计数据
const homeCount = ref({})

onMounted(() => {
  selectHomeCount().then(res => {
    homeCount.value = res.data
  })
  initOrderChart()
  initStatusChart()
})
</script>

<style scoped>
.card-content {
  display: flex;
  align-items: center;
  padding: 5px 0;
}

.card-icon {
  width: 56px;
  height: 56px;
  border-radius: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 20px;
  font-size: 30px;
  color: #fff;
}

.title {
  font-weight: bold;
  margin: 0 0 8px 0;
}
</style>
