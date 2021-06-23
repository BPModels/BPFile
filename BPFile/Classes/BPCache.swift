//
//  BPCache.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/9/9.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import Foundation

public protocol BPCacheDelegate {
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
}

public extension BPCacheDelegate {
    /// 保存数据到plist文件
    ///
    /// - Parameters:
    ///   - object: 需要保存的属性
    ///   - forKey: 常量值
    static func set(_ object: Any?, forKey: String) {
        UserDefaults.standard.archive(object: object, forkey: forKey)
    }

    /// 获取之前保存的数据
    ///
    /// - Parameter forKey: 常量值
    /// - Returns: 之前保存的数据,不存在则为nil
    static func object(forKey: String) -> Any? {
        return UserDefaults.standard.unarchivedObject(forkey: forKey)
    }

    /// 移除保存的数据
    ///
    /// - Parameter forKey: 常量值
    static func remove(forKey: String) {
        return set(nil, forKey: forKey)
    }
}

public struct BPCache: BPCacheDelegate {

}
