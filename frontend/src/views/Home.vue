<template>
  <div class="home">
    <section ref="heroRef" class="hero" @mousemove="onHeroMove" @mouseleave="resetHero">
      <div class="hero__media">
        <Transition name="hero-fade">
          <img :key="heroKey" :src="heroCover" :alt="heroAlt" />
        </Transition>
      </div>
      <div class="hero__veil" aria-hidden="true" />
      <div class="hero__grain" aria-hidden="true" />

      <div class="hero__content">
        <p class="hero__eyebrow">Curated journeys · 2026</p>
        <h1 class="hero__title">
          把风景
          <span>留在此刻</span>
        </h1>
        <p class="hero__desc">
          从山海到古城，挑选一处心之所向。实时库存、在线选期，一次轻装出发。
        </p>
        <div class="hero__actions">
          <PremiumButton size="lg" @click="router.push('/attractions')">开始探索</PremiumButton>
          <PremiumButton variant="ghost" size="lg" @click="scrollToRecommend">
            看看推荐
          </PremiumButton>
        </div>
        <dl class="hero__stats">
          <div>
            <dt>{{ stats.destinations || '—' }}</dt>
            <dd>精选目的地</dd>
          </div>
          <div>
            <dt>{{ stats.tickets || '—' }}</dt>
            <dd>在售票种</dd>
          </div>
          <div>
            <dt>7</dt>
            <dd>天可预订</dd>
          </div>
        </dl>
      </div>

      <div class="hero__float" aria-hidden="true">
        <span class="hero__float-dot" />
        <div class="hero__float-text">
          <p>本周灵感</p>
          <strong>{{ heroName }}</strong>
        </div>
        <span class="hero__float-meta">{{ heroMeta }}</span>
      </div>
    </section>

    <section class="map-entry px-page">
      <router-link to="/map" class="map-entry__card">
        <div class="map-entry__text">
          <p class="px-eyebrow">Explore on map</p>
          <h2>在地图上，找到下一站</h2>
          <p>
            {{ stats.destinations || 98 }} 处目的地按真实坐标铺在中国地图上，可缩放、可点击，直接进入景点详情。
          </p>
          <span class="map-entry__cta">
            打开景点地图
            <span aria-hidden="true">→</span>
          </span>
        </div>

        <div class="map-entry__visual" aria-hidden="true">
          <span class="map-entry__ring" />
          <span class="map-entry__dot map-entry__dot--a" />
          <span class="map-entry__dot map-entry__dot--b" />
          <span class="map-entry__dot map-entry__dot--c" />
          <span class="map-entry__dot map-entry__dot--d" />
          <span class="map-entry__compass">N</span>
        </div>
      </router-link>
    </section>

    <section ref="recommendRef" class="recommend px-page">
      <header class="section-head">
        <div>
          <p class="px-eyebrow">Selected for you</p>
          <h2 class="section-head__title">为你推荐</h2>
        </div>
        <router-link to="/attractions" class="section-head__more">
          查看全部景点
          <svg viewBox="0 0 16 16" width="13" height="13" aria-hidden="true">
            <path d="M3 8h10M9 4l4 4-4 4" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
          </svg>
        </router-link>
      </header>

      <div v-if="loading" class="card-grid">
        <PremiumCard v-for="n in 8" :key="n" variant="quiet" padding="sm" class="skeleton-card">
          <el-skeleton animated>
            <template #template>
              <el-skeleton-item variant="image" style="width: 100%; height: 186px; border-radius: 14px" />
              <div class="skeleton-card__body">
                <el-skeleton-item variant="h3" style="width: 60%" />
                <el-skeleton-item variant="text" style="width: 40%" />
                <el-skeleton-item variant="text" style="width: 80%" />
              </div>
            </template>
          </el-skeleton>
        </PremiumCard>
      </div>

      <PremiumCard v-else-if="!items.length" variant="glass" padding="lg">
        <el-empty description="暂无推荐景点，去景点列表看看" />
      </PremiumCard>

      <div v-else class="card-grid">
        <router-link
          v-for="(item, index) in items"
          :key="item.attractionId"
          :to="`/attractions/${item.attractionId}`"
          class="card-link"
          :style="{ '--i': index }"
        >
          <AttractionCard
            :name="item.name"
            :city="item.city"
            :cover-url="item.coverUrl"
            :price="item.price"
            :reason="item.reason"
            :level="item.level"
          />
        </router-link>
      </div>
    </section>
  </div>
