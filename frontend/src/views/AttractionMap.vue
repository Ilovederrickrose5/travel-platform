<template>
  <div class="px-page map-page">
    <header class="map-head">
      <div class="map-head__text">
        <p class="px-eyebrow">Travel map</p>
        <h1 class="map-head__title">中国景点地图</h1>
        <p class="px-subtitle">滚轮缩放、拖拽平移，点击地图上的点位直接进入景点详情。</p>
      </div>
      <div class="map-head__count">
        <strong>{{ points.length }}</strong>
        <span>处目的地</span>
      </div>
    </header>

    <PremiumCard variant="glass" padding="sm" class="map-card">
      <div class="map-toolbar">
        <div class="map-toolbar__filters">
          <el-select v-model="level" clearable placeholder="全部等级" style="width: 128px">
            <el-option label="5A 景区" value="5A" />
            <el-option label="4A 景区" value="4A" />
          </el-select>
          <el-select v-model="city" clearable filterable placeholder="全部城市" style="width: 150px">
            <el-option v-for="item in cities" :key="item" :label="item" :value="item" />
          </el-select>
          <span class="map-toolbar__hint">共 {{ list.length }} 处有坐标的目的地</span>
        </div>
        <PremiumButton variant="ghost" size="sm" @click="resetView">复位视图</PremiumButton>
      </div>

      <div ref="chartRef" v-loading="loading" class="map-canvas" />

      <footer class="map-foot">
        <div class="map-legend">
          <span><i class="map-dot map-dot--5a" />5A 景区</span>
          <span><i class="map-dot map-dot--4a" />4A 景区</span>
        </div>
        <p class="map-foot__note">点击点位查看详情 · 缩放后可看清城市内景点</p>
      </footer>
    </PremiumCard>
  </div>
</template>

<script setup>
import { computed, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import * as echarts from 'echarts/core'
import { ScatterChart } from 'echarts/charts'
import { GeoComponent, TooltipComponent } from 'echarts/components'
import { CanvasRenderer } from 'echarts/renderers'
import PremiumButton from '@/components/premium/PremiumButton.vue'
import PremiumCard from '@/components/premium/PremiumCard.vue'
import { getAttractionMap } from '@/api/attraction'

echarts.use([ScatterChart, GeoComponent, TooltipComponent, CanvasRenderer])

const DEFAULT_CENTER = [104.5, 36]
const DEFAULT_ZOOM = 1.2
const LEVEL_COLORS = { '5A': '#c9a86a', '4A': '#5d7f96' }

const router = useRouter()
const chartRef = ref(null)
const loading = ref(false)
const list = ref([])
const level = ref('')
const city = ref('')

let chart = null
let resizeObserver = null

const cities = computed(() => [...new Set(list.value.map((item) => item.city).filter(Boolean))].sort())
const points = computed(() =>
  list.value
    .filter((item) => (!level.value || item.level === level.value) && (!city.value || item.city === city.value))
    .map((item) => ({
      id: item.id,
      name: item.name,
      city: item.city,
      level: item.level,
      coverUrl: item.coverUrl,
      minPrice: item.minPrice,
      value: [Number(item.longitude), Number(item.latitude)]
    }))
)

function escapeHtml(value) {
  return String(value ?? '').replace(/[&<>"']/g, (char) => ({
    '&': '&amp;',
    '<': '&lt;',
    '>': '&gt;',
    '"': '&quot;',
    "'": '&#39;'
  })[char])
}

function priceText(item) {
  if (item.minPrice == null) return '暂无在售票'
  return Number(item.minPrice) === 0 ? '免费预约' : `¥${Number(item.minPrice)} 起`
}

function tooltipHtml(item) {
  const cover = item.coverUrl
    ? `<img src="${escapeHtml(item.coverUrl)}" alt="" style="display:block;width:100%;height:104px;object-fit:cover" />`
    : ''
  return `
    <div style="width:216px;overflow:hidden;border-radius:13px;background:#fff">
      ${cover}
      <div style="padding:11px 13px 13px">
        <strong style="display:block;font-size:14px;color:#202a36">${escapeHtml(item.name)}</strong>
        <span style="display:block;margin-top:3px;font-size:11px;color:#8492a0">
          ${escapeHtml([item.city, item.level].filter(Boolean).join(' · '))}
        </span>
        <span style="display:block;margin-top:7px;font-size:12px;font-weight:600;color:#5d7f96">
          ${priceText(item)}
        </span>
        <span style="display:block;margin-top:6px;font-size:11px;color:#5d7f96">点击查看详情 →</span>
      </div>
    </div>`
}

