<template>
  <div
    class="px-input"
    :class="[
      `px-input--${size}`,
      {
        'is-disabled': disabled,
        'is-error': error,
        'is-textarea': type === 'textarea'
      }
    ]"
  >
    <div v-if="label" class="px-input__label">
      <span>{{ label }}</span>
      <span v-if="optional" class="px-input__optional">选填</span>
    </div>

    <el-input
      ref="inputRef"
      :model-value="modelValue"
      :type="type"
      :placeholder="placeholder"
      :clearable="clearable"
      :disabled="disabled"
      :maxlength="maxlength"
      :rows="rows"
      :show-word-limit="showWordLimit"
      :show-password="type === 'password'"
      :autocomplete="autocomplete"
      :size="elSize"
      @update:model-value="onUpdate"
      @keyup.enter="onEnter"
      @blur="onBlur"
      @focus="onFocus"
      @clear="onClear"
    >
      <template v-if="$slots.prefix" #prefix>
        <slot name="prefix" />
      </template>
      <template v-if="$slots.suffix" #suffix>
        <slot name="suffix" />
      </template>
    </el-input>

    <p v-if="error && typeof error === 'string'" class="px-input__error">{{ error }}</p>
    <p v-else-if="hint" class="px-input__hint">{{ hint }}</p>
  </div>
</template>

<script setup>
import { computed, ref } from 'vue'

const props = defineProps({
  modelValue: { type: [String, Number], default: '' },
  type: { type: String, default: 'text' },
  size: { type: String, default: 'md', validator: (v) => ['md', 'lg'].includes(v) },
  label: { type: String, default: '' },
  optional: { type: Boolean, default: false },
  placeholder: { type: String, default: '' },
  hint: { type: String, default: '' },
  error: { type: [Boolean, String], default: false },
  clearable: { type: Boolean, default: false },
  disabled: { type: Boolean, default: false },
  maxlength: { type: [String, Number], default: undefined },
  showWordLimit: { type: Boolean, default: false },
  rows: { type: Number, default: 3 },
  autocomplete: { type: String, default: 'off' }
})

const emit = defineEmits(['update:modelValue', 'enter', 'blur', 'focus', 'clear'])
const inputRef = ref(null)

const elSize = computed(() => (props.size === 'lg' ? 'large' : 'default'))

function onUpdate(value) {
  emit('update:modelValue', value)
}

function onEnter(event) {
  emit('enter', event)
}

function onBlur(event) {
  emit('blur', event)
}

function onFocus(event) {
  emit('focus', event)
}

function onClear() {
  emit('clear')
}

defineExpose({
  focus: () => inputRef.value?.focus(),
  blur: () => inputRef.value?.blur()
})
</script>

<style scoped lang="scss">
.px-input {
  display: flex;
  flex-direction: column;
  gap: 8px;
  width: 100%;
}

.px-input__label {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  font-size: var(--px-text-sm);
  font-weight: var(--px-weight-medium);
  color: var(--px-ink-2);
}

.px-input__optional {
  font-size: var(--px-text-xs);
  font-weight: var(--px-weight-regular);
  color: var(--px-ink-4);
}

.px-input :deep(.el-input__wrapper) {
  border-radius: var(--px-radius-sm);
  padding: 2px 14px;
  min-height: 42px;
}

.px-input--lg :deep(.el-input__wrapper) {
  min-height: 50px;
  padding: 2px 16px;
}

.px-input--lg :deep(.el-input__inner) {
  font-size: var(--px-text-md);
}

.px-input :deep(.el-textarea__inner) {
  min-height: 88px;
  border-radius: var(--px-radius-md);
  font-family: inherit;
  line-height: var(--px-leading-base);
  resize: vertical;
}

.px-input.is-error :deep(.el-input__wrapper),
.px-input.is-error :deep(.el-textarea__inner) {
  background: rgba(255, 246, 246, 0.9);
  box-shadow:
    inset 0 0 0 1px var(--px-danger),
    0 0 0 4px var(--px-danger-soft);
}

.px-input.is-error :deep(.el-input__inner) {
  color: var(--px-danger);
}

.px-input.is-disabled {
  opacity: 0.6;
}

.px-input__hint {
  font-size: var(--px-text-xs);
  line-height: var(--px-leading-snug);
  color: var(--px-ink-3);
}

.px-input__error {
  font-size: var(--px-text-xs);
  line-height: var(--px-leading-snug);
  color: var(--px-danger);
}
</style>
