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

struct MangaDetail{
  @State mangaListDetail:object[] = []
  @State mangaTitle:string = ""
  @State horizontal_cover:string = ""
  @State square_cover:string = ""
  @State vertical_cover:string = ""
  @State author_name:string = ""
  @State styles:string = ""
  @State evaluate:string = ""
  @State sumnumber:string = ""
  @State is_finish:string = ""
  @State last_short_title_msg:string = ""

  @State isOpenLooknum:boolean = false

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
    console.log(`https://apis.netstart.cn/bcomic/ComicDetail?comicId=${params.text}`)
    let mangaListStr = await this.getHttpRequest(`https://apis.netstart.cn/bcomic/ComicDetail?comicId=${params.text}`)
    console.log(mangaListStr);

    let mangaListObj:object = JSON.parse(mangaListStr)
    this.mangaTitle = mangaListObj?.["data"]?.["title"]
    this.horizontal_cover = mangaListObj?.["data"]?.["horizontal_cover"]
    this.square_cover = mangaListObj?.["data"]?.["square_cover"]
    this.vertical_cover = mangaListObj?.["data"]?.["vertical_cover"]
    this.author_name = mangaListObj?.["data"]?.["author_name"][0]
    this.styles = mangaListObj?.["data"]?.["styles"][0]
    this.evaluate = mangaListObj?.["data"]?.["evaluate"]
    this.sumnumber = mangaListObj?.["data"]?.["total"]
    for(let i = mangaListObj?.["data"]?.["ep_list"].length-1;i>=0;i--){
      this.mangaListDetail.push(mangaListObj?.["data"]?.["ep_list"][i])
    }
    this.is_finish = mangaListObj?.["data"]?.["is_finish"]
    console.log(this.is_finish);
    this.last_short_title_msg = mangaListObj?.["data"]?.["last_short_title_msg"]
  }

  async onPageHide(): Promise<void> {
    this.mangaListDetail = []
    this.mangaTitle = ""
    this.horizontal_cover = ""
    this.square_cover = ""
    this.vertical_cover = ""
    this.author_name = ""
    this.styles = ""
    this.evaluate = ""
    this.sumnumber = ""
    this.is_finish = ""
    this.last_short_title_msg = ""
  }

  build() {
    Column(){
      Row(){
        Image(this.horizontal_cover)
          .width("100%")
          .height(180)
        // Image(this.square_cover)
        //   .width("100%")
        //   .height(180)

        Image($r('app.media.left'))
          .width(28)
          .height(28)
          .position({
            "top":10,
            "left":10
          })
          .onClick(()=>{
            router.back()
          })

        Row(){
          Text("追漫"){
          }
          .fontColor(Color.White)
          Image($r('app.media.addStar'))
            .width(20)
            .height(20)
        }
        .width("70vp")
        .height("30vp")
        .position({
          "bottom":"-10vp",
          "right": 20
        })
        .backgroundColor(Color.Orange)
        .padding({
          top: 5,
          bottom: 5,
          left: 10,
          right: 10
        })
      }
      .width("100%")

      Row(){
        Text(this.mangaTitle)
          .fontWeight("bold")
          .fontSize("20vp")
      }
      .width("100%")
      .padding({
        left:20,
        right:20,
        top:10,
        bottom:10
      })

      Column(){
        Row(){
          Text(this.author_name)
            .margin({
              right:10
            })
          Text(this.styles)
            .fontColor("#ccc")
            .border({
              width:1,
              color:"#ccc"
            })
            .padding({
              left:2,
              right:2,
              top:1,
              bottom:1
            })
        }
        .width("100%")
        .margin({
          bottom:10
        })
        Row(){
          Text(this.is_finish == "0" ? "连载中" : "已完结")
          Text("▪")
          Text(this.last_short_title_msg)
        }
        .width("100%")
        .margin({
          bottom:10
        })
        Row(){
          Text(this.evaluate)
        }
        .width("100%")
        .margin({
          bottom:10
        })
      }
      .width("100%")
      .padding({
        left:20,
        right:20
      })

      // 下方目录区域
      Row(){
        Column(){
          Image($r('app.media.looknum'))
            .width(20)
            .height(20)
          Text("目录")

        }
        .onClick(()=>{
          this.isOpenLooknum = !this.isOpenLooknum
        })
        .width(50)
        .height(30)

        Scroll(){
          Row(){
            ForEach(this.mangaListDetail,(item:object,index:number)=>{
              Text(index+"")
                .width(40)
                .height(30)
                .backgroundColor("#ff5ca1")
                .fontColor(Color.White)
                .margin({
                  right:10
                })
                .textAlign(TextAlign.Center)
                .borderRadius(5)
            })
          }
        }
        .width("55%")
        .height("100%")
        .scrollable(ScrollDirection.Horizontal)

        Button("开始阅读")
          .backgroundColor("#ff5ca1")
          .fontColor(Color.White)
          .height(50)
          .width(100)
      }
      .width("100%")
      .height("50vp")
      .position({
        bottom:0
      })

      Column(){
        Row(){
          Image($r('app.media.left'))
            .width(20)
            .height(20)
            .onClick(()=>{
              router.back()
            })
            .margin({
              right:10
            })
          Text("目录")
            .fontWeight("bold")
        }
        .width("100%")
        .margin({
          bottom:10
        })

        Scroll(){
          Column(){
            ForEach(this.mangaListDetail,(item:object,index:number)=>{
              Column(){
                Row(){
                  Image(this.mangaListDetail[index]?.["cover"])
                    .width(80)
                    .height(100)
                    .margin({
                      right:10
                    })

                  Column(){
                    Text(this.mangaListDetail[index]?.["title"])
                      .fontSize(18)
                      .fontWeight("bold")
                      .margin({
                        bottom:10
                      })
                    Text(this.mangaListDetail[index]?.["pub_time"])
                      .fontSize(14)
                      .fontColor("#ccc")
                  }
                }
                .border({
                  width:1,
                  color:"#ccc"
                })
                .borderRadius(20)
                .padding({
                  left:20,
                  right:20,
                  top:10,
                  bottom:10
                })
                .width("100%")
                .margin({
                  bottom:10
                })
              }
            })
          }
        }
      }.padding({
        left:20,
        right:20,
        top:20,
        bottom:20
      })
      .width("100%")
      .height("90%")
      .position({
        bottom:0
      })
      .visibility(this.isOpenLooknum ? Visibility.Visible : Visibility.None)
      .backgroundColor(Color.White)
    }
    .width("100%")
    .height("100%")
  }
}