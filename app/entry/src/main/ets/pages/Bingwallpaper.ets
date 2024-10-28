import MyNavigition from '../components/MyNavigation'
import router from '@ohos.router';
import http from '@ohos.net.http';

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
  @State isToggle:boolean = false
  @State wallpaperList:object[] = []

  @State startpage:number = 1
  @State pagesize:number = 20

  getImageUrl(url:string):string{
    return "https://cn.bing.com"+url
  }

  getMoreImage(pages:number){
    let httpRequest = http.createHttp()
    let url = `https://uapi.woobx.cn/app/bing-wallpaper?page=${pages}&pageSize=${this.pagesize}`
    httpRequest.request(
      url,
      {
        method: http.RequestMethod.GET,
        connectTimeout: 60000,
        readTimeout: 60000,
        header: {
          'Content-Type': 'application/json'
        }
      })
      .then((res) => {
        let str:string = (res.result) as string;
        console.log('Result:' + str);
        let obj:object = JSON.parse(str)
        for(let i =0;i< obj?.["data"]?.["list"].length;i++){
          this.wallpaperList.push(obj?.["data"]?.["list"][i])
        }
      }).catch(() => {
      console.info('error');
    })
  }

  onPageShow(): void {
    // const url = `https://uapi.woobx.cn/app/bing-wallpaper?page=1&pageSize=20`;
    let httpRequest = http.createHttp()
    httpRequest.request(
      "https://uapi.woobx.cn/app/bing-wallpaper",
      {
        method: http.RequestMethod.GET,
        connectTimeout: 60000,
        readTimeout: 60000,
        header: {
          'Content-Type': 'application/json'
        },
        extraData: {
          "page": this.startpage,
          "pageSize": this.pagesize
        }
      })
      .then((res) => {
        let str:string = (res.result) as string;
        console.log('Result:' + str);
        let obj:object = JSON.parse(str)
        for(let i =0;i< obj?.["data"]?.["list"].length;i++){
          this.wallpaperList.push(obj?.["data"]?.["list"][i])
        }
      }).catch(() => {
      console.info('error');
    })
  }

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
            this.isToggle = false
          })
        Image($r('app.media.vertical_list'))
          .width(15)
          .height(15)
          .onClick(()=>{
            console.log("点击了瀑布流布局")
            this.isToggle = true
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

      List(){
        ForEach(this.wallpaperList,(item:object,index:number)=>{
          ListItem(){
            Column(){
              Image(this.getImageUrl(item?.["url"]))
                .width("100%")
                .height(200)
              Text(this.wallpaperList[index]?.["title"])
                .width("100%")
                .fontSize(16)
                .fontWeight("bold")
                .fontColor("#f2f2f2")
                .position({
                  bottom:"27%",
                  left:10
                })
                .translate({
                  y:"-50%"
                })
              Text(this.wallpaperList[index]?.["copyright"])
                .width("100%")
                .fontSize(12)
                .fontColor("#f2f2f2")
                .position({
                  bottom:30,
                  left:10
                })
              Image($r('app.media.download'))
                .width(30)
                .height(30)
                .position({
                  top:10,
                  right:10
                })
                .onClick(()=>{
                  console.log("点击了下载")
                })
            }
            .width("100%")
            .height(200)
          }
          .width("100%")
          .height(200)
          .margin({
            bottom: 10
          })
        })
      }
      .width("100%")
      .height("70%")
      .padding({
        left: 20,
        right: 20,
      })
      .position({
        top: 150
      })
      .visibility(this.isToggle === false ? Visibility.Visible : Visibility.None)

      WaterFlow(){

      }
      .visibility(this.isToggle === true ? Visibility.Visible : Visibility.None)

      Button("加载更多")
        .backgroundColor("#289a48")
        .fontColor(Color.White)
        .onClick(()=>{
          console.log("点击了加载更多")
          this.startpage = this.startpage + 1
          console.log(this.startpage+"")
          this.getMoreImage(this.startpage)
        })
        .position({
          bottom: 10,
          left: "50%"
        })
        .translate({
          x: "-50%"
        })
    }
    .width("100%")
    .height("100%")
  }
}