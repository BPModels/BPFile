//
//  BPCommonConfig.swift
//  BPCommon
//
//  Created by samsha on 2021/6/23.
//

import Foundation

public protocol BPCommonDelegate: NSObjectProtocol {
    /// 输出日志
    func printCommonLog(log: String)
    /// 相册不可用
    func albumUseless()
    /// 相机不可用
    func cameraUseless()
    /// 无权限
    func noPermission(type: BPAuthorizationType)
}

public struct BPCommonConfig {
    public static var share = BPCommonConfig()
    
    public weak var delegate: BPCommonDelegate?
    
}
