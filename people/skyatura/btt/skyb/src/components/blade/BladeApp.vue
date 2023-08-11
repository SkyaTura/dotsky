<script setup lang="ts">
  const btt = useBTT()
  const activeApp = ref('')
  const tick = async () => {
    activeApp.value = await btt.callBTT('get_string_variable', {variable_name: 'BTTActiveAppBundleIdentifier'});
  }
  btt.events.on('BTTVariableChanged', (name) => {
    if (name !== 'BTTActiveAppBundleIdentifier') return
    tick()
  })
  onMounted(tick)
</script>

<template lang="pug">
ToolbarItem {{ activeApp }}
</template>
