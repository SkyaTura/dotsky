const shell = (shellScript) => runShellScript({
  script: shellScript, // mandatory
  launchPath: '/bin/zsh', //optional - default is /bin/bash
  parameters: '-c', // optional - default is -c
  environmentVariables: '', //optional e.g. VAR1=/test/;VAR2=/test2/;
})

const blade = (args) => shell(`sbar-blades ${args}`)
const say = (msg) => shell(`say ${msg}`)

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

const main = () => setTimeout(() => {
  loadMe()
  loadClock()
  loadBattery()
  loadIps()
}, 200)


window.addEventListener('load', main)