</template>

<script setup>
import { computed, nextTick, onBeforeUnmount, onMounted, reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import AttractionCard from '@/components/AttractionCard.vue'
import PremiumButton from '@/components/premium/PremiumButton.vue'
import PremiumCard from '@/components/premium/PremiumCard.vue'
import { getAttractions } from '@/api/attraction'

const HERO_ROTATE_MS = 5000

const router = useRouter()
const loading = ref(false)
const items = ref([])
const heroRef = ref(null)
const recommendRef = ref(null)
const hero = ref(null)
const attractions = ref([])
const stats = reactive({ destinations: 0, tickets: 0 })

const heroKey = computed(() => hero.value?.id ?? 'fallback')
const heroCover = computed(() => hero.value?.coverUrl || '/attraction/attraction_7_1.jpg')
const heroAlt = computed(() => (hero.value ? `${hero.value.name}风光` : '黄山云海'))
const heroName = computed(() => hero.value?.name || '黄山')
const heroMeta = computed(() => {
  if (!hero.value) return '黄山 · 5A'
  return [hero.value.city, hero.value.level].filter(Boolean).join(' · ')
})

let reduceMotion = false
let frame = 0
let heroTimer = null
let heroQueue = []

function shuffle(list) {
  const result = list.slice()
  for (let i = result.length - 1; i > 0; i -= 1) {
    const j = Math.floor(Math.random() * (i + 1))
    const temp = result[i]
    result[i] = result[j]
    result[j] = temp
  }
  return result
}

function heroPool() {
  const withCover = attractions.value.filter((item) => item.coverUrl)
  return withCover.length ? withCover : attractions.value
}

function nextHero() {
  if (document.hidden) return
  if (!heroQueue.length) heroQueue = shuffle(heroPool())
  hero.value = heroQueue.pop() || null
}

function minPrice(item) {
  const prices = (item.ticketTypes || [])
    .filter((ticket) => ticket.status === 1)
    .map((ticket) => Number(ticket.price))
    .filter((price) => Number.isFinite(price))
  return prices.length ? Math.min(...prices) : null
}

function buildRecommend() {
  items.value = shuffle(heroPool())
    .slice(0, 8)
    .map((item) => ({
      attractionId: item.id,
      name: item.name,
      city: item.city,
      coverUrl: item.coverUrl,
      level: item.level,
      price: minPrice(item),
      reason: item.description || ''
    }))
}

async function loadHome() {
  loading.value = true
  try {
    const list = await getAttractions()
    if (!Array.isArray(list) || !list.length) return
    attractions.value = list
    stats.destinations = list.length
    stats.tickets = list.reduce((total, item) => total + (item.ticketTypes?.length || 0), 0)
    buildRecommend()
    heroQueue = shuffle(heroPool())
    nextHero()
    if (heroQueue.length && !heroTimer) {
      heroTimer = window.setInterval(nextHero, HERO_ROTATE_MS)
    }
  } catch {
    items.value = []
  } finally {
    loading.value = false
  }
}

function onHeroMove(event) {
  if (reduceMotion || !heroRef.value) return
  const rect = heroRef.value.getBoundingClientRect()
  const x = (event.clientX - rect.left) / rect.width - 0.5
  const y = (event.clientY - rect.top) / rect.height - 0.5
  heroRef.value.style.setProperty('--mx', `${(x * 10).toFixed(2)}px`)
  heroRef.value.style.setProperty('--my', `${(y * 8).toFixed(2)}px`)
}

function resetHero() {
  heroRef.value?.style.setProperty('--mx', '0px')
  heroRef.value?.style.setProperty('--my', '0px')
}

function onScroll() {
  if (reduceMotion || !heroRef.value) return
  if (frame) return
  frame = window.requestAnimationFrame(() => {
    const offset = Math.min(window.scrollY, 600)
    heroRef.value.style.setProperty('--sy', `${(offset * 0.12).toFixed(2)}px`)
    frame = 0
  })
}

function scrollToRecommend() {
  recommendRef.value?.scrollIntoView({ behavior: 'smooth', block: 'start' })
}

onMounted(() => {
  reduceMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches
  loadHome()
  if (!reduceMotion) {
    window.addEventListener('scroll', onScroll, { passive: true })
  }
  nextTick(onScroll)
})

onBeforeUnmount(() => {
  window.removeEventListener('scroll', onScroll)
  if (frame) window.cancelAnimationFrame(frame)
  if (heroTimer) window.clearInterval(heroTimer)
})
</script>

<style scoped lang="scss">
.home {
  position: relative;
}

/* ---------- hero ---------- */
.hero {
  --mx: 0px;
  --my: 0px;
  --sy: 0px;

  position: relative;
  z-index: var(--px-z-card);
  width: min(100% - 48px, var(--px-container));
  height: 486px;
  margin: var(--px-space-6) auto 0;
  border-radius: var(--px-radius-xl);
  overflow: hidden;
  isolation: isolate;
  box-shadow: var(--px-shadow-3), inset 0 1px 0 rgba(255, 255, 255, 0.18);
}

.hero__media {
  position: absolute;
  inset: -24px;
  z-index: var(--px-z-decor);
  transform: translate3d(var(--mx), calc(var(--sy) + var(--my)), 0) scale(1.04);
  transition: transform 700ms var(--px-ease-out);
  will-change: transform;
}

.hero__media img {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
  filter: saturate(86%) contrast(1.02);
}

.hero-fade-enter-active,
.hero-fade-leave-active {
  transition: opacity 900ms var(--px-ease-out);
}

.hero-fade-enter-from,
.hero-fade-leave-to {
  opacity: 0;
}

.hero__veil {
  position: absolute;
  inset: 0;
  z-index: var(--px-z-far);
  background:
    linear-gradient(90deg, rgba(16, 24, 33, 0.66) 0%, rgba(16, 24, 33, 0.34) 46%, rgba(16, 24, 33, 0.08) 78%),
    linear-gradient(180deg, rgba(16, 24, 33, 0.18) 0%, transparent 34%, rgba(16, 24, 33, 0.3) 100%);
}

.hero__grain {
  position: absolute;
  inset: 0;
  z-index: var(--px-z-far);
  opacity: 0.16;
  background-image: radial-gradient(rgba(255, 255, 255, 0.55) 0.5px, transparent 0.5px);
  background-size: 4px 4px;
  mix-blend-mode: soft-light;
}

.hero__content {
  position: relative;
  z-index: var(--px-z-content);
  height: 100%;
  max-width: 620px;
  padding: 0 0 0 clamp(36px, 5vw, 68px);
  display: flex;
  flex-direction: column;
  justify-content: center;
  color: #fff;
}

.hero__eyebrow {
  font-size: var(--px-text-xs);
  font-weight: var(--px-weight-semibold);
  letter-spacing: 0.26em;
  text-transform: uppercase;
  color: rgba(255, 255, 255, 0.68);
  margin-bottom: 18px;
}

.hero__title {
  font-size: clamp(40px, 4.4vw, 58px);
  font-weight: var(--px-weight-semibold);
  line-height: 1.12;
  letter-spacing: 0.01em;
  color: #fff;
  text-shadow: 0 8px 40px rgba(10, 16, 22, 0.28);
}

.hero__title span {
  display: block;
  color: rgba(255, 255, 255, 0.86);
  font-weight: var(--px-weight-regular);
}

.hero__desc {
  margin-top: 18px;
  max-width: 420px;
  font-size: var(--px-text-base);
  line-height: var(--px-leading-base);
  color: rgba(255, 255, 255, 0.74);
}

.hero__actions {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-top: 30px;
}

.hero__actions :deep(.px-btn--ghost) {
  background: rgba(255, 255, 255, 0.16);
  color: rgba(255, 255, 255, 0.92);
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.24), 0 6px 18px rgba(12, 20, 28, 0.12);
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
}

