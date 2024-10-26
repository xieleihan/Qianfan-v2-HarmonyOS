import MyNavigation from '../components/MyNavigation'
import PreferencesUtils from '../components/PerferenceUtils'
import http from '@ohos.net.http';

const httpRequest = http.createHttp()

@Entry
@Component

struct Weather{

  @State latitude:string = ""
  @State longitude:string = ""

  async onPageShow() {
    await PreferencesUtils.get('searchPreference', 'latitude', '', (value:string)=>{
          console.log("latitude:"+value)
          if(value == "" || value == undefined) {
            this.latitude = "22.26"
          }else{
            // 保留两位小数
            value = value.substring(0, value.indexOf(".") + 3)
            this.latitude = value
          }
        })
    await PreferencesUtils.get('searchPreference', 'longitude', '', (value:string)=>{
          console.log("longitude:"+value)
          if(value == "" || value == undefined) {
            this.longitude = "114.17"
          }else{
            // 保留两位小数
            value = value.substring(0, value.indexOf(".") + 3)
            this.longitude = value
          }
        })

    let locationstr =  this.longitude + "," + this.latitude
    console.log(locationstr)
    await httpRequest.request(
      // 请求url地址
      'http://localhost:10089/proxy/weather',
      {
        // 请求方式
        method: http.RequestMethod.GET,
        // 请求的额外数据。
        extraData: {
          "location": locationstr
        },
        // 可选，默认为60s
        connectTimeout: 60000,
        // 可选，默认为60s
        readTimeout: 60000,
        // 开发者根据自身业务需要添加header字段
        header: {
          'Content-Type': 'application/json'
        }
      })
      .then((res) => {
        let str:string = (res.result) as string;
        console.log('Result:' + str);
      }).catch(() => {
        console.info('error');
      });
  }

  build() {
    Column(){
      MyNavigation()
    }
  }
}