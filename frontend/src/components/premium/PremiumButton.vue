<template>
  <button
    :type="htmlType"
    class="px-btn"
    :class="[
      `px-btn--${tone}`,
      `px-btn--${variant}`,
      `px-btn--${size}`,
      { 'px-btn--block': block, 'is-loading': loading, 'is-disabled': disabled }
    ]"
    :disabled="disabled || loading"
    @click="onClick"
  >
    <span v-if="loading" class="px-btn__dots" aria-hidden="true">
      <i /><i /><i />
    </span>
    <span v-else-if="$slots.icon" class="px-btn__icon">
      <slot name="icon" />
    </span>
    <span class="px-btn__label"><slot /></span>
  </button>
</template>

<script setup>
const props = defineProps({
  tone: {
    type: String,
    default: 'primary',
    validator: (v) => ['primary', 'neutral', 'success', 'warning', 'danger'].includes(v)
  },
  variant: {
    type: String,
    default: 'solid',
    validator: (v) => ['solid', 'soft', 'ghost', 'text'].includes(v)
  },
  size: {
    type: String,
    default: 'md',
    validator: (v) => ['sm', 'md', 'lg'].includes(v)
  },
  htmlType: { type: String, default: 'button' },
  loading: { type: Boolean, default: false },
  disabled: { type: Boolean, default: false },
  block: { type: Boolean, default: false }
})

const emit = defineEmits(['click'])

function onClick(event) {
  if (props.disabled || props.loading) {
    event.preventDefault()
    return
  }
  emit('click', event)
}
</script>

<style scoped lang="scss">
.px-btn {
  --btn-tone: var(--px-accent);
  --btn-deep: var(--px-accent-deep);
  --btn-soft: var(--px-accent-soft);
  --btn-glow: var(--px-shadow-accent);
  --btn-gradient: var(--px-gradient-accent);
  --btn-height: 42px;
  --btn-pad: 22px;
  --btn-text: var(--px-text-base);

  position: relative;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  height: var(--btn-height);
  padding: 0 var(--btn-pad);
  border: 0;
  border-radius: var(--px-radius-pill);
  font-family: inherit;
  font-size: var(--btn-text);
  font-weight: var(--px-weight-medium);
  line-height: 1;
  letter-spacing: 0.01em;
  white-space: nowrap;
  cursor: pointer;
  user-select: none;
  color: var(--px-ink-1);
  background: transparent;
  transition:
    transform var(--px-duration-fast) var(--px-ease-out),
    box-shadow var(--px-duration-base) var(--px-ease-out),
    background-color var(--px-duration-base) var(--px-ease-out),
    color var(--px-duration-base) var(--px-ease-out),
    opacity var(--px-duration-base) var(--px-ease-out);
}

.px-btn:focus-visible {
  outline: none;
  box-shadow:
    0 0 0 2px var(--px-bg),
    0 0 0 4px var(--btn-tone);
}

.px-btn--sm {
  --btn-height: 32px;
  --btn-pad: 14px;
  --btn-text: var(--px-text-sm);
}

.px-btn--lg {
  --btn-height: 52px;
  --btn-pad: 30px;
  --btn-text: var(--px-text-md);
}

.px-btn--block {
  display: flex;
  width: 100%;
}

/* tones */
.px-btn--primary {
  --btn-tone: var(--px-accent);
  --btn-deep: var(--px-accent-deep);
  --btn-soft: var(--px-accent-soft);
  --btn-glow: var(--px-shadow-accent);
  --btn-gradient: var(--px-gradient-accent);
}

