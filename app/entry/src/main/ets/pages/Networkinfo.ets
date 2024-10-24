import http from '@ohos.net.http';

const httpRequest = http.createHttp()

@Entry
@Component

struct Networkinfo{

  build() {
    Row(){
      Row(){

      }
      .width("100%")
      .height("300vp")
      Column(){
        Text("网络信息")
        .fontSize(16)
        .fontColor(Color.White)
        .width("100%")
        .height("100%")
      }
    }
    .width("100%")
    .height("100%")
  }
}