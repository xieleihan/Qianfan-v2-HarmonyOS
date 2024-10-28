@Component

export default  struct MyNavigationreturnbtn{

  @Prop msgtitle:string

  @Builder NavigationTitle() {
    Column() {
      Text('Title')
        .fontColor('#182431')
        .fontSize(30)
        .lineHeight(41)
        .fontWeight(700)
      Text('subtitle')
        .fontColor('#182431')
        .fontSize(14)
        .lineHeight(19)
        .opacity(0.4)
        .margin({ top: 2, bottom: 20 })
    }.alignItems(HorizontalAlign.Start)
  }

  @Builder NavigationMenus() {
    Row() {
      Image($r('app.media.plus'))
        .width(24)
        .height(24)
      Image($r('app.media.dot_grid_2x2'))
        .width(24)
        .height(24)
        .margin({ left: 24 })
    }
    .margin({
      top:20,
      right:20,
    })
  }

  build() {
    Column() {
      Navigation() {

      }
      // .title(this.NavigationTitle)
      .menus(this.NavigationMenus)
      .titleMode(NavigationTitleMode.Mini)
      .title(this.msgtitle)
      .hideBackButton(false)
    }.width('100%').height('100%').backgroundColor('#F1F3F5')
  }
}