import promptAction from '@ohos.promptAction';

export function showToast(msg: string, dur: number) {
  promptAction.showToast({
    message: msg,
    duration: dur
  })
}