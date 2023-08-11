import Nanobus from 'nanobus'

export interface UseBTT {
  shell: (script: string, parameters?: string, launchPath?: string) => Promise<string>
  blade: (args: string) => Promise<string>
  say: (text: string) => Promise<void>
  events: Nanobus<{ [note: string]: (name: string, data: Record<string, any>) => void }>
  callBTT: {
    (operation: 'add_new_trigger', payload: { trigger_name: string, json: string }): Promise<void>
    (operation: 'delete_trigger', payload: { trigger_name: string }): Promise<void>
    (operation: 'execute_assigned_actions_for_trigger', payload: { trigger_name: string }): Promise<void>
    (operation: 'is_app_running', payload: { app_name: string }): Promise<boolean>
    (operation: 'is_true_tone_enabled', payload: { app_name: string }): Promise<boolean>
    (operation: 'get_active_touch_bar_group', payload: { app_name: string }): Promise<string>
    (operation: 'get_dock_badge_for', payload: { app_name: string }): Promise<string>
    (operation: 'get_location', payload: { app_name: string }): Promise<{ latitude: number, longitude: number }>
    (operation: 'get_number_variable', payload: { variable_name: string }): Promise<number>
    (operation: 'set_number_variable', payload: { variable_name: string, to: number }): Promise<void>
    (operation: 'set_persistent_number_variable', payload: { variable_name: string, to: number }): Promise<void>
    (operation: 'get_string_variable', payload: { variable_name: string }): Promise<string>
    (operation: 'set_string_variable', payload: { variable_name: string, to: string }): Promise<void>
    (operation: 'set_persistent_string_variable', payload: { variable_name: string, to: string }): Promise<void>
    (operation: 'refresh_widget', payload: { uuid: string }): Promise<void>
    (operation: 'resize_webview', payload: { app_name: string, width: number, height: number }): Promise<void>
    (operation: 'trigger_action', payload: { action_uuid: string }): Promise<void>
    (operation: 'trigger_named', payload: { trigger_name: string }): Promise<void>
    (operation: 'trigger_named_async_without_response', payload: { trigger_name: string }): Promise<void>
    (operation: 'update_touch_bar_widget', payload: { uuid: string, json: string }): Promise<void>
    (operation: 'update_trigger', payload: { trigger_name: string, json: string }): Promise<void>
  }
  getString: (variableName: string) => Promise<string>
  getNumber: (variableName: string) => Promise<number>
  setString: (variableName: string, value: string) => Promise<void>
  setNumber: (variableName: string, value: number) => Promise<void>
  setPersistentString: (variableName: string, value: string) => Promise<void>
  setPersistentNumber: (variableName: string, value: number) => Promise<void>
  addNewTrigger: (triggerName: string, json: string) => Promise<void>
  deleteTrigger: (triggerName: string) => Promise<void>
  executeAssignedActionsForTrigger: (triggerName: string) => Promise<void>
  isAppRunning: (appName: string) => Promise<boolean>
  isTrueToneEnabled: (appName: string) => Promise<boolean>
  getActiveTouchBarGroup: (appName: string) => Promise<string>
  getDockBadgeFor: (appName: string) => Promise<string>
  getLocation: (appName: string) => Promise<{ latitude: number, longitude: number }>
  refreshWidget: (uuid: string) => Promise<void>
  resizeWebview: (appName: string, width: number, height: number) => Promise<void>
  triggerAction: (actionUuid: string) => Promise<void>
  triggerNamed: (triggerName: string) => Promise<void>
  triggerNamedAsyncWithoutResponse: (triggerName: string) => Promise<void>
  updateTouchBarWidget: (uuid: string, json: string) => Promise<void>
  updateTrigger: (triggerName: string, json: string) => Promise<void>
}

export const useBTT = () => {
  //@ts-expect-error
  const shell = (shellScript: string, parameters = '-c', launchPath = '/bin/zsh') => runShellScript({
    script: shellScript, // mandatory
    launchPath, //optional - default is /bin/bash
    parameters, // optional - default is -c
    environmentVariables: '', //optional e.g. VAR1=/test/;VAR2=/test2/;
  })
  //@ts-expect-error
  const callBTT = window.callBTT as UseBTT['callBTT']

  return {
    callBTT,
    shell,
    blade: (args: string) => shell(`sbar-blades ${args}`),
    say: async (msg: string) => { await shell(`say ${msg}`) },
    getString: (variableName: string) => callBTT('get_string_variable', { variable_name: variableName }),
    getNumber: (variableName: string) => callBTT('get_number_variable', { variable_name: variableName }),
    setString: (variableName: string, value: string) => { callBTT('set_string_variable', { variable_name: variableName, to: value }) },
    setNumber: (variableName: string, value: number) => { callBTT('set_number_variable', { variable_name: variableName, to: value }) },
    setPersistentString: (variableName: string, value: string) => { callBTT('set_persistent_string_variable', { variable_name: variableName, to: value }) },
    setPersistentNumber: (variableName: string, value: number) => { callBTT('set_persistent_number_variable', { variable_name: variableName, to: value }) },
    addNewTrigger: (triggerName: string, json: string) => { callBTT('add_new_trigger', { trigger_name: triggerName, json }) },
    deleteTrigger: (triggerName: string) => { callBTT('delete_trigger', { trigger_name: triggerName }) },
    executeAssignedActionsForTrigger: (triggerName: string) => { callBTT('execute_assigned_actions_for_trigger', { trigger_name: triggerName }) },
    isAppRunning: (appName: string) => { callBTT('is_app_running', { app_name: appName }) },
    isTrueToneEnabled: (appName: string) => { callBTT('is_true_tone_enabled', { app_name: appName }) },
    getActiveTouchBarGroup: (appName: string) => { callBTT('get_active_touch_bar_group', { app_name: appName }) },
    getDockBadgeFor: (appName: string) => { callBTT('get_dock_badge_for', { app_name: appName }) },
    getLocation: (appName: string) => { callBTT('get_location', { app_name: appName }) },
    refreshWidget: (uuid: string) => { callBTT('refresh_widget', { uuid }) },
    resizeWebview: (appName: string, width: number, height: number) => { callBTT('resize_webview', { app_name: appName, width, height }) },
    triggerAction: (actionUuid: string) => { callBTT('trigger_action', { action_uuid: actionUuid }) },
    triggerNamed: (triggerName: string) => { callBTT('trigger_named', { trigger_name: triggerName }) },
    triggerNamedAsyncWithoutResponse: (triggerName: string) => { callBTT('trigger_named_async_without_response', { trigger_name: triggerName }) },
    updateTouchBarWidget: (uuid: string, json: string) => { callBTT('update_touch_bar_widget', { uuid, json }) },
    updateTrigger: (triggerName: string, json: string) => { callBTT('update_trigger', { trigger_name: triggerName, json }) },
    //@ts-expect-error
    events: window.SKBTTBus,
  } as UseBTT
}

setTimeout(() => {
  window.bttt = useBTT()
}, 1000)
