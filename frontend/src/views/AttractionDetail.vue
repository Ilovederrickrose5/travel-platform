<template>
  <div class="px-page detail-page">
    <router-link to="/attractions" class="back-link">
      <svg viewBox="0 0 16 16" width="13" height="13" aria-hidden="true">
        <path d="M13 8H3M7 4L3 8l4 4" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
      </svg>
      返回景点列表
    </router-link>

    <div v-if="loading" class="detail-skeleton">
      <PremiumCard variant="quiet" padding="none">
        <el-skeleton animated>
          <template #template>
            <el-skeleton-item variant="image" style="width: 100%; height: 440px" />
          </template>
        </el-skeleton>
      </PremiumCard>
      <PremiumCard variant="glass" padding="lg">
        <el-skeleton :rows="5" animated />
      </PremiumCard>
    </div>

    <PremiumCard v-else-if="!detail" variant="glass" padding="lg">
      <el-empty description="景点不存在或已下线">
        <PremiumButton variant="ghost" @click="router.push('/attractions')">返回景点列表</PremiumButton>
      </el-empty>
    </PremiumCard>

    <template v-else>
      <section class="hero">
        <div class="hero__media">
          <el-image v-if="detail.coverUrl" :src="detail.coverUrl" fit="cover" class="hero__image">
            <template #error>
              <div class="hero__fallback">{{ detail.name }}</div>
            </template>
          </el-image>
          <div v-else class="hero__fallback">{{ detail.name }}</div>
          <div class="hero__veil" aria-hidden="true" />
        </div>

        <div class="hero__content">
          <div class="hero__tags">
            <PremiumTag v-if="detail.level" tone="warning" variant="hollow">{{ detail.level }}</PremiumTag>
            <PremiumTag v-if="detail.city" tone="info" variant="hollow" dot>{{ detail.city }}</PremiumTag>
          </div>
          <h1 class="hero__title">{{ detail.name }}</h1>
          <p class="hero__desc">{{ detail.description || '暂无景点介绍' }}</p>
        </div>

        <button
          v-if="!preview"
          type="button"
          class="hero__fav"
          :class="{ 'is-active': favorited }"
          :disabled="favoriteBusy || favoriteLoading"
          @click="toggleFavorite"
        >
          <svg viewBox="0 0 24 24" width="17" height="17" aria-hidden="true">
            <path
              d="M12 20s-7-4.35-7-9a4 4 0 0 1 7-2.65A4 4 0 0 1 19 11c0 4.65-7 9-7 9z"
              :fill="favorited ? 'currentColor' : 'none'"
              stroke="currentColor"
              stroke-width="1.6"
              stroke-linejoin="round"
            />
          </svg>
          <span>{{ favorited ? '已收藏' : '收藏' }}</span>
        </button>
      </section>

      <div class="facts">
        <div class="fact">
          <span class="fact__icon">
            <svg viewBox="0 0 20 20" width="15" height="15" aria-hidden="true">
              <path d="M10 18s6-5.2 6-9.5A6 6 0 004 8.5C4 12.8 10 18 10 18z" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linejoin="round" />
              <circle cx="10" cy="8.5" r="1.8" fill="none" stroke="currentColor" stroke-width="1.4" />
            </svg>
          </span>
          <div>
            <p class="fact__label">城市</p>
            <p class="fact__value">{{ detail.city || '—' }}</p>
          </div>
        </div>
        <div class="fact">
          <span class="fact__icon">
            <svg viewBox="0 0 20 20" width="15" height="15" aria-hidden="true">
              <path d="M10 3v7l4 2" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
              <circle cx="10" cy="10" r="7" fill="none" stroke="currentColor" stroke-width="1.4" />
            </svg>
          </span>
          <div>
            <p class="fact__label">开放时间</p>
            <p class="fact__value">{{ detail.openTime || '—' }}</p>
          </div>
        </div>
        <div class="fact fact--wide">
          <span class="fact__icon">
            <svg viewBox="0 0 20 20" width="15" height="15" aria-hidden="true">
              <path d="M3 16V7l7-4 7 4v9" fill="none" stroke="currentColor" stroke-width="1.4" stroke-linejoin="round" />
              <path d="M7 16v-5h6v5" fill="none" stroke="currentColor" stroke-width="1.4" stroke-linejoin="round" />
            </svg>
          </span>
          <div>
            <p class="fact__label">地址</p>
            <p class="fact__value">{{ detail.address || '—' }}</p>
          </div>
        </div>
      </div>

      <section v-if="hasGuides" class="guides">
        <article v-if="detail.cultureIntro" class="guide-block">
          <header class="guide-head">
            <p class="px-eyebrow">Local culture</p>
            <h2>风土人文</h2>
          </header>
          <div class="guide-prose">
            <p v-for="(line, index) in paragraphs(detail.cultureIntro)" :key="`culture-${index}`">{{ line }}</p>
          </div>
        </article>

        <div class="guide-split">
          <article v-if="detail.travelGuide" class="guide-block">
            <header class="guide-head">
              <p class="px-eyebrow">Travel guide</p>
              <h2>游玩攻略</h2>
            </header>
            <div class="guide-prose">
              <p v-for="(line, index) in paragraphs(detail.travelGuide)" :key="`guide-${index}`">{{ line }}</p>
            </div>
          </article>

          <aside v-if="detail.localTips" class="guide-tips">
            <header class="guide-head">
              <p class="px-eyebrow">Local tips</p>
              <h2>在地贴士</h2>
            </header>
            <ul>
              <li v-for="(line, index) in paragraphs(detail.localTips)" :key="`tip-${index}`">{{ line }}</li>
            </ul>
          </aside>
        </div>
      </section>

      <section class="tickets">
        <header class="tickets__head">
          <div>
            <p class="px-eyebrow">Tickets</p>
            <h2 class="tickets__title">选择票种</h2>
          </div>
          <p class="tickets__hint">
            {{ preview ? '管理员预览模式 · 仅可浏览，不能下单' : '读完攻略，再决定怎么出发 · 下单后保留 30 分钟' }}
          </p>
        </header>

        <PremiumCard v-if="!detail.ticketTypes?.length" variant="glass" padding="lg">
          <el-empty description="该景点暂未开放在售票种" />
        </PremiumCard>

        <div v-else class="ticket-list">
          <div
            v-for="ticket in detail.ticketTypes"
            :key="ticket.id"
            class="ticket-row"
            :class="{ 'is-sold-out': ticket.status !== 1 }"
          >
            <div class="ticket-row__main">
              <div class="ticket-row__name">
                {{ ticket.name }}
                <PremiumTag v-if="ticket.status === 2" tone="neutral" size="sm">已售罄</PremiumTag>
              </div>
              <p class="ticket-row__desc">{{ ticket.description || '暂无说明' }}</p>
              <p class="ticket-row__limit">每单限购 {{ ticket.purchaseLimit }} 张</p>
            </div>

            <div class="ticket-row__action">
              <div class="ticket-row__price">
                <span v-if="Number(ticket.price) > 0" class="price"><em>¥</em>{{ ticket.price }}</span>
                <span v-else class="price">免费</span>
                <span v-if="Number(ticket.originalPrice) > Number(ticket.price)" class="original">¥{{ ticket.originalPrice }}</span>
              </div>
              <PremiumButton :disabled="ticket.status !== 1 || preview" @click="goOrder(ticket)">
                {{ preview ? '预览模式' : '预订' }}
              </PremiumButton>
            </div>
          </div>
        </div>
      </section>
    </template>
  </div>
