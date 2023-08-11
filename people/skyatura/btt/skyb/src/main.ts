import Nanobus from 'nanobus'
import './assets/main.css'

import { createApp } from 'vue'
import App from './App.vue'

const SKBTTBus = new Nanobus()
function BTTNotification(payload: string) {
  const { note, name, ...data } = JSON.parse(payload)
  SKBTTBus.emit(note, name, data)
}
Object.assign(window, { SKBTTBus, BTTNotification })

createApp(App).mount('#app')
