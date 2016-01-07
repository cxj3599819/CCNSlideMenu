## CCNSlideMenu
swift SlideMenu 支持 swift2.1。
学习 swift 的过程中，一次写 Demo 的时候有需要用到滑动菜单，检索之后没有找到好用的轮子，于是动手写了一个，借鉴了FDSlideBar。
水平一般，勿怪。

## 使用

### 初始化

```xml
/**
平分:Average
滑动:Slide
*/
let slideBar = CCNSlideBar(frame: CGRectMake(0, 0, MainWidth, 40), disPlayType: .Average)
slideBar.itemsTitle = self.viewArr
```

### 点击菜单item，刷新ScrollView的Frame。
```xml
self.slideBar.slideBarItemSelectedCallback { (idx) -> Void in
    //根据点击item的下标，刷新页面的Frame
}
```