</template>

<script setup>
import { computed, onMounted, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import PremiumButton from '@/components/premium/PremiumButton.vue'
import PremiumCard from '@/components/premium/PremiumCard.vue'
import PremiumTag from '@/components/premium/PremiumTag.vue'
import { getAttractionDetail } from '@/api/attraction'
import { addFavorite, getFavoriteIds, removeFavorite } from '@/api/favorites'
import { isAdminPreviewMode } from '@/utils/adminAuth'

const route = useRoute()
const router = useRouter()
const preview = isAdminPreviewMode()

const loading = ref(false)
const detail = ref(null)
const favorited = ref(false)
const favoriteLoading = ref(false)
const favoriteBusy = ref(false)

const hasGuides = computed(() =>
  Boolean(detail.value?.cultureIntro || detail.value?.travelGuide || detail.value?.localTips)
)

function paragraphs(text) {
  return (text || '')
    .split(/\r?\n/)
    .map((line) => line.trim())
    .filter(Boolean)
}

async function loadDetail() {
  loading.value = true
  detail.value = null
  favorited.value = false
  try {
    detail.value = await getAttractionDetail(route.params.id)
  } catch {
    detail.value = null
  } finally {
    loading.value = false
  }
  loadFavoriteState()
}

async function loadFavoriteState() {
  if (preview) return
  favoriteLoading.value = true
  try {
    const ids = (await getFavoriteIds()) || []
    favorited.value = ids.map(String).includes(String(route.params.id))
  } catch {
    favorited.value = false
  } finally {
    favoriteLoading.value = false
  }
}

async function toggleFavorite() {
  if (preview || favoriteBusy.value) return
  favoriteBusy.value = true
  try {
    if (favorited.value) {
      await removeFavorite(route.params.id)
      favorited.value = false
      ElMessage.success('已取消收藏')
    } else {
      await addFavorite(route.params.id)
      favorited.value = true
      ElMessage.success('已加入收藏')
    }
  } catch {
    // 请求层已提示错误
  } finally {
    favoriteBusy.value = false
  }
}

function goOrder(ticket) {
  if (preview) return
  router.push({ path: '/order/create', query: { ticketTypeId: ticket.id } })
}

watch(() => route.params.id, loadDetail)
onMounted(loadDetail)
</script>

<style scoped lang="scss">
.detail-page {
  padding-top: var(--px-space-5);
}

.back-link {
  display: inline-flex;
  align-items: center;
  gap: 7px;
  margin-bottom: var(--px-space-4);
  padding: 8px 14px 8px 11px;
  border-radius: var(--px-radius-pill);
  background: rgba(255, 255, 255, 0.42);
  box-shadow: var(--px-shadow-1), inset 0 1px 0 rgba(255, 255, 255, 0.65);
  color: var(--px-ink-3);
  font-size: var(--px-text-sm);
  transition:
    background-color var(--px-duration-base) var(--px-ease-out),
    color var(--px-duration-base) var(--px-ease-out),
    transform var(--px-duration-fast) var(--px-ease-out);
}

.back-link:hover {
  background: rgba(255, 255, 255, 0.72);
  color: var(--px-ink-1);
  transform: translateX(-2px);
}

.detail-skeleton {
  display: flex;
  flex-direction: column;
  gap: var(--px-space-5);
}

/* ---------- hero ---------- */
.hero {
  position: relative;
  height: 440px;
  border-radius: var(--px-radius-xl);
  overflow: hidden;
  isolation: isolate;
  box-shadow: var(--px-shadow-3), inset 0 1px 0 rgba(255, 255, 255, 0.16);
}

.hero__media {
  position: absolute;
  inset: 0;
  z-index: var(--px-z-decor);
}

.hero__image,
.hero__fallback {
  width: 100%;
  height: 100%;
}

.hero__image {
  transition: transform 1.2s var(--px-ease-out);
}

.hero:hover .hero__image {
  transform: scale(1.03);
}

.hero__fallback {
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(150deg, rgba(147, 178, 197, 0.4), rgba(196, 183, 162, 0.3));
  color: var(--px-accent-deep);
  font-size: var(--px-text-lg);
}

.hero__veil {
  position: absolute;
  inset: 0;
  background:
    linear-gradient(180deg, rgba(16, 24, 33, 0.08) 0%, transparent 34%, rgba(16, 24, 33, 0.7) 100%),
    linear-gradient(90deg, rgba(16, 24, 33, 0.26) 0%, transparent 55%);
}

.hero__content {
  position: absolute;
  left: clamp(32px, 4vw, 56px);
  right: clamp(32px, 4vw, 56px);
  bottom: clamp(32px, 4vw, 52px);
  z-index: var(--px-z-content);
  max-width: 720px;
  color: #fff;
}

.hero__tags {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 16px;
}

.hero__tags :deep(.px-tag) {
  background: rgba(255, 255, 255, 0.16);
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.26);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  color: rgba(255, 255, 255, 0.92);
}

