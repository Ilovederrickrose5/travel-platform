<template>
  <component
    :is="tag"
    class="px-card"
    :class="[
      `px-card--${variant}`,
      `px-card--pad-${padding}`,
      {
        'px-card--hoverable': hoverable,
        'px-card--floating': floating,
        'px-card--breathe': breathe
      }
    ]"
  >
    <div v-if="$slots.header" class="px-card__header">
      <slot name="header" />
    </div>
    <div class="px-card__body">
      <slot />
    </div>
    <div v-if="$slots.footer" class="px-card__footer">
      <slot name="footer" />
    </div>
  </component>
</template>

<script setup>
defineProps({
  tag: { type: String, default: 'div' },
  variant: {
    type: String,
    default: 'glass',
    validator: (v) => ['glass', 'solid', 'quiet'].includes(v)
  },
  padding: {
    type: String,
    default: 'md',
    validator: (v) => ['none', 'sm', 'md', 'lg'].includes(v)
  },
  hoverable: { type: Boolean, default: false },
  floating: { type: Boolean, default: false },
  breathe: { type: Boolean, default: false }
})
</script>

<style scoped lang="scss">
.px-card {
  position: relative;
  z-index: var(--px-z-card);
  border-radius: var(--px-radius-lg);
  isolation: isolate;
  transition:
    transform var(--px-duration-slow) var(--px-ease-out),
    box-shadow var(--px-duration-slow) var(--px-ease-out),
    background-color var(--px-duration-slow) var(--px-ease-out);
  overflow: hidden;
}

.px-card::before {
  content: '';
  position: absolute;
  inset: 0 0 auto;
  height: 1px;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.9) 30%, rgba(255, 255, 255, 0.9) 70%, transparent);
  opacity: 0.7;
  pointer-events: none;
  z-index: 2;
}

.px-card::after {
  content: '';
  position: absolute;
  inset: 0;
  border-radius: inherit;
  background: radial-gradient(140% 90% at 12% 0%, rgba(255, 255, 255, 0.22), transparent 58%);
  pointer-events: none;
  z-index: 0;
}

.px-card--glass {
  background: var(--px-gradient-glass);
  box-shadow: var(--px-shadow-2), var(--px-shadow-highlight);
  backdrop-filter: blur(var(--px-blur-md)) saturate(150%);
  -webkit-backdrop-filter: blur(var(--px-blur-md)) saturate(150%);
}

.px-card--solid {
  background: var(--px-surface-strong);
  box-shadow: var(--px-shadow-2), var(--px-shadow-highlight);
  backdrop-filter: blur(var(--px-blur-sm)) saturate(130%);
  -webkit-backdrop-filter: blur(var(--px-blur-sm)) saturate(130%);
}

.px-card--quiet {
  background: var(--px-surface-soft);
  box-shadow: var(--px-shadow-1);
  backdrop-filter: blur(var(--px-blur-sm));
  -webkit-backdrop-filter: blur(var(--px-blur-sm));
}

.px-card--hoverable:hover {
  transform: translateY(-4px);
  box-shadow: var(--px-shadow-3), var(--px-shadow-highlight);
}

.px-card--floating {
  box-shadow: var(--px-shadow-3), var(--px-shadow-highlight);
}

.px-card--breathe {
  animation: px-card-breathe var(--px-duration-breathe) var(--px-ease-soft) infinite alternate;
}

@keyframes px-card-breathe {
  from {
    box-shadow: var(--px-shadow-1), var(--px-shadow-highlight);
  }
  to {
    box-shadow: var(--px-shadow-2), var(--px-shadow-highlight);
  }
}

.px-card__header,
.px-card__body,
.px-card__footer {
  position: relative;
  z-index: 1;
}

.px-card__header {
  padding: var(--px-space-5) var(--px-space-5) var(--px-space-4);
}

.px-card__header::after {
  content: '';
  position: absolute;
  left: var(--px-space-5);
  right: var(--px-space-5);
  bottom: 0;
  height: 1px;
  background: var(--px-gradient-line);
}

.px-card__footer {
  padding: var(--px-space-4) var(--px-space-5) var(--px-space-5);
}

.px-card__footer::before {
  content: '';
  position: absolute;
  left: var(--px-space-5);
  right: var(--px-space-5);
  top: 0;
  height: 1px;
  background: var(--px-gradient-line);
}

.px-card--pad-none > .px-card__body {
  padding: 0;
}

.px-card--pad-sm > .px-card__body {
  padding: var(--px-space-4);
}

.px-card--pad-md > .px-card__body {
  padding: var(--px-space-5);
}

.px-card--pad-lg > .px-card__body {
  padding: var(--px-space-6);
}

.px-card--pad-none > .px-card__header {
  padding-left: var(--px-space-5);
  padding-right: var(--px-space-5);
}
</style>
