<script setup lang="ts">
  const btt = useBTT()
  const text = ref('')
  btt.blade('me').then(value => Object.assign(text, { value }))
</script>

<template lang="pug">
ToolbarItem {{ text }}
</template>
