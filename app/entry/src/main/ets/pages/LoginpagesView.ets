import router from '@ohos.router';
import http from '@ohos.net.http';

const httpRequest = http.createHttp()

@Entry
@Component

struct LoginpagesView{
  @State useremail: string = ""
  @State password: string = ""
  @State checked: boolean = false

  build() {
    Row() {
      Column() {
        Image($r('app.media.peacock_flat'))
          .width(150)
          .height(150)
          .position({
            top:".5%",
            right:"6%"
          })
        Text("登录"){

        }
        .fontSize('30vp')
        .fontWeight('bold')
        .width('100%')
        .textAlign(TextAlign.Start)
        .margin({
          top:"80vp",
          bottom:"20vp"
        })
        .letterSpacing(5)
        Text("欢迎使用千帆大模型"){

        }
        .fontSize("14vp")
        .fontColor("#ccc")
        .textAlign(TextAlign.Start)
        .width('100%')
        .letterSpacing(5)
        .margin({
          bottom:"20vp"
        })
        Column(){
        TextInput({
          placeholder: "请输入邮箱",
          text: this.useremail,
        })
          .onChange((value: string) => {
            this.useremail = value
          })
          .margin({
            bottom:"15vp"
          })
          .height("50vp")
          .type(InputType.Email)

          TextInput({
            placeholder: "请输入密码",
            text: this.password,
          })
            .type(InputType.Password)
            .onChange((value: string) => {
              this.password = value
            })
            .margin({
              bottom:"15vp"
            })
            .height("50vp")

          Row(){
            Checkbox({ })
              .onChange((isChecked: boolean) => {
                this.checked = isChecked;
                console.log(this.checked.toString())
              })
              .select(this.checked)
            Text("我已阅读并同意《用户协议》和《隐私政策》"){}
            .fontSize("14vp")
          }
          .width("100%")
          .height("50vp")
          .margin({
            bottom:"15vp"
          })

          Button(){
            Text("登录"){}
            .fontSize("20vp")
            .fontWeight("bold")
            .fontColor("#fff")
            .onClick(()=>{
              console.log(this.useremail);
              console.log(this.password);
              if(this.checked === false){
                console.log("请先同意用户协议和隐私政策")
                AlertDialog.show({                   // 点击按钮，弹出一个对话框
                  title: "请阅读",                 // 设置标题
                  message: "千帆大模型的《用户协议》和《隐私政策》",          // 设置内容
                  alignment: DialogAlignment.Center, // 设置弹窗的对齐方式
                  confirm: {                         // 单个按钮的配置文本
                    value: "确认",
                    fontColor: "#007dfe",
                    backgroundColor: Color.White,
                    action: () => {
                      console.log("点击了")
                      this.checked = true;
                    }
                  }
                })
                return;
              }else {
                if(this.useremail === '' || this.password === ''){
                  console.log("用户名或密码不能为空")
                  AlertDialog.show({                   // 点击按钮，弹出一个对话框
                    title: "请填写",                 // 设置标题
                    message: "用户名或密码不能为空",          // 设置内容
                    alignment: DialogAlignment.Center, // 设置弹窗的对齐方式
                    confirm: {                         // 单个按钮的配置文本
                      value: "确认",
                      fontColor: "#007dfe",
                      backgroundColor: Color.White,
                      action: () => {
                        console.log("点击了")
                      }
                    }
                  })
                  return;
                }else {
                  httpRequest.request(
                    // 请求url地址
                    'http://localhost:9001/login',
                    {
                      // 请求方式
                      method: http.RequestMethod.POST,
                      // 请求的额外数据。
                      extraData: {
                        "useremail": this.useremail,
                        "userpassword": this.password
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
                    .then((data) => {
                      if (data.responseCode === http.ResponseCode.OK) {
                        // 处理响应结果
                        // data.result为服务器返回的业务数据
                        console.info('Result:' + data.result);
                        console.info('code:' + data.responseCode);
                        if(JSON.parse(data.result as string).code === 200){
                          router.pushUrl({
                            url: 'pages/Index'
                          })
                        }else{
                          AlertDialog.show({                   // 点击按钮，弹出一个对话框
                            title: "对不起",                 // 设置标题
                            message: "登录失败",          // 设置内容
                            alignment: DialogAlignment.Center, // 设置弹窗的对齐方式
                            confirm: {                         // 单个按钮的配置文本
                              value: "返回",
                              fontColor: "#007dfe",
                              backgroundColor: Color.White,
                              action: () => {
                                this.useremail = '';
                                this.password = '';
                              }
                            }
                          })
                        }
                      }
                    }).catch(() => {
                    console.info('error');
                  });
                }
              }
            })
          }
          .width("100%")
          .height("50vp")
          .margin({
            bottom:"20vp"
          })

          Button(){
            Text("返回"){}
            .fontSize("20vp")
            .fontWeight("bold")
            .fontColor("#007dfe")
            .onClick(()=>{
              console.log("返回")
              router.pushUrl({
                url: 'pages/StartpagesView'
              })
            })
          }
          .width("100%")
          .height("50vp")
          .backgroundColor("#fff")
          .border({
            width: 1,
            color: "#007dfe"
          })
        }
          .position({
            top:"50%",
            left:"50%"
          })
          .translate({
            x: "-50%",
            y: "-50%"
          })
      }
      .width("100%")
      .height("100%")
      // .backgroundImage($r(this.arrBglist[Math.floor(Math.random() * this.arrBglist.length)]))
      // .backgroundImageSize(ImageSize.Cover)

      Text("Copyright © 2024 千帆大模型"){
      }
      .fontColor("#b3b3b3")
      .fontSize("13vp")
      .position({
        bottom:"1vp",
        left:"50%"
      })
      .translate({
        x: "-50%"
      })
    }
    .width("100%")
    .height("100%")
    .padding({
      left: "20vp",
      right: "20vp"
    })
    .backgroundImage($r("app.media.banner_background"))
    .backgroundImageSize(ImageSize.Cover)

  }
}