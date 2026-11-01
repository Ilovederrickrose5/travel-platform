<template>
  <PremiumCard variant="glass" padding="none" hoverable class="attraction-card">
    <div class="cover">
      <el-image v-if="coverUrl" :src="coverUrl" fit="cover" class="cover__image" lazy>
        <template #error>
          <div class="cover__fallback">{{ name }}</div>
        </template>
      </el-image>
      <div v-else class="cover__fallback">{{ name }}</div>

      <span class="cover__shade" aria-hidden="true" />
      <span v-if="level" class="cover__level">{{ level }}</span>
    </div>

    <div class="card-body">
      <div class="title-row">
        <span class="title">{{ name }}</span>
        <svg class="title-arrow" viewBox="0 0 16 16" width="14" height="14" aria-hidden="true">
          <path d="M3 13L13 3M6 3h7v7" fill="none" stroke="currentColor" stroke-width="1.4" stroke-linecap="round" stroke-linejoin="round" />
        </svg>
      </div>

      <p v-if="reason" class="reason-line">
        <span class="reason-line__dot" />
        {{ reason }}
      </p>

      <div v-if="city || address" class="meta-row">
        <span v-if="city" class="meta meta--city">{{ city }}</span>
        <span v-if="city && address" class="meta__dot" />
        <span v-if="address" class="meta meta--address">{{ address }}</span>
      </div>

      <div class="footer-row">
        <span v-if="price !== null && price !== undefined" class="price">
          <span class="price__symbol">¥</span>{{ price }}<i>起</i>
        </span>
        <span v-else class="price price--muted">暂无报价</span>
        <slot name="extra" />
      </div>
    </div>
  </PremiumCard>
</template>

<script setup>
import PremiumCard from '@/components/premium/PremiumCard.vue'

defineProps({
  name: { type: String, default: '' },
  city: { type: String, default: '' },
  coverUrl: { type: String, default: '' },
  level: { type: String, default: '' },
  reason: { type: String, default: '' },
  address: { type: String, default: '' },
  price: { type: [Number, String], default: null }
})
</script>

<style scoped lang="scss">
.attraction-card {
  width: 100%;
  cursor: pointer;
}

.cover {
  position: relative;
  height: 186px;
  overflow: hidden;
  background: linear-gradient(150deg, rgba(147, 178, 197, 0.3), rgba(196, 183, 162, 0.24));
}

.cover__image,
.cover__fallback {
  width: 100%;
  height: 100%;
}

.cover__image {
  transition: transform 1.1s var(--px-ease-out);
}

.attraction-card:hover .cover__image {
  transform: scale(1.045);
}

.cover__fallback {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0 16px;
  text-align: center;
  font-size: var(--px-text-base);
  font-weight: var(--px-weight-medium);
  color: var(--px-accent-deep);
}

.cover__shade {
  position: absolute;
  inset: 0;
  background: linear-gradient(180deg, rgba(18, 26, 35, 0.05) 0%, transparent 38%, rgba(18, 26, 35, 0.42) 100%);
  pointer-events: none;
}

.cover__level {
  position: absolute;
  top: 14px;
  left: 14px;
  display: inline-flex;
  align-items: center;
  height: 24px;
  padding: 0 10px;
  border-radius: var(--px-radius-pill);
  background: rgba(255, 255, 255, 0.2);
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.32);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  color: #fff;
  font-size: var(--px-text-xs);
  font-weight: var(--px-weight-semibold);
  letter-spacing: 0.04em;
}

.card-body {
  padding: 18px 18px 16px;
}

.title-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 10px;
}

.title {
  font-size: var(--px-text-md);
  font-weight: var(--px-weight-semibold);
  color: var(--px-ink-1);
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  transition: color var(--px-duration-base) var(--px-ease-out);
}

.attraction-card:hover .title {
  color: var(--px-accent-deep);
}

.title-arrow {
  flex: none;
  color: var(--px-ink-4);
  opacity: 0;
  transform: translate(-4px, 4px);
  transition:
    opacity var(--px-duration-base) var(--px-ease-out),
    transform var(--px-duration-base) var(--px-ease-out),
    color var(--px-duration-base) var(--px-ease-out);
}

.attraction-card:hover .title-arrow {
  opacity: 1;
  transform: translate(0, 0);
  color: var(--px-accent);
}

.reason-line {
  display: flex;
  align-items: center;
  gap: 7px;
  margin-top: 8px;
  font-size: var(--px-text-xs);
  font-weight: var(--px-weight-medium);
  letter-spacing: 0.04em;
  color: var(--px-gold);
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.reason-line__dot {
  width: 4px;
  height: 4px;
  flex: none;
  border-radius: 50%;
  background: var(--px-gold);
  opacity: 0.7;
}

.meta-row {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-top: 10px;
  min-width: 0;
  font-size: var(--px-text-xs);
  color: var(--px-ink-3);
}

.meta--city {
  flex: none;
  color: var(--px-ink-2);
  font-weight: var(--px-weight-medium);
}

.meta__dot {
  width: 3px;
  height: 3px;
  flex: none;
  border-radius: 50%;
  background: var(--px-ink-4);
}

.meta--address {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.footer-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-top: 16px;
  padding-top: 14px;
  position: relative;
}

.footer-row::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 1px;
  background: var(--px-gradient-line);
}

.price {
  display: inline-flex;
  align-items: baseline;
  color: var(--px-accent-deep);
  font-size: var(--px-text-lg);
  font-weight: var(--px-weight-semibold);
  font-variant-numeric: tabular-nums;
  line-height: 1;
}

.price__symbol {
  font-size: var(--px-text-xs);
  font-weight: var(--px-weight-medium);
  margin-right: 2px;
  color: var(--px-ink-3);
}

.price i {
  font-style: normal;
  font-size: var(--px-text-xs);
  font-weight: var(--px-weight-regular);
  color: var(--px-ink-3);
  margin-left: 3px;
}

.price--muted {
  font-size: var(--px-text-sm);
  font-weight: var(--px-weight-regular);
  color: var(--px-ink-3);
}
</style>
