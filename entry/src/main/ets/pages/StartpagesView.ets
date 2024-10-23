import router from '@ohos.router';


@Entry
@Component
struct StartpagesView {
  // //用来配置CanvasRenderingContext2D对象的参数，包括是否开启抗锯齿，true表明开启抗锯齿。
  // private settings: RenderingContextSettings = new RenderingContextSettings(true)
  // //用来创建CanvasRenderingContext2D对象，通过在canvas中调用CanvasRenderingContext2D对象来绘制。
  // private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  build() {
    Row() {
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
        //在canvas中调用CanvasRenderingContext2D对象。
        // Canvas(this.context)
        //   .width('100%')
        //   .height('100%')
        //   .onReady(() => {
        //
        //   })
      }
      .backgroundImage($r("app.media.banner_background"))
      .backgroundImageSize(ImageSize.Cover)
      .width('100%')
      .height('100%')
      .position({
          top: 0,
          left: 0,
        })
      .zIndex(-1)

      Column() {
        Image($r('app.media.peacock_flat'))
          .width(150)
          .height(150)
          .position({
            top:"20%",
            left:"50%"
          })
          .translate({
              x: "-50%",
          })
        Text("千帆大模型"){}
        .fontSize("20vp")
        .fontWeight("bold")
        .fontColor("#000000")
        .letterSpacing(5)
        .position({
          top:"45%",
          left:"50%"
        })
        .translate({
          x: "-50%",
        })
        Text("沉舟侧畔千帆过,病树前头万木春"){

        }
        .fontColor("#ccc")
        .position({
          top:"50%",
          left:"50%"
        })
        .translate({
          x: "-50%",
        })
        .fontSize("14vp")
        .letterSpacing(5)
      }

      Column(){
        Button(){
          Text("登录"){

          }
          .fontColor("#fff")

        }
        .width("100%")
        .padding({
          left: "20vp",
          right: "20vp",
          top:"20vp",
          bottom:"20vp"
        })
        .margin({
          bottom: "20vp"
        })
        .onClick(()=>{
          console.log("登录")
          router.pushUrl({
            url: 'pages/LoginpagesView'
          })
        })

        Button(){
          Text("注册"){

          }
          .fontColor("#007dfe")
        }
        .width("100%")
        .padding({
          left: "20vp",
          right: "20vp",
          top:"20vp",
          bottom:"20vp"
        })
        .backgroundColor("#fff")
        .border({
          width: 1,
          color: "#007dfe"
        })

      }
      .width("100%")
      .height(100)
      .position({
        bottom: "10%",
        left: 0,
      })
      .padding({
        left: "20vp",
        right: "20vp"
      })
      .onClick(()=>{
        console.log("注册")
        router.pushUrl({
          url: 'pages/RegisterpagesView'
        })
      })
    }
    .width("100%")
    .height("100%")


  }
}