function chartOption() {
  return {
    tooltip: {
      trigger: 'item',
      backgroundColor: 'transparent',
      borderWidth: 0,
      padding: 0,
      extraCssText: 'box-shadow:0 18px 44px rgba(22,32,42,.22);border-radius:13px;',
      formatter: (params) => (params.seriesType === 'scatter' && params.data ? tooltipHtml(params.data) : '')
    },
    geo: {
      map: 'china',
      roam: true,
      center: DEFAULT_CENTER,
      zoom: DEFAULT_ZOOM,
      scaleLimit: { min: 1, max: 8 },
      // 省界 tooltip 会抢占散点浮窗，这里关掉，浮窗只保留给景点点位
      tooltip: { show: false },
      label: { show: false },
      itemStyle: {
        areaColor: '#eef3f7',
        borderColor: 'rgba(93, 127, 150, 0.32)',
        borderWidth: 0.8
      },
      emphasis: {
        label: { show: false },
        itemStyle: { areaColor: '#e4ecf2' }
      }
    },
    series: [
      {
        name: '景点',
        type: 'scatter',
        coordinateSystem: 'geo',
        data: points.value,
        tooltip: {
          show: true,
          trigger: 'item',
          backgroundColor: 'transparent',
          borderWidth: 0,
          padding: 0,
          extraCssText: 'box-shadow:0 18px 44px rgba(22,32,42,.22);border-radius:13px;',
          formatter: (params) => tooltipHtml(params.data || {})
        },
        symbolSize: (value, params) => (params.data?.level === '5A' ? 11 : 8),
        itemStyle: {
          color: (params) => LEVEL_COLORS[params.data?.level] || '#8492a0',
          borderColor: '#fff',
          borderWidth: 1.2,
          shadowBlur: 6,
          shadowColor: 'rgba(32, 42, 54, 0.28)'
        },
        emphasis: {
          scale: 1.6,
          label: {
            show: true,
            formatter: '{b}',
            position: 'right',
            distance: 6,
            color: '#202a36',
            fontSize: 12,
            fontWeight: 600
          }
        },
        zlevel: 2
      }
    ]
  }
}

function handleChartClick(params) {
  if (params.seriesType !== 'scatter' || !params.data?.id) return
  router.push(`/attractions/${params.data.id}`)
}

// geo 关闭 tooltip 后移到省界不会触发 hideTip，需要手动收起点位浮窗
function handleChartOut(params) {
  if (params.seriesType === 'scatter') chart?.dispatchAction({ type: 'hideTip' })
}

function resetView() {
  chart?.setOption({ geo: { center: DEFAULT_CENTER, zoom: DEFAULT_ZOOM } })
}

async function loadGeoJson() {
  const response = await fetch('/map/china.json')
  if (!response.ok) throw new Error('地图数据加载失败')
  return response.json()
}

async function initChart() {
  loading.value = true
  try {
    const [geo, data] = await Promise.all([loadGeoJson(), getAttractionMap()])
    list.value = data || []
    echarts.registerMap('china', geo)
    chart = echarts.init(chartRef.value)
    chart.setOption(chartOption())
    chart.on('click', handleChartClick)
    chart.on('mouseout', handleChartOut)
    resizeObserver = new ResizeObserver(() => chart?.resize())
    resizeObserver.observe(chartRef.value)
  } catch (error) {
    ElMessage.error(error.message || '地图加载失败')
  } finally {
    loading.value = false
  }
}

watch(points, (data) => {
  chart?.setOption({ series: [{ data }] })
})

onMounted(initChart)

onBeforeUnmount(() => {
  resizeObserver?.disconnect()
  chart?.dispose()
  chart = null
})
</script>

<style scoped lang="scss">
.map-page {
  padding-bottom: 48px;
}

.map-head {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 24px;
  margin-bottom: var(--px-space-5);
}

.map-head__title {
  margin-top: 8px;
  font-size: var(--px-text-2xl);
  color: var(--px-ink-1);
}

.map-head .px-subtitle {
  margin-top: 8px;
}

.map-head__count {
  display: flex;
  align-items: baseline;
  gap: 6px;
  color: var(--px-ink-3);
  font-size: var(--px-text-sm);
}

.map-head__count strong {
  font-size: 28px;
  font-weight: var(--px-weight-semibold);
  color: var(--px-accent-deep);
}

.map-card {
  overflow: hidden;
}

.map-toolbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  padding: 4px 4px 14px;
}

.map-toolbar__filters {
  display: flex;
  align-items: center;
  gap: 10px;
  flex-wrap: wrap;
}

.map-toolbar__hint {
  font-size: var(--px-text-xs);
  color: var(--px-ink-4);
}

.map-canvas {
  width: 100%;
  height: min(66vh, 700px);
  min-height: 460px;
  border-radius: var(--px-radius-lg);
  background:
    radial-gradient(120% 100% at 50% 0%, rgba(255, 255, 255, 0.7), transparent 60%),
    rgba(255, 255, 255, 0.28);
  box-shadow: inset 0 0 0 1px rgba(32, 42, 54, 0.05);
}

.map-foot {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  padding: 13px 6px 3px;
}

.map-legend {
  display: flex;
  align-items: center;
  gap: 18px;
  font-size: var(--px-text-xs);
  color: var(--px-ink-3);
}

.map-legend span {
  display: inline-flex;
  align-items: center;
  gap: 7px;
}

.map-dot {
  width: 9px;
  height: 9px;
  border-radius: 50%;
  border: 1.5px solid #fff;
  box-shadow: 0 1px 4px rgba(32, 42, 54, 0.3);
}

.map-dot--5a {
  background: #c9a86a;
}

.map-dot--4a {
  background: #5d7f96;
}

.map-foot__note {
  font-size: var(--px-text-xs);
  color: var(--px-ink-4);
}

@media (max-width: 720px) {
  .map-head {
    align-items: flex-start;
    flex-direction: column;
    gap: 12px;
  }

  .map-toolbar {
    align-items: flex-start;
    flex-direction: column;
  }

  .map-canvas {
    height: 58vh;
    min-height: 380px;
  }

  .map-foot {
    align-items: flex-start;
    flex-direction: column;
    gap: 8px;
  }
}
</style>
