import MyNavigition from '../components/MyNavigation'
import http from '@ohos.net.http';

const httpRequest = http.createHttp()


@Entry
@Component

struct picrandom{

  @State picurl:string = ""
  //
  onPageShow(): void {
    const width = 3840;
    const height = 2160;
    const url = `http://localhost:10089/proxy/randomimage?width=${width}&height=${height}`;

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
        console.log(obj?.["data"])
      }).catch(() => {
      console.info('error');
    })
  }

  build(){
    Column(){
      MyNavigition({"msgtitle": "随机图片"})

      Image(this.picurl)
        .width(300)
        .height(150)
        .position({
          top:"150vp",
          left:"50%"
        })
        .translate({
          x:"-50%"
        })
        .zIndex(2)
    }
    .width("100%")
    .height("100%")
  }
}