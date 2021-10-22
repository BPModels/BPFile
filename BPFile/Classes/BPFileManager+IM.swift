//
//  BPFileManager+IM.swift
//  BPFile
//
//  Created by samsha on 2021/6/23.
//

import Foundation
import BPCommon

public extension BPFileManager {

    /// 保存IM聊天室中的资源文件
    /// - Parameters:
    ///   - type: 资源类型
    ///   - name: 文件名称
    ///   - session: 聊天室名称、ID
    ///   - data: 资源数据
    /// - Returns: 保存后的地址(为空则保存失败)
    @discardableResult
    func saveSessionMediaFile(type: BPMediaType, name: String, session: String, data: Data) -> String? {
        var path = ""
        switch type {
        case .image(let type):
            switch type {
            case .icon:
                path = "\(iconPath())/" + name
            case .mapMessage:
                path = "\(mapMessagePath())/" + name
            default:
                let dotIndex = name.lastIndex(of: ".") ?? name.endIndex
                let _name    = name[name.startIndex..<dotIndex]
                let _suffix  = name[dotIndex..<name.endIndex]
                path = "\(imagePath(session: session))/\(_name)\(type.typeStr)\(_suffix)"
            }
        case .video:
            path = "\(videoPath(session: session))/\(name)"
        case .audio:
            path = "\(audioPath(session: session))/\(name)"
        case .file:
            path = "\(filePath(session: session))/\(name)"
        }
        self.checkFile(path: path)
        guard let fileHandle = FileHandle(forWritingAtPath: path) else {
            BPFileConfig.share.delegate?.printFileLog(log: "文件\(name)写入失败:\(path)")
            return nil
        }
        fileHandle.write(data)
        BPFileConfig.share.delegate?.printFileLog(log: "文件\(name)写入成功")
        return path
    }

    /// 读取IM聊天室中的资源文件
    /// - Parameters:
    ///   - type: 资源类型
    ///   - name: 文件名称
    ///   - session: 聊天室名称、ID
    /// - Returns: 资源文件
    func receiveSessionMediaFile(type: BPMediaType, name: String, session: String) -> Data? {
        var path = ""
        switch type {
        case .image(let type):
            switch type {
            case .icon:
                path = "\(iconPath())/\(name)"
            case .mapMessage:
                path = "\(mapMessagePath())/" + name
            case .thumbImage, .image, .originImage:
                let dotIndex = name.lastIndex(of: ".") ?? name.endIndex
                let _name    = name[name.startIndex..<dotIndex]
                let _suffix  = name[dotIndex..<name.endIndex]
                path = "\(imagePath(session: session))/\(_name)\(type.typeStr)\(_suffix)"
            }
        case .video:
            path = "\(videoPath(session: session))/\(name)"
        case .audio:
            path = "\(audioPath(session: session))/\(name)"
        case .file:
            path = "\(filePath(session: session))/\(name)"
        }
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

    // MARK: ==== Tools ====

    /// 获取会话头像存储路径
    private func iconPath() -> String {
        let path = "\(mediaPath())/Icon"
        self.checkDirectory(path: path)
        return path
    }
    
    /// 获取会话地图快照存储路径
    private func mapMessagePath() -> String {
        let path = "\(mediaPath())/mapMessage"
        self.checkDirectory(path: path)
        return path
    }

    /// 图片存放路径
    /// - Returns: 路径地址
    private func imagePath(session: String) -> String {
        let path = "\(mediaPath())/\(session)/image"
        self.checkDirectory(path: path)
        return path
    }

    /// 视频存放路径
    /// - Returns: 路径地址
    private func videoPath(session: String) -> String {
        let path = "\(mediaPath())/\(session)/video"
        self.checkDirectory(path: path)
        return path
    }

    /// 音频存放路径
    /// - Returns: 路径地址
    private func audioPath(session: String) -> String {
        let path = "\(mediaPath())/\(session)/audio"
        self.checkDirectory(path: path)
        return path
    }

    /// 文件存放路径
    /// - Returns: 路径地址
    private func filePath(session: String) -> String {
        let path = "\(mediaPath())/\(session)/file"
        self.checkDirectory(path: path)
        return path
    }

    /// 多媒体资源存放路径
    /// - Returns: 路径地址
    private func mediaPath() -> String {
        let path = documentPath() + "/Chat"
        self.checkDirectory(path: path)
        return path
    }
}



