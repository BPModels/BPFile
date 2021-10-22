//
//  BPMediaImageModel.swift
//  BPCommon
//
//  Created by samsha on 2021/8/18.
//

import ObjectMapper
import Kingfisher
import Photos

/// 图片压缩格式
public enum BPImageCompressFormat: Int {
    case jpeg
    case png
}

/// 图片资源
public class BPMediaImageModel: BPMediaModel {

    /// 图片
    public var image: UIImage?
    /// 缩略图本地地址
    public var thumbnailLocalPath: String?
    /// 缩略图网络地址
    public var thumbnailRemotePath: String?
    /// 原图本地地址
    public var originLocalPath: String?
    /// 原图网络地址
    public var originRemotePath: String?
    /// 图片尺寸
    public var imageSize: CGSize = .zero
    /// 压缩比例
    public var compressQuality: CGFloat?
    /// 压缩格式
    public var compressFormat: BPImageCompressFormat?
    
    
    // MARK: ==== Tools ====
    /// 显示缩略图，如果本地不存在则通过远端下载
    /// - Parameters:
    ///   - progress: 下载远端缩略图的进度
    ///   - completion: 下载、加载图片完成回调
    public func getThumbImage(progress: ((CGFloat) ->Void)?, completion: ImageBlock?) {
        if let image = self.image {
            completion?(image)
            return
        }
        if let _path = self.thumbnailLocalPath, let image = UIImage(contentsOfFile: _path) {
            completion?(image)
        } else {
            guard let path = self.thumbnailRemotePath else {
                completion?(nil)
                return
            }
            BPDownloadManager.share.image(urlStr: path, progress: progress, completion: completion)
        }
    }
    
    /// 显示原图，如果本地不存在则通过远端下载
    /// - Parameters:
    ///   - progress: 下载远端缩略图的进度
    ///   - completion: 下载、加载图片完成回调
    public func getOriginImage(progress: ((CGFloat) ->Void)?, completion: ImageBlock?) {
        if let image = self.image {
            completion?(image)
            return
        }
        if let _path = self.originLocalPath, let image = UIImage(contentsOfFile: _path) {
            completion?(image)
        } else {
            guard let path = self.originRemotePath else {
                completion?(nil)
                return
            }
            BPDownloadManager.share.image(urlStr: path, progress: progress, completion: completion)
        }
    }
    
    // 默认获取原图，如果没有则获取缩略图
    public func getImage(progress: ((CGFloat) ->Void)?, completion: ImageBlock?) {
        self.getOriginImage(progress: progress) { (image) in
            if let _image = image {
                completion?(_image)
            } else {
                // 获取缩略图
                self.getThumbImage(progress: progress, completion: completion)
            }
        }
    }
    
}
