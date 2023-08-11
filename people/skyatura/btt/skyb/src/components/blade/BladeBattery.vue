<script setup lang="ts">
const btt = useBTT()

const level = ref(0)

type BatteryStatus = 'unknown' | 'charging' | 'discharging'
const status = ref<BatteryStatus>('unknown')

const color = computed(() => {
  const batteryLevel = level.value
  const batteryStatus = status.value
  if (batteryStatus === 'unknown') return 'cyan'
  if (batteryStatus === 'charging') return 'green'
  if (batteryLevel < 20) return 'red'
  if (batteryLevel < 60) return 'yellow'
  return 'white'
})

const tick = async () => {
  const raw = await btt.blade('getBattery')
  const [levelString, statusString] = raw.split('; ')
  level.value = parseInt(levelString, 10)
  status.value = statusString as BatteryStatus
}
onMounted(() => {
  setInterval(tick, 60_000)
  tick()
})
</script>

<template lang="pug">
ToolbarItem(:style="{ color: color }" v-if="level > 0 || status !== 'unknown'") {{ level }}%
</template>
