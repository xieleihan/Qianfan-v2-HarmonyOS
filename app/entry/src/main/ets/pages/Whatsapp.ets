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

  onPageShow(): void {
    let httpRequest = http.createHttp()
  }

  build(){
    Column(){
      MyNavigationreturnbtn({msgtitle: params.text})

      // 聊天列表
    }
    .width("100%")
    .height("100%")
  }
}