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

struct MangaDetail{
  @State mangaListDetail:object[] = []
  @State mangaTitle:string = ""
  @State horizontal_cover:string = ""
  @State square_cover:string = ""
  @State vertical_cover:string = ""
  @State author_name:string = ""
  @State styles:string = ""
  @State evaluate:string = ""
  @State sumnumber:string = ""

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
    console.log(`https://apis.netstart.cn/bcomic/ComicDetail?comicId=${params.text}`)
    let mangaListStr = await this.getHttpRequest(`https://apis.netstart.cn/bcomic/ComicDetail?comicId=${params.text}`)
    console.log(mangaListStr);

    let mangaListObj:object = JSON.parse(mangaListStr)
    this.mangaTitle = mangaListObj?.["data"]?.["title"]
    this.horizontal_cover = mangaListObj?.["data"]?.["horizontal_cover"]
    this.square_cover = mangaListObj?.["data"]?.["square_cover"]
    this.vertical_cover = mangaListObj?.["data"]?.["vertical_cover"]
    this.author_name = mangaListObj?.["data"]?.["author_name"][0]
    this.styles = mangaListObj?.["data"]?.["styles"][0]
    this.evaluate = mangaListObj?.["data"]?.["evaluate"]
    this.sumnumber = mangaListObj?.["data"]?.["total"]
    for(let i = mangaListObj?.["data"]?.["ep_list"].length-1;i>=0;i--){
      this.mangaListDetail.push(mangaListObj?.["data"]?.["ep_list"][i])
    }
  }

  build() {
    Column(){
      Row(){
        // Image(this.horizontal_cover)
        //   .width("100%")
        Image(this.square_cover)
          .width("100%")
          .height(180)
      }
      .width("100%")
    }
    .width("100%")
    .height("100%")
  }
}