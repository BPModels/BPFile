//
//  BPFileManager.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/7.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

public struct BPFileManager {
    
    public static let share = BPFileManager()
    
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
            BPFileConfig.share.delegate?.printFileLog(log: "文件\(name)写入失败:\(path)")
            return false
        }
        fileHandle.write(data)
        BPFileConfig.share.delegate?.printFileLog(log: "文件\(name)写入成功")
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
            BPFileConfig.share.delegate?.printFileLog(log: "文件\(name)读取失败:\(path)")
            return nil
        }
        let data = fileHandle.readDataToEndOfFile()
        BPFileConfig.share.delegate?.printFileLog(log: "文件\(name)读取成功")
        return data
    }
    
    /// 保存云盘文件
    @discardableResult
    public func saveCloudFile(folderName:String, fileName: String, data: Data) -> Bool {
        let folderPath = self.cloudPath(folderName: folderName, fileName: nil)
        self.checkDirectory(path: folderPath)
        let path = self.cloudPath(folderName: folderName, fileName: fileName)
        let result = FileManager.default.createFile(atPath: path, contents: data, attributes: nil)
        return result
    }
    /// 删除云盘文件夹或者文件
    public func removeCloudItem(folderName:String, fileName: String?) {
        let path:String = self.cloudPath(folderName: folderName, fileName: fileName)
        try? FileManager.default.removeItem(atPath: path)
    }
    
    /// 检测云盘文件是否存在
    public func checkCloudFileExists(folderName:String, fileName: String) -> Bool {
        let path = self.cloudPath(folderName: folderName, fileName: fileName)
//        let all = FileManager.default.enumerator(atPath: self.cloudPath(type: type))?.allObjects
        return FileManager.default.fileExists(atPath: path)
    }


    /// 录制的音频文件路径
    public var voicePath: String {
        let path = documentPath() + "/Voice"
        self.checkDirectory(path: path)
        return path
    }

    /// 默认资源存放路径
    /// - Returns: 路径地址
    private func normalPath() -> String {
        let path = documentPath() + "/Normal"
        self.checkDirectory(path: path)
        return path
    }
    
    /// 云盘文件(夹)路径
    public func cloudPath(folderName:String, fileName:String? = nil) -> String {
        var path = documentPath() + "/cloud/\(folderName)"
        if let fileName = fileName{
            path.append("/\(fileName)")
        }
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
