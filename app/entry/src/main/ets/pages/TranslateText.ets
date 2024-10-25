import http from '@ohos.net.http';
import router from '@ohos.router';
import json from '@ohos.util.json';

const httpRequest = http.createHttp()

// 定义一个路由传参类
class routerParam{
  text: string

  constructor(value:string) {
    this.text = value
  }
}

let params = router.getParams() as routerParam
// console.log("text",params.text)


@Entry
@Component

struct TranslateText{
  @State namertext:string = ""

  onPageShow(): void {
    httpRequest.request(
      // 请求url地址
      'http://localhost:10089/proxy/textandtext',
      {
        // 请求方式
        method: http.RequestMethod.GET,
        // 请求的额外数据。
        extraData: {
          "query": params.text,
        },
        // 可选，默认为60s
        connectTimeout: 60000,
        // 可选，默认为60s
        readTimeout: 60000,
        // 开发者根据自身业务需要添加header字段
        header: {
          'Content-Type': 'application/json'
        }
      })
      .then((res) => {
        let str:string = (res.result) as string;
        console.log('Result:' + str);
        let obj:object = JSON.parse(str)

        this.namertext = obj?.["data"]?.["result"]?.["content"]
        console.log('dst:' + this.namertext);
      }).catch(() => {
      console.info('error');
    });
  }

  build(){
    Column(){
      Text(params.text)
        .fontSize("30vp")
        .fontWeight("bold")
        .margin({
          bottom: 20,
        })
      Text(this.namertext)
        .fontSize("16vp")
        .fontWeight("bold")
        .fontColor("#ccc")
    }
    .width("100%")
    .height("100%")
  }
}