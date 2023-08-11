<script setup lang="ts">
const version = computed(() => {
  const urlParams = new URLSearchParams(window.location.search)
  return urlParams.get('template') || 'main'
})
</script>

<template lang="pug">
.toolbars
  ToolbarTemplateMain.toolbars-main
  ToolbarTemplateSecondary.toolbars-secondary
</template>

<style scoped>
.toolbars {
  height: 100vh;
  display: flex;
  flex-direction: column;
}

.toolbars-main {
  flex: 0 0 40px;
  max-height: 40px;
  z-index: 30;
}

.toolbars-secondary {
  flex: 0 0 56px;
  max-height: 56px;
  z-index: 20;
}

.toolbars-fill {
  flex: 1 1;
  z-index: 10;
}
</style>
