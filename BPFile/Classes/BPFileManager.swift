//
//  BPFileManager.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/7.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

public protocol BPFileDelegate {
    /// 输出日志
    func printLog(log: String)
}

public struct BPFileManager {
    public static let share = BPFileManager()
    
    public var delegate: BPFileDelegate?
    
    /// 保存资源文件
    /// - Parameters:
    ///   - name: 文件名称
    ///   - data: 资源数据
    /// - Returns: 是否保存成功
    @discardableResult
    public func saveFile(name: String, data: Data) -> Bool {
        let path = "\(normalPath())/\(name)"
        self.checkFile(path: path)
        guard let fileHandle = FileHandle(forWritingAtPath: path) else {
            self.delegate?.printLog(log: "文件\(name)写入失败:\(path)")
            return false
        }
        fileHandle.write(data)
        self.delegate?.printLog(log: "文件\(name)写入成功")
        return true
    }

    /// 读取资源文件
    /// - Parameters:
    ///   - name: 文件名称
    /// - Returns: 资源文件
    public func receiveSessionMediaFile(name: String) -> Data? {
        let path = "\(normalPath())/\(name)"
        // 检测文件是否存在
        guard FileManager.default.fileExists(atPath: path) else {
            return nil
        }
        guard let fileHandle = FileHandle(forReadingAtPath: path) else {
            self.delegate?.printLog(log: "文件\(name)读取失败:\(path)")
            return nil
        }
        let data = fileHandle.readDataToEndOfFile()
        self.delegate?.printLog(log: "文件\(name)读取成功")
        return data
    }

    /// 默认资源存放路径
    /// - Returns: 路径地址
    private func normalPath() -> String {
        let path = documentPath() + "/Normal"
        self.checkDirectory(path: path)
        return path
    }
    
    /// 文档路径
    /// - Returns: 路径地址
    func documentPath() -> String {
        var documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
        if documentPath == "" {
            documentPath = NSHomeDirectory() + "/Documents"
            self.checkDirectory(path: documentPath)
            return documentPath
        }
        return documentPath
    }

    /// 检查文件夹是否存在，不存在则创建
    /// - Parameter path: 文件路径
    func checkDirectory(path: String) {
        if !FileManager.default.fileExists(atPath: path) {
            try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
    }

    /// 检查文件是否存在，不存在则创建
    /// - Parameter path: 文件路径
    func checkFile(path: String) {
        if !FileManager.default.fileExists(atPath: path) {
            FileManager.default.createFile(atPath: path, contents: nil, attributes: nil)
        }
    }
}
