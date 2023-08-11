<script setup lang="ts">
const now = ref(new Date())
onMounted(() => setInterval(() => {
  now.value = new Date()
}, 30_000))

const text = computed(() => {
  const date = now.value.toLocaleDateString()
  const time = now.value.toLocaleTimeString().substring(0, 5);
  
  return `${date} ${time}`

})
</script>

<template lang="pug">
ToolbarItem {{ text }}
</template>
