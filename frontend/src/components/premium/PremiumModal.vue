<template>
  <el-dialog
    class="px-modal"
    modal-class="px-modal-overlay"
    :model-value="modelValue"
    :width="width"
    :show-close="false"
    :close-on-click-modal="closeOnClickModal"
    :close-on-press-escape="closeOnPressEscape"
    :destroy-on-close="destroyOnClose"
    :align-center="alignCenter"
    append-to-body
    @update:model-value="(v) => $emit('update:modelValue', v)"
    @closed="$emit('closed')"
    @opened="$emit('opened')"
  >
    <template #header="{ close }">
      <div class="px-modal__head">
        <div class="px-modal__heading">
          <p v-if="eyebrow" class="px-modal__eyebrow">{{ eyebrow }}</p>
          <h3 class="px-modal__title">{{ title }}</h3>
          <p v-if="subtitle" class="px-modal__subtitle">{{ subtitle }}</p>
        </div>
        <button
          v-if="showClose"
          type="button"
          class="px-modal__close"
          aria-label="关闭"
          @click="close"
        >
          <svg viewBox="0 0 24 24" width="16" height="16" aria-hidden="true">
            <path
              d="M6 6l12 12M18 6L6 18"
              fill="none"
              stroke="currentColor"
              stroke-width="1.6"
              stroke-linecap="round"
            />
          </svg>
        </button>
      </div>
    </template>

    <div class="px-modal__body">
      <slot />
    </div>

    <template v-if="$slots.footer" #footer>
      <div class="px-modal__footer">
        <slot name="footer" />
      </div>
    </template>
  </el-dialog>
</template>

<script setup>
defineProps({
  modelValue: { type: Boolean, default: false },
  title: { type: String, default: '' },
  subtitle: { type: String, default: '' },
  eyebrow: { type: String, default: '' },
  width: { type: [String, Number], default: '520px' },
  closeOnClickModal: { type: Boolean, default: true },
  closeOnPressEscape: { type: Boolean, default: true },
  destroyOnClose: { type: Boolean, default: false },
  alignCenter: { type: Boolean, default: true },
  showClose: { type: Boolean, default: true }
})

defineEmits(['update:modelValue', 'closed', 'opened'])
</script>

<style lang="scss">
.px-modal-overlay {
  background: rgba(24, 32, 42, 0.3);
  backdrop-filter: blur(8px) saturate(120%);
  -webkit-backdrop-filter: blur(8px) saturate(120%);
}

.el-dialog.px-modal {
  padding: 0;
  border-radius: var(--px-radius-xl);
  background: linear-gradient(155deg, rgba(255, 255, 255, 0.9), rgba(248, 250, 252, 0.78));
  box-shadow: var(--px-shadow-3), inset 0 1px 0 rgba(255, 255, 255, 0.9);
  backdrop-filter: blur(var(--px-blur-lg)) saturate(160%);
  -webkit-backdrop-filter: blur(var(--px-blur-lg)) saturate(160%);
  overflow: hidden;
}

.el-dialog.px-modal::before {
  content: '';
  position: absolute;
  inset: 0 0 auto;
  height: 1px;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.95), transparent);
  z-index: 2;
}

.el-dialog.px-modal .el-dialog__header {
  margin: 0;
  padding: 26px 28px 18px;
}

.el-dialog.px-modal .el-dialog__body {
  padding: 0 28px 8px;
}

.el-dialog.px-modal .el-dialog__footer {
  padding: 18px 28px 26px;
}

.px-modal__head {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 20px;
}

.px-modal__heading {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.px-modal__eyebrow {
  font-size: var(--px-text-xs);
  font-weight: var(--px-weight-semibold);
  letter-spacing: 0.16em;
  text-transform: uppercase;
  color: var(--px-ink-3);
}

.px-modal__title {
  font-size: var(--px-text-lg);
  font-weight: var(--px-weight-semibold);
  line-height: var(--px-leading-tight);
  color: var(--px-ink-1);
}

.px-modal__subtitle {
  font-size: var(--px-text-sm);
  line-height: var(--px-leading-snug);
  color: var(--px-ink-3);
}

.px-modal__close {
  flex: none;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 34px;
  height: 34px;
  margin-top: -4px;
  border: 0;
  border-radius: var(--px-radius-pill);
  background: rgba(32, 42, 54, 0.04);
  color: var(--px-ink-3);
  cursor: pointer;
  transition:
    background-color var(--px-duration-fast) var(--px-ease-out),
    color var(--px-duration-fast) var(--px-ease-out),
    transform var(--px-duration-fast) var(--px-ease-out);
}

.px-modal__close:hover {
  background: rgba(32, 42, 54, 0.08);
  color: var(--px-ink-1);
  transform: rotate(90deg);
}

.px-modal__body {
  padding-top: 4px;
}

.px-modal__footer {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 12px;
}

.dialog-fade-enter-active .el-dialog.px-modal {
  animation: px-modal-in var(--px-duration-slow) var(--px-ease-out) both;
}

.dialog-fade-leave-active .el-dialog.px-modal {
  animation: px-modal-out var(--px-duration-fast) var(--px-ease-soft) both;
}

@keyframes px-modal-in {
  from {
    opacity: 0;
    transform: translateY(14px) scale(0.985);
  }
  to {
    opacity: 1;
    transform: translateY(0) scale(1);
  }
}

@keyframes px-modal-out {
  from {
    opacity: 1;
    transform: translateY(0) scale(1);
  }
  to {
    opacity: 0;
    transform: translateY(8px) scale(0.99);
  }
}
</style>
