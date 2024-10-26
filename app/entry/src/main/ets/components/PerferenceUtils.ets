import preferences from '@ohos.data.preferences';
class PreferencesUtils {
  // 新增数据put
  async set(name: string, key: string, value: preferences.ValueType) {
    try {
      let context: Context = getContext(this)
      const pref = await preferences.getPreferences(context, name)
      // 写入数据
      await pref.put(key, value)
      // 刷盘
      await pref.flush()
      // console.log('测试', `保存preferences[${name}]成功`)
    }

    catch (e) {
      console.log('测试', `保存preferences[${name}]失败`, JSON.stringify(e));
    }
  }

  // 读取数据get
  async get(name: string, key: string, defaultValue: preferences.ValueType, callback:Function) {
    // 先判断是否存在该名称的键值对
    try {
      let context: Context = getContext(this)
      const pref = await preferences.getPreferences(context, name)
      const value = await pref.get(key, defaultValue)
      callback && callback (value)
      // console.log('测试', `读取preferences[${name}.${key}=${value}]成功`)
      // return value;
    }
    catch (e) {
      console.log('测试', `读取preferences[${name}]失败`, JSON.stringify(e));
    }
  }

  // 删除数据del
  async delete(name: string, key: string) {
    try {
      let context: Context = getContext(this)
      const pref = await preferences.getPreferences(context, name)
      await pref.delete(key)
      // console.log('测试', `删除preferences[${name}]成功`)
    }
    catch (e) {
      console.log('测试', `删除preferences[${name}]失败`, JSON.stringify(e));
    }
  }
}
const preferenceUtils = new PreferencesUtils()
export default preferenceUtils

// 在页面中使用就是下面这样
// async onPageShow() {
//   // 设置本地储存
//   await  PreferencesUtils.set('searchPreference', 'token', 'qewr123')
//
//   // 删除本地存储
//   await PreferencesUtils.delete("searchPreference","token")
//
//   // 获取本地存储
//   PreferencesUtils.get('searchPreference', 'token', '', (value:string)=>{
//     console.log("token:"+value)
//   })
// }