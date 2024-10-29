import MyNavigationreturnbtn from '../components/MyNavigationreturnbtn'
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

struct Whatsapp{
  @State messageListStr:object[] = []

  async postHttpRequest(url:string,args:string):Promise<string>{
    let httpRequest = http.createHttp()
    try {
      const res = await httpRequest.request(url, {
        method: http.RequestMethod.POST,
        connectTimeout: 60000,
        readTimeout: 60000,
        header: {
          'Content-Type': 'application/json'
        },
        extraData: {
          "touser": args
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
    let messageList = await this.postHttpRequest("http://localhost:10089/private/user_messages","Bob")
    console.log(messageList)
    let messageListObj:object = JSON.parse(messageList)
    for(let i =0 ; i< messageListObj?.["data"].length;i++){
      this.messageListStr.push(messageListObj?.["data"][i])
    }
    console.log(this.messageListStr+"");
  }

  build(){
    Column(){
      MyNavigationreturnbtn({msgtitle: params.text})

      // 聊天列表
      Scroll(){
        Column(){
          ForEach(this.messageListStr,(item:object,index:number)=>{
            Column(){
              Row(){
                Row(){
                  Image($r('app.media.peacock_flat'))
                    .width(30)
                    .height(30)
                    .margin({
                      right:10
                    })
                  Column(){
                    Text(this.messageListStr[index]?.["fromuser"])
                      .fontSize(20)
                      .fontWeight("bold")
                    Text(this.messageListStr[index]?.["message"])
                      .fontColor("#ccc")
                      .fontSize(14)
                  }
                  .justifyContent(FlexAlign.Start)
                }

                Row(){
                  Text(this.messageListStr[index]?.["sendtime"])
                    .fontColor("#ccc")
                    .fontSize(14)
                }
                .position({
                  right:10,
                  top:10,
                })
              }
              .width("100%")
              .height("80vp")
              .justifyContent(FlexAlign.SpaceBetween)
              .alignItems(VerticalAlign.Center)
            }
            .width("100%")
            .height("80vp")
            .backgroundColor(Color.White)
            .padding({
              left:20,
              right:20,
            })
          })
        }
        .width("100%")

      }
      .width("100%")

      .height("400vp")
      .position({
        top: 0,
        left: 0,
      })
      .zIndex(2)
    }
    .width("100%")
    .height("100%")
  }
}