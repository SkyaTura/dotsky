<script setup lang="ts">
const btt = useBTT()

interface BTTData {

}

const state = ref({
  playing: 0,
  artist: '',
  title: '',
  album: '',
  duration: 0,
  number: 0,
  artwork: '',
})
const cover = ref('')

const get = {
  playing: () => btt.getNumber('BTTCurrentlyPlaying').catch(() => 0),
  artist: () => btt.getString('BTTNowPlayingInfoArtist').catch(() => ''),
  title: () => btt.getString('BTTNowPlayingInfoTitle').catch(() => ''),
  album: () => btt.getString('BTTNowPlayingInfoAlbum').catch(() => ''),
  duration: () => btt.getNumber('BTTNowPlayingInfoDuration').catch(() => 0),
  number: () => btt.getNumber('BTTNowPlayingInfoTrackNumber').catch(() => 0),
  artwork: () => btt.getString('BTTNowPlayingInfoArtworkData').catch(() => ''),
}

const tick = () => {
  get.playing().then((playing) => Object.assign(state.value, { playing }))
  get.title().then((title) => Object.assign(state.value, { title }))
  get.album().then((album) => Object.assign(state.value, { album }))
  get.artist().then((artist) => Object.assign(state.value, { artist }))
}
btt.events.on('BTTNowPlayingInfoChanged', tick)
tick()

const status = computed(() => {
  if (state.value.playing) return 'playing'
  if (!state.value.playing && state.value.title) return 'paused'
  return 'stoped'
})

const coverCache = new Map()
const fetchCoverInfo = async (searchQuery: string) => {
  if (coverCache.has(searchQuery)) return coverCache.get(searchQuery)
  const encodedQuery = encodeURIComponent(searchQuery)
  const url = `https://musicbrainz.org/ws/2/recording/?query=${encodedQuery}&limit=1&fmt=json`
  const result = fetch(url).then(response => response.json()).catch(() => null)
  coverCache.set(searchQuery, result)
  return result
}
const fetchCoverURL = async (query: { title: string, album: string, artist: string }) => {
  const searchQuery = [
    ['recording', query.title],
    ['album', query.album],
    ['artist', query.artist],
  ].map(([k, v]) => `${k}:'${v}'`).join(' AND ')

  const info = await fetchCoverInfo(searchQuery)
  const releases = info?.recordings?.[0]?.releases
  if (!releases?.length) return ''
  const albumLower = state.value.album.toLowerCase()
  const release = releases.find(item => item.title.toLowerCase() === albumLower) ?? releases[0]
  const id = release?.id
  if (!id) return ''
  return `https://coverartarchive.org/release/${id}/front`
}
watch(() => [state.value.title, state.value.artist, state.value.album], async ([title, artist, album]) => {
  cover.value = ''
  const url = await fetchCoverURL({ artist, title, album })
  if (title !== state.value.title || artist !== state.value.artist || album !== state.value.album) return
  cover.value = url ?? ''
})

const coverHoverDelay = ref(0)
const coverStyle = computed(() => !cover.value ? {} : {
  '--cover': cover.value ? `url(${cover.value})` : null,
  '--hover-delay': `${coverHoverDelay.value}s`,
})


onMounted(() => {
  let mouseOver = false
  document.body.addEventListener('mouseenter', () => {
    mouseOver = true
    setTimeout(() => {
      if (!mouseOver) return
      coverHoverDelay.value = 0
    }, 750)
  })
  document.body.addEventListener('mouseleave', () => {
    mouseOver = true
    coverHoverDelay.value = 0.75
  })
})
</script>

<template lang="pug">
ToolbarItem.nowPlaying(:class="status")
  .nowPlaying_texts
    .title {{ state.title }}
    .album {{ state.album }}
    .artist {{ state.artist }}
  .nowPlaying_status
    .playing &#x25B6;&#xFE0E;
    .paused &#x25A9;
    .cover(:style="coverStyle")
</template>

<style scoped>
.nowPlaying {
  font-size: 0.95em;
  line-height: 0.95em;
  display: flex;
  align-items: center;
  text-align: right;
  transition: all .5s;
  white-space: nowrap;

  &:not(.playing) {
    opacity: 0.6;
  }
}

.nowPlaying_texts {
  transition: all .5s;

  .nowPlaying:not(.playing) & {
    opacity: 0.8;
  }
}

.nowPlaying_status {
  margin-left: 8px;
  font-size: 1.5em;
  width: 38px;
  height: 38px;
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  --hover-delay: .75s;
  transition: --hover-delay 0.75s;
  transition-delay: 0.75s;

  body & {
    --hover-delay: 0s;
  }

  & * {
    position: absolute;
    transition: all .5s;
  }

  & .cover {
    background-image: var(--cover);
    background-size: cover;
    height: 100%;
    width: 100%;
    transition: all .15s linear;
    transform-origin: top right;
  }

  & .cover:hover {
    transform: translateX(-8px) scale(4);
    transition: all .5s linear;
    transition-delay: var(--hover-delay);
  }

  .nowPlaying:not(.stoped) & .stoped,
  .nowPlaying:not(.paused) & .paused,
  .nowPlaying:not(.playing) & .playing,
  .nowPlaying:not(.playing) & .cover {
    opacity: 0;
    transform: scale(0.5);
  }
}
</style>
