//
//  BPMediaVideoModel.swift
//  BPCommon
//
//  Created by samsha on 2021/8/18.
//

import Foundation

/// 视频资源
public class BPMediaVideoModel: BPMediaModel {

    /// 视频本地地址
    public var videoLocalPath: String?
    /// 视频网络地址
    public var videoRemotePath: String?
    /// 封面截图本地地址
    public var coverPath: String?
    /// 封面截图远端地址
    public var coverUrl: String?
    /// 封面截图尺寸
    public var coverSize: CGSize?
    /// 视频资源对象
    public var data: Data?
    /// 时长
    public var time: TimeInterval = .zero
    
    // MARK: ==== Tools ====
    /// 获取视频
    /// - Parameters:
    ///   - progress: 下载进度（如本地不存在，则下载）
    ///   - completion: 完成回调
    public func getVideo(progress: CGFloatBlock?, completion: DataBlock?) {
        if let _data = self.data {
            completion?(_data)
        } else {
            if let _path = self.videoLocalPath {
                let url = URL(fileURLWithPath: _path)
                self.data = try? Data(contentsOf: url)
            } else {
                BPDownloadManager.share.video(name: name, urlStr: self.videoRemotePath ?? "", progress: progress) { data in
                    self.data = data
                    completion?(data)
                }
            }
        }
    }
    
    /// 获取封面图
    /// - Parameters:
    ///   - progress: 下载进度（如本地不存在，则下载）
    ///   - completion: 完成回调
    public func getCover(progress: CGFloatBlock?, completion: ImageBlock?) {
        if let _localPath = self.coverPath, let image = UIImage(contentsOfFile: _localPath) {
           completion?(image)
        } else if let urlStr = self.coverUrl {
            BPDownloadManager.share.image(urlStr: urlStr, progress: progress, completion: completion)
        }
    }
    
    /// 获取视频地址
    public func getVideoUrl() -> URL? {
        if let _path = self.videoLocalPath, FileManager.default.fileExists(atPath: _path) {
            return URL(fileURLWithPath: _path)
        } else if let _path = self.videoRemotePath {
            return URL(string: _path)
        } else {
            return nil
        }
    }
}
