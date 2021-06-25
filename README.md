# BPFile

![BPFile: Elegant Networking in Swift](https://github.com/BPModels/BPFile/blob/master/BPFile.jpg)

[![Swift](https://img.shields.io/badge/Swift-%3E=5.0-Orange?style=flat-square)](https://img.shields.io/badge/Swift-%3E=5.0-Orange?style=flat-square)

[![Platform](https://img.shields.io/badge/Platforms-iOS-Green?style=flat-square)](https://img.shields.io/badge/Platforms-iOS-Green?style=flat-square)




## Example

> To run the example project, clone the repo, and run `pod install` from the Example directory first.



## Requirements



## Installation



BPFile is available through [CocoaPods](https://cocoapods.org). To install

it, simply add the following line to your Podfile:



```ruby
pod 'BPFile'
```



## Author



TestEngineerFish, 916878440@qq.com



---

## Use

* 设置 **BPFileConfig.delegate**，接收事件回调

* 保存普通文件 **BPFileManager**

  ~~~swift
  ```swift
  /// 保存资源文件
  /// - Parameters:
  ///   - name: 文件名称
  ///   - data: 资源数据
  /// - Returns: 是否保存成功
  @discardableResult
  public func saveFile(name: String, data: Data) -> Bool
  
  /// 读取资源文件
  /// - Parameters:
  ///   - name: 文件名称
  /// - Returns: 资源文件
  public func receiveSessionMediaFile(name: String) -> Data?
  ```
  ~~~



* 保存IM文件 **BPFileManager+IM**

    ```swift
        /// 保存IM聊天室中的资源文件
        /// - Parameters:
        ///   - type: 资源类型
        ///   - name: 文件名称
        ///   - session: 聊天室名称、ID
        ///   - data: 资源数据
        /// - Returns: 是否保存成功
        @discardableResult
        func saveSessionMediaFile(type: BPMediaType, name: String, session: String, data: Data) -> Bool
    
        /// 读取IM聊天室中的资源文件
        /// - Parameters:
        ///   - type: 资源类型
        ///   - name: 文件名称
        ///   - session: 聊天室名称、ID
        /// - Returns: 资源文件
        func receiveSessionMediaFile(type: BPMediaType, name: String, session: String) -> Data?
    ```

    

      

* 设置缓存

    ```swift
        /// 保存数据到plist文件
        ///
        /// - Parameters:
        ///   - object: 需要保存的属性
        ///   - forKey: 常量值
        static func set(_ object: Any?, forKey: String)
    
        /// 获取之前保存的数据
        ///
        /// - Parameter forKey: 常量值
        /// - Returns: 之前保存的数据,不存在则为nil
        static func object(forKey: String) -> Any? 
    
        /// 移除保存的数据
        ///
        /// - Parameter forKey: 常量值
        static func remove(forKey: String)
    ```

    

    子类也可以扩展 **BPCache** 来实现来自定义的逻辑，比如对 **forkey** 增加用户ID属性，来区分不同用户获取缓存的内容

    

    ```swift
    // 配置 BPFile
    extension BPCache {
        /// 保存数据到plist文件
        ///
        /// - Parameters:
        ///   - object: 需要保存的属性
        ///   - forKey: 常量值
        static func set(_ object: Any?, forKey: BPCacheKey) {
            let id = BPUserModel.share.id
            self.set(object, forKey: "\(id)" + forKey.rawValue)
        }
    
        /// 获取之前保存的数据
        ///
        /// - Parameter forKey: 常量值
        /// - Returns: 之前保存的数据,不存在则为nil
        static func object(forKey: BPCacheKey) -> Any? {
            let id = BPUserModel.share.id
            guard id > 0 else { return nil }
            return self.object(forKey: "\(id)" + forKey.rawValue)
        }
    
        /// 移除保存的数据
        ///
        /// - Parameter forKey: 常量值
        static func remove(forKey: BPCacheKey) {
            return self.set(nil, forKey: forKey.rawValue)
        }
    }
    ```

    

## License



BPFile is available under the MIT license. See the LICENSE file for more info.