.hero__fav {
  position: absolute;
  top: clamp(20px, 3vw, 28px);
  right: clamp(20px, 3vw, 28px);
  z-index: var(--px-z-content);
  display: inline-flex;
  align-items: center;
  gap: 8px;
  height: 40px;
  padding: 0 16px;
  border: 0;
  border-radius: var(--px-radius-pill);
  background: rgba(255, 255, 255, 0.18);
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.3);
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  color: #fff;
  font-family: inherit;
  font-size: var(--px-text-sm);
  font-weight: var(--px-weight-medium);
  cursor: pointer;
  transition:
    background-color var(--px-duration-base) var(--px-ease-out),
    transform var(--px-duration-fast) var(--px-ease-out),
    color var(--px-duration-base) var(--px-ease-out);
}

.hero__fav:hover {
  background: rgba(255, 255, 255, 0.3);
  transform: translateY(-1px);
}

.hero__fav.is-active {
  background: rgba(255, 255, 255, 0.94);
  color: var(--px-danger, #c2544a);
}

.hero__fav:disabled {
  opacity: 0.7;
  cursor: wait;
}

.hero__title {
  font-size: clamp(30px, 3.2vw, 42px);
  font-weight: var(--px-weight-semibold);
  line-height: 1.18;
  color: #fff;
  text-shadow: 0 6px 30px rgba(10, 16, 22, 0.28);
}

.hero__desc {
  margin-top: 14px;
  max-width: 620px;
  font-size: var(--px-text-base);
  line-height: var(--px-leading-base);
  color: rgba(255, 255, 255, 0.74);
}

/* ---------- facts ---------- */
.facts {
  position: relative;
  z-index: var(--px-z-card);
  display: grid;
  grid-template-columns: 0.8fr 1fr 1.6fr;
  gap: 0;
  margin: -30px 28px 0;
  padding: 22px 26px;
  border-radius: var(--px-radius-lg);
  background: linear-gradient(160deg, rgba(253, 254, 255, 0.82), rgba(240, 245, 249, 0.58));
  box-shadow: var(--px-shadow-2), var(--px-shadow-highlight);
  backdrop-filter: blur(var(--px-blur-lg)) saturate(160%);
  -webkit-backdrop-filter: blur(var(--px-blur-lg)) saturate(160%);
}

.fact {
  display: flex;
  align-items: flex-start;
  gap: 12px;
  padding: 0 22px;
  position: relative;
}

.fact:first-child {
  padding-left: 0;
}

.fact + .fact::before {
  content: '';
  position: absolute;
  left: 0;
  top: 4px;
  bottom: 4px;
  width: 1px;
  background: linear-gradient(180deg, transparent, var(--px-line-strong), transparent);
}

.fact__icon {
  flex: none;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 30px;
  height: 30px;
  border-radius: var(--px-radius-sm);
  background: var(--px-accent-soft);
  color: var(--px-accent-deep);
}

.fact__label {
  font-size: 10px;
  font-weight: var(--px-weight-semibold);
  letter-spacing: 0.18em;
  text-transform: uppercase;
  color: var(--px-ink-3);
}

.fact__value {
  margin-top: 3px;
  font-size: var(--px-text-sm);
  font-weight: var(--px-weight-medium);
  color: var(--px-ink-1);
  line-height: var(--px-leading-snug);
}

/* ---------- guides ---------- */
.guides {
  display: flex;
  flex-direction: column;
  gap: var(--px-space-6);
  margin-top: var(--px-space-7);
}

.guide-block {
  padding: 30px 34px;
  border-radius: var(--px-radius-lg);
  background: linear-gradient(160deg, rgba(253, 254, 255, 0.68), rgba(240, 245, 249, 0.4));
  box-shadow: var(--px-shadow-1), var(--px-shadow-highlight);
  backdrop-filter: blur(var(--px-blur-md));
  -webkit-backdrop-filter: blur(var(--px-blur-md));
}

.guide-head {
  margin-bottom: 18px;
}

.guide-head h2 {
  margin-top: 8px;
  font-size: var(--px-text-xl);
  color: var(--px-ink-1);
}

.guide-prose {
  max-width: 72ch;
}

.guide-prose p {
  font-size: var(--px-text-base);
  line-height: 1.95;
  color: var(--px-ink-2);
}

.guide-prose p + p {
  margin-top: 14px;
}

.guide-split {
  display: grid;
  grid-template-columns: minmax(0, 1.55fr) minmax(0, 1fr);
  gap: var(--px-space-5);
  align-items: start;
}

.guide-tips {
  padding: 26px 28px;
  border-radius: var(--px-radius-lg);
  background: linear-gradient(155deg, rgba(232, 240, 238, 0.72), rgba(247, 242, 233, 0.5));
  box-shadow: var(--px-shadow-1), var(--px-shadow-highlight);
}

.guide-tips ul {
  margin: 0;
  padding: 0;
  list-style: none;
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.guide-tips li {
  position: relative;
  padding-left: 16px;
  font-size: var(--px-text-sm);
  line-height: 1.75;
  color: var(--px-ink-2);
}

.guide-tips li::before {
  content: '';
  position: absolute;
  left: 0;
  top: 0.72em;
  width: 5px;
  height: 5px;
  border-radius: 50%;
  background: var(--px-accent);
  opacity: 0.6;
}

@media (max-width: 900px) {
  .guide-split {
    grid-template-columns: minmax(0, 1fr);
  }

  .guide-block,
  .guide-tips {
    padding: 24px 22px;
  }
}

/* ---------- tickets ---------- */
.tickets {
  margin-top: var(--px-space-7);
}

.tickets__head {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 24px;
  margin-bottom: var(--px-space-4);
}

.tickets__title {
  margin-top: 8px;
  font-size: var(--px-text-xl);
  color: var(--px-ink-1);
}

.tickets__hint {
  font-size: var(--px-text-xs);
  color: var(--px-ink-3);
  letter-spacing: 0.04em;
}

.ticket-list {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.ticket-row {
  position: relative;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 28px;
  padding: 22px 26px;
  border-radius: var(--px-radius-lg);
  background: linear-gradient(155deg, rgba(253, 254, 255, 0.66), rgba(238, 243, 248, 0.42));
  box-shadow: var(--px-shadow-1), var(--px-shadow-highlight);
  backdrop-filter: blur(var(--px-blur-md));
  -webkit-backdrop-filter: blur(var(--px-blur-md));
  transition:
    transform var(--px-duration-slow) var(--px-ease-out),
    box-shadow var(--px-duration-slow) var(--px-ease-out),
    background-color var(--px-duration-base) var(--px-ease-out);
}

.ticket-row::before {
  content: '';
  position: absolute;
  inset: 0 0 auto;
  height: 1px;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.9), transparent);
  opacity: 0.7;
}

.ticket-row:hover {
  transform: translateY(-2px);
  box-shadow: var(--px-shadow-2), var(--px-shadow-highlight);
}

.ticket-row.is-sold-out {
  opacity: 0.62;
}

.ticket-row.is-sold-out:hover {
  transform: none;
}

.ticket-row__main {
  min-width: 0;
}

.ticket-row__name {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: var(--px-text-md);
  font-weight: var(--px-weight-semibold);
  color: var(--px-ink-1);
}

.ticket-row__desc {
  margin-top: 6px;
  font-size: var(--px-text-sm);
  color: var(--px-ink-3);
}

.ticket-row__limit {
  margin-top: 5px;
  font-size: var(--px-text-xs);
  color: var(--px-ink-4);
  letter-spacing: 0.02em;
}

.ticket-row__action {
  display: flex;
  align-items: center;
  gap: 24px;
  flex: none;
}

.ticket-row__price {
  display: flex;
  align-items: baseline;
  gap: 8px;
  text-align: right;
}

.price {
  display: inline-flex;
  align-items: baseline;
  font-size: var(--px-text-lg);
  font-weight: var(--px-weight-semibold);
  color: var(--px-accent-deep);
  font-variant-numeric: tabular-nums;
  line-height: 1;
}

.price em {
  font-style: normal;
  font-size: var(--px-text-xs);
  font-weight: var(--px-weight-medium);
  color: var(--px-ink-3);
  margin-right: 2px;
}

.original {
  color: var(--px-ink-4);
  text-decoration: line-through;
  font-size: var(--px-text-xs);
}
</style>
