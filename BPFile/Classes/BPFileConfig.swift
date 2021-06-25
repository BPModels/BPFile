//
//  BPFileConfig.swift
//  BPFile
//
//  Created by samsha on 2021/6/23.
//

import Foundation

public protocol BPFileDelegate: NSObjectProtocol {
    /// 输出日志
    func printFileLog(log: String)
}

public struct BPFileConfig {
    
    public static var share = BPFileConfig()
    
    public weak var delegate: BPFileDelegate?
}
