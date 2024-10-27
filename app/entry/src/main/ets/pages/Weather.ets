import MyNavigation from '../components/MyNavigation'
import PreferencesUtils from '../components/PerferenceUtils'
import http from '@ohos.net.http';
import router from '@ohos.router';

const httpRequest = http.createHttp()

// 定义一个路由传参类
class routerParam{
  text: string

  constructor(value:string) {
    this.text = value
  }
}

let params = router.getParams() as routerParam

@Entry
@Component

// https://fastly.jsdelivr.net/gh/southaki/contentDeliveryNetwork@0.0.15/vueProjectPoint(test)/QWeather_Icons_1.6.0/icons/
struct Weather{

  @State latitude:string = ""
  @State longitude:string = ""

  // 定义一个天气24小时的数据
  @State updatetime:string = "" // 更新时间
  @State fxlink:string = "" // 天气预报链接
  @State hourly:object[] = [] // 24小时天气预报

  formatUpdateTime(updatetime: string): string {
    // 提取月份、日期、时间部分
    const month = updatetime.substring(5, 7); // 月
    const day = updatetime.substring(8, 10);  // 日
    const time = updatetime.substring(11, 16); // 时间

    // 拼接格式化字符串，例如 "10月27日 00:13"
    return `${parseInt(month)}月${parseInt(day)}日 ${time}`;
  }

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
        let obj:object = JSON.parse(str)
        console.log(obj?.['data']?.["hourly"])
        this.hourly = obj?.['data']?.["hourly"]
        this.updatetime = obj?.['data']?.["updateTime"]
        this.fxlink = obj?.['data']?.["fxLink"]
      }).catch(() => {
        console.info('error');
      });
  }

  build() {
    Column(){
      MyNavigation({msgtitle: params.text})

      // 如何渲染这一方面
      // 现在的天气
      Column(){
        Row(){
          Text('香港')
            .fontWeight('bold')
            .fontSize('22vp')
          // 2024-10-27T00:13+08:00 => 10月27日 00:13
          Text('更新时间:'+ this.formatUpdateTime(this.updatetime))
            .fontSize('14vp')
            .opacity(0.4)
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .margin({
          bottom: 20,
        })
        .width('100%')
        .padding({
          left: 20,
          right: 20,
        })
        Row(){
          Text(this.hourly[0]?.['temp'])
            .fontSize('50vp')
            .fontWeight('bold')
        }
        .margin({
          bottom: 20,
        })
        .width('100%')
        .justifyContent(FlexAlign.Center)
        Row(){
          Text(this.hourly[0]?.['text'])// 天气情况描述
            .margin({
              right: 10,
            })
          Text("降水概率"+this.hourly[0]?.['pop'])// 降水概率
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
      }
      .position({
        top: 120,
        left: 0,
      })

      // 24小时天气预报
      List(){
        ForEach(this.hourly,(item:object,index:number)=>{
          ListItem(){
            Column(){
              Row(){
                Text(this.formatUpdateTime(item?.['fxTime']))

                  .margin({
                    right: 10,
                  })
                Row(){
                  Image('https://fastly.jsdelivr.net/gh/southaki/contentDeliveryNetwork@0.0.15/vueProjectPoint(test)/QWeather_Icons_1.6.0/icons/'+item?.['icon']+'.svg')
                    .width(15)
                    .height(15)
                  Text(this.hourly[index]?.['temp'])
                    .margin({
                      left:10
                    })
                }

              }
              .justifyContent(FlexAlign.SpaceBetween)
              .width("100%")
              .padding({
                left: "20vp",
                right: "20vp",
              })
            }
          }
          .border({
            width: 1,
            color: '#ccc'
          })
          .margin({
            bottom: 10,
          })
          .width('100%')
          .height('40vp')
          .borderRadius(10)
        })
      }
      .position({
        top: 270,
        left: '50%'
      })
      .width("90%")
      .translate({
        x: '-50%',
      })
      .height('400vp')
    }
  }
}