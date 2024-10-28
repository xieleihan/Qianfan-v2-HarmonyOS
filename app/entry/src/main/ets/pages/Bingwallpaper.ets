import MyNavigition from '../components/MyNavigation'
import router from '@ohos.router';

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

// 必应壁纸api: https://uapi.woobx.cn/app/bing-wallpaper?page=1&pageSize=20

struct Bingwallpaper{
  build(){
    Column(){
      MyNavigition({msgtitle: params.text})
      Row(){
        Image($r('app.media.listexcel'))
          .width(15)
          .height(15)
          .margin({
            right: 10
          })
          .onClick(()=>{
            console.log("点击了列表")
          })
        Image($r('app.media.vertical_list'))
          .width(15)
          .height(15)
          .onClick(()=>{
            console.log("点击了瀑布流布局")
          })
      }
      .width("100%")
      .justifyContent(FlexAlign.End)
      .padding({
        left: 20,
        right: 20,
      })
      .position({
        top:100
      })
    }
    .width("100%")
    .height("100%")
  }
}