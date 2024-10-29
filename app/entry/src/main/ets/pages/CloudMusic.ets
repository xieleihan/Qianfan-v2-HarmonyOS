import http from '@ohos.net.http';

@Entry
@Component

struct CloudMusic{
  @State isOpenLookSearch:boolean = false
  @State isSearchSum:boolean = false
  @State inputStr:string = ""

  @State bannerList:object[] = []
  @State recommendList:object[] = []
  @State recommendSingList:object[] = []
  @State recommendSingList1:object[] = []
  @State recommendSingList2:object[] = []
  @State recommendRadioList:object[] = []
  @State searchList:object[] = []

  // 函数http请求(GET)
  async getHttpRequest(url:string):Promise<string>{
    let httpRequest = http.createHttp()
    console.log(url)
    try {
      const res = await httpRequest.request(url, {
        method: http.RequestMethod.GET,
        connectTimeout: 600000,
        readTimeout: 600000,
        header: {
          'Content-Type': 'application/json'
        }
      });
      let str: string = res.result as string;
      console.log(str)
      return str;
    } catch (error) {
      console.info('error');
      return "";
    }
  }

  async getSearchList(keyword:string):Promise<void>{
    const encodedKeyword = encodeURIComponent(keyword);
    console.log("调用了"+`https://apis.netstart.cn/music/search?keywords=${keyword}`)
    let url = `https://apis.netstart.cn/music/search?keywords=${encodedKeyword}`
    let searchStr = await this.getHttpRequest(url)
    console.log(searchStr)
    let searchObj:object = JSON.parse(searchStr)
    for(let i = 0; i< searchObj?.["result"]?.["songs"].length;i++){
      this.searchList.push(searchObj?.["result"]?.["songs"][i])
    }
    console.log(this.searchList+"")
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

    // 推荐电台
    let recommendRadioStr = await this.getHttpRequest("https://apis.netstart.cn/music/personalized/djprogram")
    let recommendRadioObj:object = JSON.parse(recommendRadioStr)
    for(let i = 0; i< recommendRadioObj?.["result"]?.length;i++){
      this.recommendRadioList.push(recommendRadioObj?.["result"][i])
    }
  }

  async onPageHide(): Promise<void> {
    this.bannerList = []
    this.recommendList = []
    this.recommendSingList = []
    this.recommendSingList1 = []
    this.recommendSingList2 = []
    this.recommendRadioList = []
    this.searchList = []
  }

  build() {
    Column(){
      Row(){
        TextInput({"placeholder":"请输入查找的音乐"})
          .width("70%")
          .onChange((text:string)=>{
            console.log(text)
            this.isOpenLookSearch = true
            this.inputStr = text
            if(text === ""){
              this.isOpenLookSearch = false
            }
          })
        Button("全站搜索")
          .backgroundColor("#fbc012")
          .fontColor("#fff")
          .onClick(()=>{
            this.getSearchList(this.inputStr)
            this.isSearchSum = true
          })
      }
      .width("100%")
      .padding({
        left:20,
        right:20
      })
      Scroll(){
        Column(){
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
              .fontSize(20)
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
              .fontSize(20)
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
                    .onClick(()=>{
                      console.log(this.recommendSingList[index]?.["song"]?.["id"]);
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
                    .onClick(()=>{
                      console.log(this.recommendSingList[index]?.["song"]?.["id"]);
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
                    .onClick(()=>{
                      console.log(this.recommendSingList[index]?.["song"]?.["id"]);
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

          // 推荐电台
          Row(){
            Text("推荐电台")
              .fontWeight("bold")
              .fontSize(20)
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
                ForEach(this.recommendRadioList,(item:object,index:number)=>{
                  Row(){
                    Image(this.recommendRadioList[index]?.["picUrl"])
                      .width(130)
                      .height(130)
                      .borderRadius(5)
                    Text(this.recommendRadioList[index]?.["name"])
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
                    console.log(this.recommendRadioList[index]?.["id"]);
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

        }
        .width("100%")
        // .padding({
        //   top:50,
        //   bottom:50
        // })
      }
      .width("100%")
      .height("92%")
      .visibility(this.isOpenLookSearch === false ? Visibility.Visible : Visibility.None)

      // 搜索结果
      Column(){
        Column() {
          Image($r('app.media.noSearch'))
            .width("70%")
            .height("200vp")
            .margin({
              bottom:10
            })
          Text("暂无搜索结果")
            .fontSize(20)
            .fontWeight("bold")
        }
        .position({
          top:"50%",
          left:"50%"
        })
        .translate({
          x:"-50%",
          y:"-50%"
        })
        .visibility(this.isSearchSum === false ? Visibility.Visible : Visibility.None)

        Column(){
          Scroll(){
            Column(){
              ForEach(this.searchList,(item:object,index:number)=>{
                Row(){
                  Image(this.searchList[index]?.["artists"][0]?.["img1v1Url"])
                    .width(80)
                    .height(80)
                    .margin({
                      right:10
                    })
                  Column(){
                    Text(this.searchList[index]?.["name"])
                      .fontSize(16)
                      .fontWeight("bold")
                      .margin({
                        bottom:10
                      })
                      .width("200vp")
                      .maxLines(1)
                      .textOverflow({
                        overflow: TextOverflow.Ellipsis
                      })
                    Text(this.searchList[index]?.["artists"][0]?.["name"])
                      .fontColor("#ccc")
                      .fontSize(14)
                      .width("200vp")
                  }
                  .justifyContent(FlexAlign.Start)
                }
                .margin({
                  bottom:10
                })
                .width("100%")
                .justifyContent(FlexAlign.Start)
              })
            }
            .width("100%")
            .padding({
              left:20,
              right:20
            })
          }
          .width("100%")
          .height("100%")
        }.visibility(this.isSearchSum === true ? Visibility.Visible : Visibility.None)
      }
      .width("100%")
      .height("92%")
      .visibility(this.isOpenLookSearch === true ? Visibility.Visible : Visibility.None)
    }
  }
}