.hero__actions :deep(.px-btn--ghost:hover) {
  background: rgba(255, 255, 255, 0.26);
  color: #fff;
}

.hero__stats {
  display: flex;
  align-items: center;
  gap: 34px;
  margin: 40px 0 0;
  padding-top: 22px;
  border-top: 1px solid transparent;
  background: linear-gradient(90deg, rgba(255, 255, 255, 0.4), rgba(255, 255, 255, 0.04)) top left / 100% 1px no-repeat;
}

.hero__stats div {
  display: flex;
  flex-direction: column;
  gap: 3px;
}

.hero__stats dt {
  font-size: var(--px-text-lg);
  font-weight: var(--px-weight-semibold);
  color: #fff;
  font-variant-numeric: tabular-nums;
  line-height: 1;
}

.hero__stats dd {
  margin: 0;
  font-size: var(--px-text-xs);
  color: rgba(255, 255, 255, 0.58);
  letter-spacing: 0.08em;
}

.hero__float {
  position: absolute;
  right: 34px;
  bottom: 32px;
  z-index: var(--px-z-float);
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 14px 18px;
  border-radius: var(--px-radius-lg);
  background: linear-gradient(155deg, rgba(255, 255, 255, 0.28), rgba(255, 255, 255, 0.12));
  box-shadow: 0 18px 44px rgba(10, 16, 22, 0.28), inset 0 1px 0 rgba(255, 255, 255, 0.36);
  backdrop-filter: blur(18px) saturate(150%);
  -webkit-backdrop-filter: blur(18px) saturate(150%);
  transform: translate3d(calc(var(--mx) * -0.6), calc(var(--my) * -0.6), 0);
  transition: transform 700ms var(--px-ease-out);
}

