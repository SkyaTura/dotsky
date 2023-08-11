<script setup lang="ts">
import { useClipboard } from '@vueuse/core'

const { copy } = useClipboard()
const { blade, shell } = useBTT()

const ips = ref([] as string[])
const hosts = ref<Record<'Allynna' | 'Garfield', '???' | 'Lan' | 'VPN'>>({
  Allynna: '???',
  Garfield: '???',
})

const tickHosts = async () => {
  const [allynna, garfield] = await Promise.all([
    shell("getent hosts allynna | grep -E '\\sallynna' | awk '{ print $1 }'", '-i -c'),
    shell("getent hosts garfield | grep -E '\\sgarfield' | awk '{ print $1 }'", '-i -c'),
  ])
  hosts.value.Allynna = allynna.trim().startsWith('10.10') ? 'VPN' : 'Lan' 
  hosts.value.Garfield = garfield.startsWith('10.10') ? 'VPN' : 'Lan' 
}

const tickIps = async() => {
  const rawList = await blade('getIp')
  ips.value = rawList
    .split(/\s{1,}/g)
    .map(v => v.trim())
    .filter(Boolean)

}

const tick = () => {
  tickIps()
  tickHosts()
}

onMounted(() => setInterval(tick, 300_000))
tick()
</script>

<template lang="pug">
ToolbarItemHoverGroup.hostsBlade
  template(#idle)
    .hosts
      .host(v-for="(env, host) in hosts") {{ host }}: {{ env }}
  template(#hover)
    .ips
      .ip(v-for="ip in ips" @click="copy(ip)") {{ ip }}
</template>

<style scoped>
.hostsBlade {
  min-width: 95px;
  align-self: stretch;
}
.hosts, .ips {
  height: 100%;
  display: flex;
  flex-direction: column;
  justify-content: space-around;
}
.hosts {
  font-size: 10px;
  line-height: 9px;
}
.ips {
  font-size: 9px;
  line-height: 6px;
}
.ip {
  cursor: pointer;
}
</style>
