# BPCommon



[![Swift](https://img.shields.io/badge/Swift-%3E=5.0-Orange?style=flat-square)](https://img.shields.io/badge/Swift-%3E=5.0-Orange?style=flat-square)

[![Platform](https://img.shields.io/badge/Platforms-iOS-Green?style=flat-square)](https://img.shields.io/badge/Platforms-iOS-Green?style=flat-square)




## Example

> To run the example project, clone the repo, and run `pod install` from the Example directory first.



## Requirements



## Installation



BPFile is available through [CocoaPods](https://cocoapods.org). To install

it, simply add the following line to your Podfile:



```ruby
pod 'BPCommon'
```


## Author



TestEngineerFish, 916878440@qq.com



---

## 使用

可通过 **BPCommonConfigDelegate** 接收事件回调

提供一些通用函数

```swift
    /// 震动
  public func shake() 

  /// 获取屏幕截图
  public func getScreenshotImage() -> UIImage?
```

网络资源下载

```swift
        ///   下载图片（下载完后会同步缓存到项目）
    /// - Parameters:
    ///   - name: 图片名称
    ///   - urlStr: 图片网络地址
    ///   - type: 图片属性
    ///   - session: 聊天室名称、ID（IM）
    ///   - progress: 下载进度
    ///   - completion: 下载后的回调
public func image(name: String, urlStr: String, type: BPMediaType, session: String?, progress: ((CGFloat) ->Void)?, completion: ImageBlock?)

public func video(name: String, urlStr: String, progress: ((CGFloat) ->Void)?, completion: ImageBlock?)

public func audio(name: String, urlStr: String, progress: ((CGFloat) ->Void)?, completion: ImageBlock?)
```



  

