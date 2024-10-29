import http from '@ohos.net.http';

@Entry
@Component

struct CloudMusic{
  @State bannerList:object[] = []
  @State recommendList:object[] = []
  @State recommendSingList:object[] = []
  @State recommendSingList1:object[] = []
  @State recommendSingList2:object[] = []

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
    // banner图
    let bannerStr = await this.getHttpRequest("https://apis.netstart.cn/music/banner?type=1")
    let bannerObj:object = JSON.parse(bannerStr)
    for(let i =0;i< bannerObj?.["banners"]?.length;i++){
      this.bannerList.push(bannerObj?.["banners"][i])
    }

    // 推荐歌单
    let recommendStr = await this.getHttpRequest("https://apis.netstart.cn/music/personalized?limit=10")
    let recommendObj:object = JSON.parse(recommendStr)
    for(let i = 0; i< recommendObj?.["result"]?.length;i++){
      this.recommendList.push(recommendObj?.["result"][i])
    }

    // 最新歌曲
    let recommendSingStr = await this.getHttpRequest("https://apis.netstart.cn/music/personalized/newsong?limit=3")
    let recommendSingObj:object = JSON.parse(recommendSingStr)
    for(let i = 0; i< recommendSingObj?.["result"]?.length;i++){
      this.recommendSingList.push(recommendSingObj?.["result"][i])
    }
    let recommendSingStr1 = await this.getHttpRequest("https://apis.netstart.cn/music/personalized/newsong?limit=6")
    let recommendSingObj1:object = JSON.parse(recommendSingStr1)
    for(let i = 3; i< recommendSingObj1?.["result"]?.length;i++){
      this.recommendSingList1.push(recommendSingObj1?.["result"][i])
    }
    let recommendSingStr2 = await this.getHttpRequest("https://apis.netstart.cn/music/personalized/newsong?limit=9")
    let recommendSingObj2:object = JSON.parse(recommendSingStr2)
    for(let i = 6; i< recommendSingObj2?.["result"]?.length;i++){
      this.recommendSingList2.push(recommendSingObj2?.["result"][i])
    }
  }

  async onPageHide(): Promise<void> {
    this.bannerList = []
    this.recommendList = []
    this.recommendSingList = []
    this.recommendSingList1 = []
    this.recommendSingList2 = []
  }

  build() {
    Column(){
      Row(){
        TextInput({"placeholder":"请输入查找的音乐"})
          .width("70%")
        Button("全站搜索")
          .backgroundColor("#fbc012")
          .fontColor("#fff")
      }
      .width("100%")
      .padding({
        left:20,
        right:20
      })

      Row(){
        Swiper() {
          ForEach(this.bannerList, (item: object, index: number) => {
            Column() {
              Image(this.bannerList[index]?.["pic"])
                .width("100%")
            }
            .onClick(() => {
              console.log("点击了banner")
            })
          })
        }
        .width("100%")
        .autoPlay(true)
        .interval(4000)
        .loop(true)
        .indicatorStyle({
          "color": "#ccc",
          "mask": true,
          "selectedColor":"#fbc21d"
        })
      }
      .width("100%")
      .height("180vp")
      .margin({
        top:2
      })

      // 歌单
      Row(){
        Text("推荐歌单")
          .fontWeight("bold")
      }.width("100%")
      .padding({
        left:20,
        right:20
      })
      .margin({
        bottom:10
      })
      Column(){
        Scroll(){
          Row(){
            ForEach(this.recommendList,(item:object,index:number)=>{
              Row(){
                Image(this.recommendList[index]?.["picUrl"])
                  .width(130)
                  .height(130)
                  .borderRadius(5)
                Text(this.recommendList[index]?.["name"])
                  .position({
                    bottom:0,
                    left:0
                  })
                  .width("130vp")
                  .backgroundColor("#b0000000")
                  .maxLines(1)
                  .textOverflow({
                    overflow: TextOverflow.Ellipsis
                  })
                  .fontColor("#fff")
                  .padding({
                    left:5,
                    right:5,
                    bottom:5,
                    top:5,
                  })
              }
              .margin({
                right:10
              })
              .onClick(()=>{
                console.log(this.recommendList[index]?.["id"]);
              })
            })
          }
        }.width("100%")
        .scrollable(ScrollDirection.Horizontal)
        .margin({
          bottom:10
        })

      }.width("100%")
      .padding({
        left:20,
        right:20
      })

      // 最新歌曲
      Row(){
        Text("最新歌曲")
          .fontWeight("bold")
      }.width("100%")
      .padding({
        left:20,
        right:20
      })
      .margin({
        bottom:10
      })
      Column(){
        Scroll(){
          Row(){
            Column(){
              ForEach(this.recommendSingList,(item:object,index:number)=>{
                Row(){
                  Image(this.recommendSingList[index]?.["picUrl"])
                    .height("80vp")
                    .margin({
                      right:10
                    })
                  Column(){
                    Text(this.recommendSingList[index]?.["name"])
                      .fontSize(16)
                      .fontWeight("bold")
                      .margin({
                        bottom:10
                      })
                    Row(){
                      ForEach(this.recommendSingList[index]?.["song"]?.["artists"],(item:object,index:number)=>{
                        Text(item?.["name"])
                          .fontColor("#ccc")
                          .fontSize(14)
                          .margin({
                            right:10
                          })
                      })
                    }
                  }
                  .alignItems(HorizontalAlign.Start)
                }
                .width("100%")
                .border({
                  width:1,
                  color:"#ccc"
                })
                .borderRadius(5)
                .margin({
                  bottom:10
                })
              })
            }.width("80%")
            .margin({
              right:10
            })

            Column(){
              ForEach(this.recommendSingList1,(item:object,index:number)=>{
                Row(){
                  Image(this.recommendSingList1[index]?.["picUrl"])
                    .height("80vp")
                    .margin({
                      right:10
                    })
                  Column(){
                    Text(this.recommendSingList1[index]?.["name"])
                      .fontSize(16)
                      .fontWeight("bold")
                      .margin({
                        bottom:10
                      })
                    Row(){
                      ForEach(this.recommendSingList1[index]?.["song"]?.["artists"],(item:object,index:number)=>{
                        Text(item?.["name"])
                          .fontColor("#ccc")
                          .fontSize(14)
                          .margin({
                            right:10
                          })
                      })
                    }
                  }
                  .alignItems(HorizontalAlign.Start)
                }
                .width("100%")
                .border({
                  width:1,
                  color:"#ccc"
                })
                .borderRadius(5)
                .margin({
                  bottom:10
                })
              })
            }.width("80%")
            .margin({
              right:10
            })

            Column(){
              ForEach(this.recommendSingList2,(item:object,index:number)=>{
                Row(){
                  Image(this.recommendSingList2[index]?.["picUrl"])
                    .height("80vp")
                    .margin({
                      right:10
                    })
                  Column(){
                    Text(this.recommendSingList2[index]?.["name"])
                      .fontSize(16)
                      .fontWeight("bold")
                      .margin({
                        bottom:10
                      })
                    Row(){
                      ForEach(this.recommendSingList2[index]?.["song"]?.["artists"],(item:object,index:number)=>{
                        Text(item?.["name"])
                          .fontColor("#ccc")
                          .fontSize(14)
                          .margin({
                            right:10
                          })
                      })
                    }
                  }
                  .alignItems(HorizontalAlign.Start)
                }
                .width("100%")
                .border({
                  width:1,
                  color:"#ccc"
                })
                .borderRadius(5)
                .margin({
                  bottom:10
                })
              })
            }.width("80%")
            .margin({
              right:10
            })
          }
          .justifyContent(FlexAlign.Start)
        }.width("100%")
        .scrollable(ScrollDirection.Horizontal)
        .margin({
          bottom:10
        })

      }.width("100%")
      .padding({
        left:20,
        right:20
      })
    }
    .width("100%")
    .height("100%")
  }
}