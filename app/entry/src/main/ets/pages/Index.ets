import router from '@ohos.router';

@Entry
@Component

struct Index{
  @State countIndex: number = 0
  @State inputSms: string = ""

  build() {
    Row(){
      Row(){
        Text("千帆引擎"){

        }
        .fontSize("24vp")
        .fontColor(Color.White)

        Image($r('app.media.peacock_flat'))
          .width(30)
          .height(30)
      }
      .width("100%")
      .backgroundColor("#007dfe")
      .height("50vp")
      .position({
        top:0
      })
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({
        left: "20vp",
        right: "20vp",
      })


      Row(){

        Scroll(){
          Column(){
            Row(){
              Column(){
                Row(){
                  Image($r('app.media.peacock_flat'))
                    .width(30)
                    .height(30)
                  Text("你的小助手")
                    .fontColor("#ccc")
                }
                .width("100%")
                .justifyContent(FlexAlign.Start)
                Column(){
                  Text("你好，我是你的小助手，有什么可以帮助你的吗？你好，我是你的小助手，有什么可以帮助你的吗？")
                    .fontColor(Color.White)
                }
                .justifyContent(FlexAlign.Start)
                .width("260vp")
                .backgroundColor("#007dfe")
                .padding({
                  left: "10vp",
                  right: "10vp",
                  top: "10vp",
                  bottom: "10vp",
                })
                .borderRadius({
                  topLeft:0,
                  topRight:20,
                  bottomRight:20,
                  bottomLeft:20,
                })
              }
            }
          }
          .width("100%")
          .height("100%")
          .padding({
            top: "20vp",
            bottom: "20vp",
          })
          // .backgroundColor(Color.Red)
        }
        .width("100%")
        .height("100%")
        .visibility(this.inputSms === "" ? Visibility.None : Visibility.Visible)

        Image($r('app.media.AI'))
          .width("90%")
          .height(300)
          .visibility(this.inputSms === "" ? Visibility.Visible : Visibility.None)

        Row(){
          TextInput({placeholder: "请输入对话内容"})
          .width("100%")
          .height("50vp")
          .onChange((value: string) => {
            this.inputSms = value
          })

          Button(){
            Image($r('app.media.send'))
              .width(30)
              .height(30)
          }
          .width("50vp")
          .height("50vp")
          .position({
            right: 0,
            top: "50%"
          })
          .translate({
            y: "-50%"
          })
          .onClick(()=>{
            console.log("发送")
          })
        }
        .width("100%")
        .height("50vp")
        .position({
          bottom: 0,
          left: 0,
        })
      }
      .width("100%")
      .padding({
        left: "20vp",
        right: "20vp",
        bottom: "50vp",
        top: "50vp",
      })
      .height("100%")
      // .opacity(this.countIndex === 0 ? 1 : 0)
      .visibility(this.countIndex === 0 ? Visibility.Visible : Visibility.None)
      // .backgroundColor(Color.Red)

      // 这是功能tab
      Row(){
        Grid(){
          GridItem(){
            Column(){
              Image($r('app.media.translate'))
                .width(50)
                .height(50)
                .margin({
                  bottom: "10vp"
                })
              Text("翻译")
            }
          }
          .border({
            width:1,
            color: "#ccc"
          })
          .padding({
            left: "20vp",
            right: "20vp",
            bottom: "20vp",
            top: "20vp",
          })
          .onClick(()=>{
            console.log("翻译");
            router.pushUrl({
              url: 'pages/Translate'
            })
          })
          GridItem(){
            Column(){
              Image($r('app.media.translate'))
                .width(50)
                .height(50)
                .margin({
                  bottom: "10vp"
                })
              Text("翻译")
            }
          }
          .border({
            width:1,
            color: "#ccc"
          })
          .padding({
            left: "20vp",
            right: "20vp",
            bottom: "20vp",
            top: "20vp",
          })
        }
        .width("100%")
        .height("100%")
        .border({
          width:1,
          color: "#ccc"
        })
        .columnsTemplate('1fr 1fr 1fr')
        // .rowsTemplate('1fr 1fr 1fr')
      }
      .width("100%")
      .padding({
        left: "20vp",
        right: "20vp",
        bottom: "70vp",
        top: "70vp",
      })
      .height("100%")
      // .opacity(this.countIndex === 0 ? 1 : 0)
      .visibility(this.countIndex === 1 ? Visibility.Visible : Visibility.None)
      // .backgroundColor(Color.Red)

      Row(){
        Row(){
          Row(){
            Image($r('app.media.peacock_flat'))
              .width(50)
              .height(50)
              .margin({
                right: "20vp"
              })
            Column(){
              Text("这是用户名")
                .fontSize("20vp")
                .fontWeight("bold")
                .margin({
                  bottom: "5vp"
                })
              Text("这是用户描述")
                .fontColor("#ccc")
                .fontSize("14vp")
            }
            .alignItems(HorizontalAlign.Start)
            .width("100vp")
            Image($r('app.media.chevron_right'))
              .width(10)
              .height(10)
              .position({
                top: "50%",
                right: 0
              })
              .translate({
                y: "-50%"
              })
          }
          .width("100%")
          .height("100vp")
          .backgroundColor(Color.White)
          .padding({
            left: "20vp",
            right: "20vp",
          })
          .margin({
            top: "20vp",
          })

          Column(){
            Row(){
              Image($r('app.media.template'))
                .width(30)
                .height(30)
                .margin({
                  right: "20vp"
                })
              Text("问询模版")
              Image($r('app.media.chevron_right'))
                .position({
                  top: "50%",
                  right: 0
                })
                .translate({
                  y: "-50%"
                })
                .width(15)
                .height(15)
            }
            .width("100%")
            .height("50vp")
            .backgroundColor(Color.White)
            .padding({
              left: "20vp",
              right: "20vp",
            })
            .border({
              width: {bottom:'1px'},
              color:'#ccc'
            })

            Row(){
              Image($r('app.media.temperature'))
                .width(30)
                .height(30)
                .margin({
                  right: "20vp"
                })
              Text("自主意识")
              Image($r('app.media.chevron_right'))
                .position({
                  top: "50%",
                  right: 0
                })
                .translate({
                  y: "-50%"
                })
                .width(15)
                .height(15)
            }
            .width("100%")
            .height("50vp")
            .backgroundColor(Color.White)
            .padding({
              left: "20vp",
              right: "20vp",
            })
            .border({
              width: {bottom:'1px'},
              color:'#ccc'
            })

            Row(){
              Image($r('app.media.Devices'))
                .width(30)
                .height(30)
                .margin({
                  right: "20vp"
                })
              Text("设备详情")
              Image($r('app.media.chevron_right'))
                .position({
                  top: "50%",
                  right: 0
                })
                .translate({
                  y: "-50%"
                })
                .width(15)
                .height(15)
            }
            .width("100%")
            .height("50vp")
            .backgroundColor(Color.White)
            .padding({
              left: "20vp",
              right: "20vp",
            })
            .border({
              width: {bottom:'1px'},
              color:'#ccc'
            })
            .onClick(()=>{
              console.log("设备详情")
              router.pushUrl({
                url: 'pages/Deviceinfo'
              })
            })

            Row(){
              Image($r('app.media.Automation'))
                .width(30)
                .height(30)
                .margin({
                  right: "20vp"
                })
              Text("设置")
              Image($r('app.media.chevron_right'))
                .position({
                  top: "50%",
                  right: 0
                })
                .translate({
                  y: "-50%"
                })
                .width(15)
                .height(15)
            }
            .width("100%")
            .height("50vp")
            .backgroundColor(Color.White)
            .padding({
              left: "20vp",
              right: "20vp",
            })
          }
          .width("100%")
          .height("120vp")

          .position({
            top: "150vp"
          })
          .zIndex(2)

        }
        .alignItems(VerticalAlign.Top)
        .width("100%")
        .height("100%")
        .backgroundColor("#48cccccc")

      }
      .padding({
        bottom: "50vp",
        top: "50vp",
      })
      .width("100%")
      .height("100%")
      // .opacity(this.countIndex === 0 ? 1 : 0)
      .visibility(this.countIndex === 2 ? Visibility.Visible : Visibility.None)
      // .backgroundColor(Color.Red)

      Row(){
        Column(){
          Image($r('app.media.yingqing'))
            .width(200)
            .height(200)
            .margin({
              bottom: "40vp"
            })
          Text("Copyright © 2024 千帆大模型")
            .fontColor(Color.Black)
            .fontSize("20vp")
          Text("鸣谢深度求索提供的技术支持")
            .fontColor("#b3b3b3")
            .fontSize("13vp")
            .margin({
              top: "20vp"
            })
        }
        .justifyContent(FlexAlign.Center)
        .width("100%")
        Row(){
          Text("联系我们")
            .fontColor("#b3b3b3")
            .fontSize("13vp")
          Text(" | ")
            .fontColor("#b3b3b3")
            .fontSize("13vp")
          Text("产品使命")
            .fontColor("#b3b3b3")
            .fontSize("13vp")
        }
        .position({
          bottom: "1%",
          left: "50%"
        })
        .translate({
          x: "-50%"
        })
      }
      .width("100%")
      .padding({
        left: "20vp",
        right: "20vp",
        bottom: "50vp",
        top: "50vp",
      })
      .height("100%")
      // .opacity(this.countIndex === 0 ? 1 : 0)
      .visibility(this.countIndex === 3 ? Visibility.Visible : Visibility.None)
      // .backgroundColor(Color.Red)


      Row(){
        Text("首页"){}
        .fontSize("20vp")
        .fontWeight("bold")
        .fontColor(this.countIndex === 0 ? "#007dfe" : "#000000")
        .onClick(()=>{
          console.log("首页")
          this.countIndex = 0
        })
        Text("功能"){}
        .fontSize("20vp")
        .fontWeight("bold")
        .fontColor(this.countIndex === 1 ? "#007dfe" : "#000000")
        .onClick(()=>{
          console.log("功能")
          this.countIndex = 1
        })
        Text("用户"){}
        .fontSize("20vp")
        .fontWeight("bold")
        .fontColor(this.countIndex === 2 ? "#007dfe" : "#000000")
        .onClick(()=>{
          console.log("用户")
          this.countIndex = 2
        })
        Text("关于"){}
        .fontSize("20vp")
        .fontWeight("bold")
        .fontColor(this.countIndex === 3 ? "#007dfe" : "#000000")
        .onClick(()=>{
          console.log("关于")
          this.countIndex = 3
        })
      }
      .position({
        bottom: 0,
        left: 0,
      })
      .width("100%")
      .height("50vp")
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({
        left: "20vp",
        right: "20vp",
      })
    }
    .width("100%")
    .height("100%")

  }
}