.px-btn--neutral {
  --btn-tone: #7d8794;
  --btn-deep: #4f5a68;
  --btn-soft: rgba(32, 42, 54, 0.07);
  --btn-glow: var(--px-shadow-2);
  --btn-gradient: linear-gradient(135deg, #5c6675 0%, #8b95a3 100%);
}

.px-btn--success {
  --btn-tone: var(--px-success);
  --btn-deep: #587a6c;
  --btn-soft: var(--px-success-soft);
  --btn-glow: 0 10px 24px rgba(111, 150, 134, 0.22);
  --btn-gradient: linear-gradient(135deg, #6f9686 0%, #93b3a5 100%);
}

.px-btn--warning {
  --btn-tone: var(--px-warning);
  --btn-deep: #8d7a52;
  --btn-soft: var(--px-warning-soft);
  --btn-glow: 0 10px 24px rgba(176, 154, 112, 0.22);
  --btn-gradient: linear-gradient(135deg, #b09a70 0%, #cbb98f 100%);
}

.px-btn--danger {
  --btn-tone: var(--px-danger);
  --btn-deep: #8f5858;
  --btn-soft: var(--px-danger-soft);
  --btn-glow: 0 10px 24px rgba(178, 112, 112, 0.22);
  --btn-gradient: linear-gradient(135deg, #b27070 0%, #c99696 100%);
}

/* variants */
.px-btn--solid {
  color: var(--px-ink-inverse);
  background: var(--btn-gradient);
  box-shadow: var(--btn-glow), var(--px-shadow-highlight);
}

.px-btn--solid:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: var(--px-shadow-3), var(--px-shadow-highlight);
}

.px-btn--solid:active:not(:disabled) {
  transform: translateY(0) scale(0.98);
  box-shadow: var(--px-shadow-1);
}

.px-btn--soft {
  color: var(--btn-deep);
  background: var(--btn-soft);
}

.px-btn--soft:hover:not(:disabled) {
  transform: translateY(-2px);
  background: var(--btn-tone);
  color: var(--px-ink-inverse);
  box-shadow: var(--btn-glow);
}

.px-btn--soft:active:not(:disabled) {
  transform: translateY(0) scale(0.98);
  box-shadow: var(--px-shadow-1);
}

.px-btn--ghost {
  color: var(--px-ink-2);
  background: rgba(255, 255, 255, 0.46);
  box-shadow: var(--px-shadow-1), var(--px-shadow-highlight);
  backdrop-filter: blur(var(--px-blur-sm));
  -webkit-backdrop-filter: blur(var(--px-blur-sm));
}

.px-btn--ghost:hover:not(:disabled) {
  transform: translateY(-2px);
  background: rgba(255, 255, 255, 0.78);
  color: var(--px-ink-1);
  box-shadow: var(--px-shadow-2);
}

.px-btn--ghost:active:not(:disabled) {
  transform: translateY(0) scale(0.98);
}

.px-btn--text {
  color: var(--btn-deep);
  background: transparent;
}

.px-btn--text:hover:not(:disabled) {
  background: var(--btn-soft);
}

.px-btn--text:active:not(:disabled) {
  transform: scale(0.97);
}

/* states */
.px-btn:disabled,
.px-btn.is-disabled {
  cursor: not-allowed;
  opacity: 0.48;
  transform: none;
  box-shadow: none;
}

.px-btn.is-loading {
  cursor: progress;
  opacity: 0.86;
}

.px-btn__icon {
  display: inline-flex;
  align-items: center;
  font-size: 1.05em;
}

.px-btn__label {
  display: inline-flex;
  align-items: center;
}

.px-btn__dots {
  display: inline-flex;
  align-items: flex-end;
  gap: 4px;
  height: 10px;
}

.px-btn__dots i {
  width: 4px;
  height: 4px;
  border-radius: 50%;
  background: currentColor;
  animation: px-btn-pulse 1.4s var(--px-ease-soft) infinite;
}

.px-btn__dots i:nth-child(2) {
  animation-delay: 0.18s;
}

.px-btn__dots i:nth-child(3) {
  animation-delay: 0.36s;
}

@keyframes px-btn-pulse {
  0%,
  100% {
    opacity: 0.28;
    transform: translateY(0);
  }
  45% {
    opacity: 1;
    transform: translateY(-2px);
  }
}
</style>
