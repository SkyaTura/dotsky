const SKB = {}

const shell = (shellScript, parameters = '-c', launchPath = '/bin/zsh') => runShellScript({
  script: shellScript, // mandatory
  launchPath, //optional - default is /bin/bash
  parameters, // optional - default is -c
  environmentVariables: '', //optional e.g. VAR1=/test/;VAR2=/test2/;
})
window.shell = shell

const blade = (args) => shell(`sbar-blades ${args}`)
const say = (msg) => shell(`say ${msg}`)

const loadHASS = async () => {
  const runCommand = (path, payload) => shell(`hass-cli 'services/${path}' '${JSON.stringify(payload)}'`)
  const getTemplate = (template) => shell(`hass-cli "template" "${JSON.stringify({ template })}"`)

  const slotMode = document.body.querySelector('#hass_social .mode')
  const slotZone = document.body.querySelector('#hass_social .zone')
  const slotOff = document.body.querySelector('#hass_social .off')

  slotMode.addEventListener('click', () => runCommand('input_select/select_next', {
    entity_id: 'input_select.social',
    cycle: true,
  }))
  slotZone.addEventListener('click', () => runCommand('input_select/select_next', {
    entity_id: 'input_select.social_zones',
    cycle: true,
  }))
  slotOff.addEventListener('click', () => runCommand('light/toggle', {
    entity_id: 'light.social_teto',
  }))
}

const loadClock = () => {
  const clock = document.body.querySelector('#clock')
  const setText = (innerText) => Object.assign(clock, {innerText})
  const tick = () => {
    const now = new Date()
    const date = now.toLocaleDateString()
    const time = now.toLocaleTimeString().substr(0, 5)
    setText(`${date} ${time}`)
  }
  clock.addEventListener('click', () => tick())
  setInterval(tick, 30000)
  tick()

  console.log('clock loaded')
}

const loadIps = () => {
  const ip = document.body.querySelector('#ip')
  const setText = (innerText) => Object.assign(ip, {innerText})
  const tick = async () => {
    const rawList = await blade('getIp')
    const list = rawList
      .split(/\s{1,}/g)
      .map(v => v.trim())
      .filter(Boolean)
      .join(`\n`)
    setText(list)
  }
  ip.addEventListener('click', () => {
    tick()
    blade('copyIp')
  })
  setInterval(tick, 300_000)
  tick()

  console.log('ips loaded')
}

const loadHosts = () => {
  const hosts = document.body.querySelector('#hosts')
  const setText = (innerText) => Object.assign(hosts, {innerText})
  const tick = async () => {
    const allynna = await shell("getent hosts allynna | grep -E '\\sallynna' | awk '{ print $1 }'", '-i -c')
    const garfield = await shell("getent hosts garfield | grep -E '\\sgarfield' | awk '{ print $1 }'", '-i -c')
    const list = [
      `Allynna: ${allynna.trim().startsWith('10.10') ? 'VPN' : 'Lan' }`,
      `Garfield: ${garfield.startsWith('10.10') ? 'VPN' : 'Lan' }`,
    ].join(`\n`)
    setText(list)
  }
  ip.addEventListener('click', () => {
    tick()
    blade('copyIp')
  })
  setInterval(tick, 300_000)
  tick()

  console.log('ips loaded')
}

const loadBattery = () => {
  const slot = document.body.querySelector('#battery')
  const getColor = (level, charging) => {
    if (level === '??') return 'cyan'
    if (charging) return 'green'
    if (level < 20) return 'red'
    if (level < 60) return 'yellow'
    return 'white'
  }
  const update = (level, charging) => {
    slot.innerText = `${level}%`
    slot.style.color = getColor(level, charging)
  }
  const tick = async () => {
    const raw = await blade('getBattery')
    const [levelString, status] = raw.split('; ')
    const level = parseInt(levelString, 10)

    update(isNaN(level) ? '??' : level, status !== 'discharging')
  }
  slot.addEventListener('click', tick)
  setInterval(tick, 60_000)
  tick()

  console.log('battery loaded')
}

const loadMe = () => {
  const slot = document.body.querySelector('#me')
  const tick = async () => {
    slot.innerText = await blade('me')
  }
  slot.addEventListener('dblclick', tick)
  tick()

  console.log('me loaded')
}

