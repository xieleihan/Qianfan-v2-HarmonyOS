import { text } from '@kit.ArkGraphics2D'
import http from '@ohos.net.http';
import router from '@ohos.router';
import { pasteboard } from '@kit.BasicServicesKit';
import { promptAction } from '@kit.ArkUI';

const httpRequest = http.createHttp()
let debounceTimeoutId: number | null = null;

@Entry
@Component

struct Translate{
  @State query:string = ""
  @State result:string = ""
  @State querytext:string = ""
  @State resulttext:string = ""
  @State textArr:string[] = []

  build() {
    Column(){
      Row(){
        Select([
          { value: '简体中文' },
          { value: '繁体中文' },
          { value: '美式英文'},
          { value: '日语'}])
          .selected(0)
          .value('简体中文')
          .font({ size: 16, weight: 500 })
          .fontColor('#182431')
          .selectedOptionFont({ size: 16, weight: 400 })
          .optionFont({ size: 16, weight: 400 })
          .onSelect((index: number) => {
            console.info('Select:' + index)
            switch (index){
              case 0:
                this.query = "zh"
                break
              case 1:
                this.query = "cht"
                break
              case 2:
                this.query = "en"
                break
              case 3:
                this.query = "jp"
                break
            }
          })
          .width("40%")
          .height("30vp")

        Image($r('app.media.translate_select'))
          .width(30)
          .height(30)
          .margin({
            left: 10,
            right: 10,
          })
        Select([{ value: '简体中文' },
          { value: '繁体中文' },
          { value: '美式英文'},
          { value: '日语'}])
          .selected(2)
          .value('美式英文')
          .font({ size: 16, weight: 500 })
          .fontColor('#182431')
          .selectedOptionFont({ size: 16, weight: 400 })
          .optionFont({ size: 16, weight: 400 })
          .onSelect((index: number) => {
            console.log('Select:' + index)
            switch (index){
              case 0:
                this.result = "zh"
                break
              case 1:
                this.result = "cht"
                break
              case 2:
                this.result = "en"
                break
              case 3:
                this.result = "jp"
                break
            }
          })
          .width("40%")
          .height("30vp")
      }
      .width("100%")
      .height("30vp")
      .margin({
        bottom: 20,
      })
      .justifyContent(FlexAlign.SpaceEvenly)
      .padding({
        left:20,
        right:20,
      })
      // .backgroundColor(Color.Blue)
      Column(){
        TextArea({
          placeholder:"请输入你要翻译的文本",
        })
          .height("100vp")
          .width("100%")
          .onChange((value: string) => {
            this.querytext = value
            if(value === ""){
              this.textArr = []
              this.resulttext = ""
            }
            // 如果已有定时器，则清除它
            if (debounceTimeoutId !== null) {
              clearTimeout(debounceTimeoutId);
            }
            debounceTimeoutId = setTimeout(()=>{
              httpRequest.request(
                // 请求url地址
                'http://localhost:10089/proxy/translate',
                {
                  // 请求方式
                  method: http.RequestMethod.GET,
                  // 请求的额外数据。
                  extraData: {
                    "q": this.querytext,
                    "fromstr": this.query,
                    "to": this.result
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
                  // 检查解析后的对象是否有需要的数据
                  let dst: string = '';
                  let dstArr:object[]= obj?.['data']?.['trans_result'];

                  // 遍历数组，拼接 dst 字段的值
                  for (let i = 0; i < dstArr.length; i++) {
                    console.log(dstArr[i]?.['dst']);
                    this.textArr.push(dstArr[i]?.['dst']);
                    dst += dstArr[i]?.['dst'];
                  }
                  console.log('dst:' + dst);
                  this.resulttext = dst;
                }).catch(() => {
                console.info('error');
              });
            },5000)
          })
      }
      .padding({
        left:20,
        right:20,
      })
      .margin({
        bottom: 20,
      })

      Column(){
        TextArea({
          placeholder:"翻译结果",
          text:this.resulttext
        })
          .height("100vp")
          .width("100%")
        Image($r("app.media.copy_template"))
          .width(25)
          .height(25)
          .position({
            bottom: 10,
            right: 40,
          })
          .onClick(()=>{
            console.log("点击了复制");

            const pasteboardData =pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, this.resulttext)
            const systemPasteboard = pasteboard.getSystemPasteboard()
            systemPasteboard.setData(pasteboardData) //将数据放入剪切板
            systemPasteboard.getData().then((data) => {
              if (data) {
                promptAction.showToast({ message: "复制成功" })
              } else {
                promptAction.showToast({ message: "复制失败" })
              }
            })
          })
        Image($r('app.media.translate_song'))
          .width(25)
          .height(25)
          .position({
            bottom: 10,
            right: 10,
          })
          .onClick(()=>{
            console.log("点击了语音播放");
          })
      }
      .padding({
        left:20,
        right:20,
      })

      Text("每项翻译结果")
        .fontSize(24)
        .fontWeight("bold")
        .fontColor("#182431")
        .margin({
          bottom: 10,
          top:10,
        })
        .padding({
          left:20,
          right:20,
        })

      Column(){
        List(){
          ListItem(){
            Column(){
              Image($r('app.media.noSearch'))
                .width(250)
                .height(200)
                .margin({
                  bottom: "20vp"
                })
              Text("暂无翻译的单词结果")
                .fontColor("#ccc")
                .fontSize(14)
            }
          }
          .visibility(this.textArr.length === 0 ? Visibility.Visible : Visibility.None)
          .width("100%")
          .height("100%")

          ForEach(this.textArr,(item:string)=>{
            ListItem(){
              Row(){
                Text(item)
                Image($r('app.media.copy_template'))
                  .width(25)
                  .height(25)
                  .position({
                    right: 10,
                    top: "50%",
                  })
                  .translate({
                    y: "-50%"
                  })
                  .onClick(()=> {
                    console.log("点击了小item复制");

                    const pasteboardData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, this.resulttext)
                    const systemPasteboard = pasteboard.getSystemPasteboard()
                    systemPasteboard.setData(pasteboardData) //将数据放入剪切板
                    systemPasteboard.getData().then((data) => {
                      if (data) {
                        promptAction.showToast({ message: "复制成功" })
                      } else {
                        promptAction.showToast({ message: "复制失败" })
                      }
                    })
                  })
              }
              .onClick(()=> {
                console.log("点击了小item");
                router.pushUrl({
                  url: 'pages/TranslateText',
                  params: {
                    text: item
                  }
                },router.RouterMode.Standard)
              })
              .width("100%")
              .height("50vp")
            }
            .width("100%")
            .height("50vp")
            .border({
              width: 1,
              color: "#182431"
            })
            .margin({
              bottom: 10,
            })
            .borderRadius(20)
          })
        }
        .width("100%")
        .height("100%")
      }
      .width("100%")
      .height("400vp")
      .padding({
        left:20,
        right:20,
      })



    }
    .width("100%")
    .height("100%")

    // .backgroundColor(Color.Red)
  }
}