.hero__float-dot {
  width: 7px;
  height: 7px;
  border-radius: 50%;
  background: #d8c4a2;
  box-shadow: 0 0 0 4px rgba(216, 196, 162, 0.18);
  animation: hero-dot-breathe var(--px-duration-breathe) var(--px-ease-soft) infinite alternate;
}

.hero__float-text {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.hero__float-text p {
  font-size: 10px;
  letter-spacing: 0.2em;
  text-transform: uppercase;
  color: rgba(255, 255, 255, 0.6);
}

.hero__float-text strong {
  font-size: var(--px-text-sm);
  font-weight: var(--px-weight-medium);
  color: #fff;
}

.hero__float-meta {
  font-size: var(--px-text-xs);
  color: rgba(255, 255, 255, 0.7);
  padding-left: 12px;
  border-left: 1px solid rgba(255, 255, 255, 0.16);
}

@keyframes hero-dot-breathe {
  from {
    box-shadow: 0 0 0 3px rgba(216, 196, 162, 0.12);
  }
  to {
    box-shadow: 0 0 0 7px rgba(216, 196, 162, 0.04);
  }
}

/* ---------- map entry ---------- */
.map-entry {
  padding-top: var(--px-space-7);
}

.map-entry__card {
  position: relative;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 40px;
  padding: 32px 40px;
  border-radius: var(--px-radius-xl);
  overflow: hidden;
  background:
    radial-gradient(120% 170% at 90% 6%, rgba(216, 196, 162, 0.26), transparent 56%),
    linear-gradient(118deg, #24313d, #33465a 62%, #2b3a49);
  box-shadow: var(--px-shadow-3), inset 0 1px 0 rgba(255, 255, 255, 0.12);
  transition:
    transform var(--px-duration-base) var(--px-ease-out),
    box-shadow var(--px-duration-base) var(--px-ease-out);
}

.map-entry__card:hover {
  transform: translateY(-3px);
  box-shadow: var(--px-shadow-4, var(--px-shadow-3)), inset 0 1px 0 rgba(255, 255, 255, 0.18);
}

.map-entry__text .px-eyebrow {
  color: rgba(255, 255, 255, 0.46);
}

.map-entry__text h2 {
  margin-top: 9px;
  font-size: var(--px-text-xl);
  color: #fff;
}

.map-entry__text p {
  max-width: 540px;
  margin-top: 10px;
  font-size: var(--px-text-sm);
  line-height: var(--px-leading-base);
  color: rgba(255, 255, 255, 0.62);
}

.map-entry__cta {
  display: inline-flex;
  align-items: center;
  gap: 7px;
  margin-top: 18px;
  padding: 9px 17px;
  border-radius: var(--px-radius-pill);
  background: rgba(255, 255, 255, 0.14);
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.22);
  font-size: var(--px-text-sm);
  font-weight: var(--px-weight-medium);
  color: #fff;
  transition: background-color var(--px-duration-fast) var(--px-ease-out);
}

.map-entry__card:hover .map-entry__cta {
  background: rgba(255, 255, 255, 0.22);
}

.map-entry__visual {
  position: relative;
  flex: 0 0 220px;
  width: 220px;
  height: 150px;
}

.map-entry__ring {
  position: absolute;
  inset: 6px 34px 6px 6px;
  border-radius: 50%;
  border: 1px solid rgba(255, 255, 255, 0.16);
}

.map-entry__ring::after {
  content: '';
  position: absolute;
  inset: 32px;
  border-radius: 50%;
  border: 1px dashed rgba(255, 255, 255, 0.14);
}

.map-entry__dot {
  position: absolute;
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: #d8c4a2;
  box-shadow:
    0 0 0 5px rgba(216, 196, 162, 0.14),
    0 0 18px rgba(216, 196, 162, 0.5);
}

.map-entry__dot--a {
  top: 20%;
  left: 28%;
}

.map-entry__dot--b {
  top: 42%;
  left: 62%;
}

.map-entry__dot--c {
  top: 64%;
  left: 22%;
}

.map-entry__dot--d {
  top: 74%;
  left: 66%;
}

.map-entry__compass {
  position: absolute;
  top: 2px;
  right: 6px;
  font-size: 10px;
  font-weight: var(--px-weight-semibold);
  letter-spacing: 0.22em;
  color: rgba(255, 255, 255, 0.32);
}

@media (max-width: 720px) {
  .map-entry__card {
    padding: 26px 24px;
  }

  .map-entry__visual {
    display: none;
  }
}

/* ---------- recommend ---------- */
.recommend {
  padding-top: var(--px-space-8);
}

.section-head {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 24px;
  margin-bottom: var(--px-space-5);
}

.section-head__title {
  margin-top: 8px;
  font-size: var(--px-text-xl);
  color: var(--px-ink-1);
}

.section-head__more {
  display: inline-flex;
  align-items: center;
  gap: 7px;
  padding: 9px 16px;
  border-radius: var(--px-radius-pill);
  background: rgba(255, 255, 255, 0.46);
  box-shadow: var(--px-shadow-1), inset 0 1px 0 rgba(255, 255, 255, 0.7);
  font-size: var(--px-text-sm);
  color: var(--px-ink-2);
  transition:
    background-color var(--px-duration-base) var(--px-ease-out),
    color var(--px-duration-base) var(--px-ease-out),
    transform var(--px-duration-fast) var(--px-ease-out),
    box-shadow var(--px-duration-base) var(--px-ease-out);
}

.section-head__more:hover {
  background: rgba(255, 255, 255, 0.8);
  color: var(--px-accent-deep);
  transform: translateY(-1px);
  box-shadow: var(--px-shadow-2);
}

.section-head__more svg {
  transition: transform var(--px-duration-base) var(--px-ease-out);
}

.section-head__more:hover svg {
  transform: translateX(3px);
}

.card-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: var(--px-space-4);
}

.card-link {
  display: block;
  min-width: 0;
  animation: card-enter 620ms var(--px-ease-out) both;
  animation-delay: calc(var(--i, 0) * 55ms);
}

@keyframes card-enter {
  from {
    opacity: 0;
    transform: translateY(12px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.skeleton-card {
  pointer-events: none;
}

.skeleton-card__body {
  display: flex;
  flex-direction: column;
  gap: 10px;
  padding: 18px 6px 8px;
}
</style>