const loadNotificationHandler = () => {
  const nameHandler = mappings => name => mappings[name]?.()
  const noteHandlers = {
    BTTNowPlayingInfoChanged: () => SKB.tickNowPlaying?.(),
    BTTVariableChanged: nameHandler({
      async BTTActiveAppBundleIdentifier() {
        const slot = document.body.querySelector('#activeApp')
        if (!slot) return
        const bundleIdentifier = await callBTT('get_string_variable', {variable_name: 'BTTActiveAppBundleIdentifier'});
        slot.innerText = bundleIdentifier
      }
    })
  }

  SKB.BTTNotification = (payload) => {
    const { note, name } = JSON.parse(payload)
    console.log(payload, noteHandlers)
    noteHandlers[note]?.(name)
  }
  console.log('notification_handler loaded')
}

const loadNowPlaying = () => {
  const slots = {
    title: document.body.querySelector('#nowPlaying_texts .title'),
    album: document.body.querySelector('#nowPlaying_texts .album'),
    artist: document.body.querySelector('#nowPlaying_texts .artist'),
    nowPlaying: document.body.querySelector('#nowPlaying'),
    cover: document.body.querySelector('#nowPlaying_status .cover'),
  }
  const setText = (slot, text) => {
    const el = slots[slot]
    if (!el) return
    el.innerText = text ?? ''
  }
  const setCover = (url) => {
    slots.cover.style.backgroundImage = url ? `url(${url})` : ''
    slots.cover.classList.toggle('has', !!url)
  }
  const setStatus = (token) => slots.nowPlaying.className = token ?? ''

  const infoCache = new Map()
  const fetchInfo = async (bttData) => {
    const SEARCH_QUERY = [
      ['recording', bttData.title],
      ['album', bttData.album],
      ['artist', bttData.artist],
    ].map(([k, v]) => `${k}:'${v}'`).join(' AND ')
    if (infoCache.has(SEARCH_QUERY)) return infoCache.get(SEARCH_QUERY)
    const ENCODED_QUERY = encodeURIComponent(SEARCH_QUERY)
    const url = `https://musicbrainz.org/ws/2/recording/?query=${ENCODED_QUERY}&limit=1&fmt=json`
    const result = fetch(url).then(response => response.json()).catch(() => null)
    infoCache.set(SEARCH_QUERY, result)
    return result
  }
  const fetchCover = async (bttData) => {
    const info = await fetchInfo(bttData)
    const releases = info?.recordings?.[0]?.releases
    if (!releases?.length) return null
    const albumLower = bttData.album.toLowerCase()
    const release = releases.find(item => item.title.toLowerCase() === albumLower) ?? releases[0]
    const id = release?.id
    if (!id) return null
    return `https://coverartarchive.org/release/${id}/front`
  }

  const tick   = async () => {
    const promises = {
      playing: callBTT('get_number_variable', { variable_name: 'BTTCurrentlyPlaying' }),
      artist: callBTT('get_string_variable', { variable_name: 'BTTNowPlayingInfoArtist' }),
      title: callBTT('get_string_variable', { variable_name: 'BTTNowPlayingInfoTitle' }),
      album: callBTT('get_string_variable', { variable_name: 'BTTNowPlayingInfoAlbum' }),
      // duration: callBTT('get_number_variable', { variable_name: 'BTTNowPlayingInfoDuration' }),
      // number: callBTT('get_number_variable', { variable_name: 'BTTNowPlayingInfoTrackNumber' }) ,
      // artwork: callBTT('get_string_variable', { variable_name: 'BTTNowPlayingInfoArtworkData' }) ,
    }

    promises.artist.then(text => setText('artist', text))
    promises.title.then(text => setText('title', text))
    promises.album.then(text => setText('album', text))

    const bttData = {
      artist: await promises.artist,
      title: await promises.title,
      album: await promises.album,
      // duration: await promises.duration,
      // number: await promises.number,
      // artwork: await promises.artwork,
    }
    fetchCover(bttData).then(setCover)

    if (await promises.playing) setStatus('playing')
    else if (await promises.title) setStatus('paused')
    else setStatus('stoped')
  }

  SKB.tickNowPlaying = tick
  tick()

  console.log('now_playing loaded')
}

const main = () => setTimeout(() => {
  loadMe()
  loadClock()
  loadBattery()
  loadIps()
  loadHosts()
  loadNotificationHandler()
  loadNowPlaying()
  loadHASS()
}, 200)


window.SKB = SKB
window.addEventListener('load', main)
