import { text } from '@kit.ArkGraphics2D'

@Entry
@Component

struct Translate{
  build() {
    Column(){
      Row(){
        Select([
          { value: '繁体中文' },
          { value: '美式英文'},
          { value: '日语'}])
          .selected(2)
          .value('简体中文')
          .font({ size: 16, weight: 500 })
          .fontColor('#182431')
          .selectedOptionFont({ size: 16, weight: 400 })
          .optionFont({ size: 16, weight: 400 })
          .onSelect((index: number) => {
            console.info('Select:' + index)
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
            console.info('Select:' + index)
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
        })
          .height("100vp")
          .width("100%")
      }
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