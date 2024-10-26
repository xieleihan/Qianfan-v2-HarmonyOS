import http from '@ohos.net.http';
import PreferencesUtils from '../components/PerferenceUtils'

const httpRequest = http.createHttp()

@Entry
@Component

struct Networkinfo{
  @State ip:string = ""
  @State continent:string = ""
  @State country:string = ""
  @State province:string = ""
  @State city:string = ""
  @State ISP:string = ""
  @State areacode:string = ""
  @State countrycode:string = ""
  @State timezone:string = ""
  @State latitude:string = ""
  @State longitude:string = ""

  async onPageShow() {
    await httpRequest.request(
      // 请求url地址
      'http://localhost:10089/proxy/nginx',
      {
        // 请求方式
        method: http.RequestMethod.GET,
        // 请求的额外数据。
        extraData: {

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
        let obj:object = JSON.parse(str)
        console.log(obj?.["data"]?.["result"])
        let resultobj:object = obj?.["data"]?.["result"]
        this.ip = resultobj?.["ip"]
        this.continent = resultobj?.["continent"]
        this.country = resultobj?.["country"]
        this.province = resultobj?.["province"]
        this.city = resultobj?.["city"]
        this.ISP = resultobj?.["isp"]
        this.areacode = resultobj?.["areacode"]
        this.countrycode = resultobj?.["countrycode"]
        this.timezone = resultobj?.["timezone"]
        this.latitude = resultobj?.["latitude"]
        this.longitude = resultobj?.["longitude"]
      }).catch(() => {
      console.info('error');
    });

    await PreferencesUtils.set('networkinfo', 'latitude', this.latitude)
    await PreferencesUtils.set('networkinfo', 'longitude', this.longitude)
  }

  build() {
    Row(){
      Row(){
        Image("https://fastly.picsum.photos/id/311/3840/2160.jpg?hmac=12wax10Z684M021zmr06u0vvl1CKh3jiB4duPdmtEdo")
          .width("100%")
          .height("300vp")
      }
      .width("100%")
      .height("300vp")

      Column(){
        Text("网络信息")
        .fontSize(16)
        Column(){
          Row(){
            Text("IP地址:")
            Text(this.ip)
          }
          .height("50vp")
          .width("100%")
          .padding({
            left:"20vp",
            right:"20vp"
          })
          .border({
            color:"#ccc",
            width:1
          })
          Row(){
            Text("所在洲:")
            Text(this.continent)
          }
          .height("50vp")
          .width("100%")
          .padding({
            left:"20vp",
            right:"20vp"
          })
          .border({
            color:"#ccc",
            width:1
          })
          Row(){
            Text("所在国家:")
            Text(this.country)
          }
          .height("50vp")
          .width("100%")
          .padding({
            left:"20vp",
            right:"20vp"
          })
          .border({
            color:"#ccc",
            width:1
          })
          Row(){
            Text("所在省份:")
            Text(this.province)
          }
          .height("50vp")
          .width("100%")
          .padding({
            left:"20vp",
            right:"20vp"
          })
          .border({
            color:"#ccc",
            width:1
          })
          Row(){
            Text("所在城市:")
            Text(this.city)
          }
          .height("50vp")
          .width("100%")
          .padding({
            left:"20vp",
            right:"20vp"
          })
          .border({
            color:"#ccc",
            width:1
          })
          Row(){
            Text("运营商:")
            Text(this.ISP)
          }
          .height("50vp")
          .width("100%")
          .padding({
            left:"20vp",
            right:"20vp"
          })
          .border({
            color:"#ccc",
            width:1
          })
          Row(){
            Text("区号:")
            Text(this.areacode)
          }
          .height("50vp")
          .width("100%")
          .padding({
            left:"20vp",
            right:"20vp"
          })
          .border({
            color:"#ccc",
            width:1
          })
          Row(){
            Text("国家代码:")
            Text(this.countrycode)
          }
          .height("50vp")
          .width("100%")
          .padding({
            left:"20vp",
            right:"20vp"
          })
          .border({
            color:"#ccc",
            width:1
          })
          Row(){
            Text("时区:")
            Text(this.timezone)
          }
          .height("50vp")
          .width("100%")
          .padding({
            left:"20vp",
            right:"20vp"
          })
          .border({
            color:"#ccc",
            width:1
          })
          Row(){
            Text("纬度:")
            Text(this.latitude)
          }
          .height("50vp")
          .width("100%")
          .padding({
            left:"20vp",
            right:"20vp"
          })
          .border({
            color:"#ccc",
            width:1
          })
          Row(){
            Text("经度:")
            Text(this.longitude)
          }
          .height("50vp")
          .width("100%")
          .padding({
            left:"20vp",
            right:"20vp"
          })
          .border({
            color:"#ccc",
            width:1
          })
        }
      }
      .position({
        top:"300vp"
      })

    }
    .width("100%")
    .height("100%")
    .alignItems(VerticalAlign.Top)
  }
}