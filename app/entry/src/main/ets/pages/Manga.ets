import router from '@ohos.router';
import http from '@ohos.net.http';

@Entry
@Component

struct Manga{
  @State bannerList:object[] = []
  @State tabClassification:string[] = []
  @State tabindex:number = 1
  @State recommendList:object[] = []
  @State comic_id:string = ""

  // 函数http请求(GET)
  async getHttpRequest(url:string):Promise<string>{
    let httpRequest = http.createHttp()
    try {
      const res = await httpRequest.request(url, {
        method: http.RequestMethod.GET,
        connectTimeout: 60000,
        readTimeout: 60000,
        header: {
          'Content-Type': 'application/json'
        }
      });
      let str: string = res.result as string;
      return str;
    } catch (error) {
      console.info('error');
      return "";
    }
  }

  async onPageShow(): Promise<void> {
    let bannerStr = await this.getHttpRequest("https://apis.netstart.cn/bcomic/Banner")
    let bannerObj:object = JSON.parse(bannerStr)
    for(let i =0;i< bannerObj?.["data"]?.length;i++){

      this.bannerList.push(bannerObj?.["data"][i])
    }

    let tabListStr = await this.getHttpRequest("https://apis.netstart.cn/bcomic/GetClassPageAllTabs")
    let tabListObj:object = JSON.parse(tabListStr)
    for(let i = 0; i< tabListObj?.["data"]?.["home_type"].length;i++){
      this.tabClassification.push(tabListObj?.["data"]?.["home_type"][i])
    }

    let recommendStr = await this.getHttpRequest("https://apis.netstart.cn/bcomic/HomeRecommend")
    let recommendObj:object = JSON.parse(recommendStr)
    for(let i = 0; i< recommendObj?.["data"]?.["list"].length;i++){
      this.recommendList.push(recommendObj?.["data"]?.["list"][i])
    }
  }

  async onPageHide(): Promise<void> {
    this.bannerList = []
    this.tabClassification = []
    this.recommendList = []
  }

  build() {
    Column(){
      // banner图
      Row(){
        Swiper(){
          ForEach(this.bannerList, (item:object, index:number) => {
            Column(){
              Image(this.bannerList[index]?.["img"])

              Text(this.bannerList[index]?.["title"])
                .position({
                  "bottom": 0,
                  "left": 0,
                })
                .padding({
                  left:20,
                  right:20,
                })
                .fontColor(Color.White)
                .width("60%")
                .height(40)
                .backgroundColor("#920a0a0a")
            }
            .onClick(()=> {
              console.log("点击了banner")
            })
          })
        }
        .width("100%")
        .height(180)
        .autoPlay(true)
        .interval(4000)
        .loop(true)
        .indicatorStyle({
          "right":10,
          "color": "#ccc",
          "mask": true,
          "selectedColor":"#ff5ca1"
        })


      }

      // 搜索框
      Row(){
        TextInput({placeholder:"请输入你想搜索的漫画"})
          .width("70%")
          .margin({
            right:5
          })

        Button("全站搜索")
          .backgroundColor("#ff5ca1")
          .onClick(()=> {
            console.log("全站搜索")
          })
      }
      .width("100%")
      .height(50)
      .padding({
        left:20,
        right:20,
      })
      .margin({
        top:5
      })

      // tab栏
      Scroll(){
        Row(){
          ForEach(this.tabClassification, (item:object,index:number)=>{
            Text(this.tabClassification[index]?.["name"])
              .margin({
                right:10
              })
              .fontColor(this.tabindex === index ? "#ff5ca1" : "#333")
              .onClick(()=> {
                console.log(this.tabClassification[index]?.["name"])
                this.tabindex = index
              })
          })
        }
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBarColor(Color.Transparent)
      .width("100%")
      .height(50)
      .padding({
        left:20,
        right:20,
      })

      // 漫画推荐列表
      WaterFlow(){
        ForEach(this.recommendList,(item:object,index:number)=>{
          FlowItem(){
            Column(){
              Image(this.recommendList[index]?.["vertical_cover"])
              Text(this.recommendList[index]?.["title"])
                .backgroundColor("#86000000")
                .fontColor("#fff")
                .maxLines(1)
                .textOverflow({
                  overflow:TextOverflow.Ellipsis
                })
                .position({
                  bottom:0,
                  left:0,
                })
                .width("100%")
                .padding({
                  left:10,
                  right:10,
                  top:10,
                  bottom:10,
                })
            }
            .onClick(()=>{
              console.log("点击了漫画")
              this.comic_id = this.recommendList[index]?.["comic_id"]
              console.log(this.comic_id)
              router.pushUrl({
                url: 'pages/MangaDetail',
                params: {
                  text: this.comic_id
                }
              },router.RouterMode.Standard)
            })
            .border({
              width:1,
              color:"#ccc"
            })
            .height("200vp")
            .width("150vp")
            .margin(index % 2 === 0 ? {right:10,bottom:20}:{bottom:20})
          }
        })
      }
      .columnsTemplate("1fr 1fr")
      .width("100%")
      .height(430)
      .padding({
        left:20,
        right:20,
      })
      .visibility(this.tabindex === 1 ? Visibility.Visible : Visibility.None)
    }
    .width("100%")
    .height("100%")
  }
}