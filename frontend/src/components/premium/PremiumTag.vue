<template>
  <span
    class="px-tag"
    :class="[`px-tag--${tone}`, `px-tag--${variant}`, `px-tag--${size}`]"
  >
    <i v-if="dot" class="px-tag__dot" aria-hidden="true" />
    <slot />
  </span>
</template>

<script setup>
defineProps({
  tone: {
    type: String,
    default: 'neutral',
    validator: (v) => ['neutral', 'primary', 'success', 'warning', 'danger', 'info'].includes(v)
  },
  variant: {
    type: String,
    default: 'soft',
    validator: (v) => ['soft', 'hollow', 'solid'].includes(v)
  },
  size: {
    type: String,
    default: 'md',
    validator: (v) => ['sm', 'md'].includes(v)
  },
  dot: { type: Boolean, default: false }
})
</script>

<style scoped lang="scss">
.px-tag {
  --tag-tone: var(--px-ink-3);
  --tag-soft: var(--px-info-soft);
  --tag-deep: var(--px-ink-2);

  display: inline-flex;
  align-items: center;
  gap: 6px;
  height: 24px;
  padding: 0 10px;
  border-radius: var(--px-radius-pill);
  font-size: var(--px-text-xs);
  font-weight: var(--px-weight-medium);
  line-height: 1;
  letter-spacing: 0.02em;
  white-space: nowrap;
  color: var(--tag-deep);
  background: var(--tag-soft);
  transition:
    background-color var(--px-duration-fast) var(--px-ease-out),
    color var(--px-duration-fast) var(--px-ease-out);
}

.px-tag--sm {
  height: 20px;
  padding: 0 8px;
  font-size: 11px;
}

.px-tag--primary {
  --tag-tone: var(--px-accent);
  --tag-soft: var(--px-accent-soft);
  --tag-deep: var(--px-accent-deep);
}

.px-tag--success {
  --tag-tone: var(--px-success);
  --tag-soft: var(--px-success-soft);
  --tag-deep: #587a6c;
}

.px-tag--warning {
  --tag-tone: var(--px-warning);
  --tag-soft: var(--px-warning-soft);
  --tag-deep: #8d7a52;
}

.px-tag--danger {
  --tag-tone: var(--px-danger);
  --tag-soft: var(--px-danger-soft);
  --tag-deep: #8f5858;
}

.px-tag--info {
  --tag-tone: var(--px-info);
  --tag-soft: var(--px-info-soft);
  --tag-deep: #5c6675;
}

.px-tag--hollow {
  background: rgba(255, 255, 255, 0.34);
  color: var(--tag-deep);
}

.px-tag--solid {
  background: var(--tag-tone);
  color: var(--px-ink-inverse);
}

.px-tag__dot {
  width: 5px;
  height: 5px;
  border-radius: 50%;
  background: currentColor;
  opacity: 0.8;
}
</style>
