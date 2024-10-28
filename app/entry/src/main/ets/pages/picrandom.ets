import MyNavigition from '../components/MyNavigation'
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

struct picrandom{

  @State picurl:string = ""
  @State picList:string[] = []
  @State mywidth:number = 3840
  @State myheight:number  = 2160

  getRandomNumber():number{
    return Math.floor(Math.random() * this.picList.length)
  }

  //
  onPageShow(): void {

    const url = `http://localhost:10089/proxy/randomimage?width=${this.mywidth}&height=${this.myheight}`;

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
        console.log(obj?.["data"]?.["hits"])
        // this.picList = obj?.["data"]?.["hits"]
        for(let i = 0;i < obj?.["data"]?.["hits"].length;i++){
          this.picList.push(obj?.["data"]?.["hits"][i]?.["largeImageURL"])
        }
        this.picurl = this.picList[this.getRandomNumber()]
      }).catch(() => {
      console.info('error');
    })
  }

  build(){
    Column(){
      MyNavigition({msgtitle: params.text})

      Image(this.picurl)
        .width(320)
        .height(190)
        .position({
          top:"150vp",
          left:"50%"
        })
        .translate({
          x:"-50%"
        })
        .zIndex(2)
        .border({
          width:1,
          color:"#ccc",
          style:BorderStyle.Dotted
        })
        .padding({
          top:10,
          bottom:10,
          left:10,
          right:10
        })
        .borderRadius(10)

      Column(){
        Column(){
          Column(){
            Text("宽度(width):")
              .width("100%")
              .margin({
                bottom:10
              })

            TextInput({
              placeholder:"请输入宽度",

            })
              .type(InputType.Number)
              .onChange((val)=>{
                console.log("宽度改变")
                this.mywidth = Number(val)
              })
          }
          .margin({
            bottom:20
          })
          Column(){
            Text("高度(height):")
              .width("100%")
              .margin({
                bottom:10
              })
            TextInput({
              placeholder:"请输入高度"
            })
              .type(InputType.Number)
              .onChange((val)=>{
                console.log("高度改变")
                this.myheight = Number(val)
              })
          }
          .margin({
            bottom:20
          })
          Button("换一张")
            .onClick(()=>{
              console.log("点击了切换")
              this.picurl = this.picList[this.getRandomNumber()]
            })
        }


      }
      .width("100%")
      .padding({
        left:20,
        right:20
      })
      .height("100vp")
      .position({
        top:"400vp",
      })

      Row(){
        Image($r('app.media.logo'))
          .width(30)
          .height(5)
        Text("由Pixabay独家提供"){}
        .fontSize("10vp")
      }
      .position({
        bottom:10,
        left:"50%"
      })
      .translate({
        x:"-50%"
      })
    }
    .width("100%")
    .height("100%")
  }
}