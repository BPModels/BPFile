//
//  BPFileConfig.swift
//  BPFile
//
//  Created by samsha on 2021/6/23.
//

import Foundation

public protocol BPFileDelegate: NSObjectProtocol {
    /// 输出日志
    func printLog(log: String)
}

public struct BPFileConfig {
    
    public static let share = BPFileConfig()
    
    public weak var delegate: BPFileDelegate?
}
