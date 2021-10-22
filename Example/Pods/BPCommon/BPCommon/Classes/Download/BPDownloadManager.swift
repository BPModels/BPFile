//
//  BPDownloadManager.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/7.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Kingfisher

public class BPDownloadManager: NSObject, URLSessionDelegate, URLSessionDownloadDelegate {
    
    public static let share = BPDownloadManager()
    private let queue = OperationQueue()
    
    /// 防止多个任务进度混淆
    private var progressBlockDic: [String:CGFloatBlock?] = [:]
    private var completeBlockDic: [String:DataBlock?]    = [:]
    
    ///   下载图片（下载完后会同步缓存到项目）
    /// - Parameters:
    ///   - urlStr: 图片网络地址
    ///   - progress: 下载进度
    ///   - completion: 下载后的回调
    public func image( urlStr: String, progress: CGFloatBlock?, completion: ImageBlock?) {
        guard let url = URL(string: urlStr) else {
            completion?(nil)
            return
        }
        UIImageView().kf.setImage(with: url, placeholder: nil, options: []) { (receivedSize, totalSize) in
            let progressValue = CGFloat(receivedSize)/CGFloat(totalSize)
            progress?(progressValue)
        } completionHandler: { (result: Result<RetrieveImageResult, KingfisherError>) in
            switch result {
            case .success(let imageResult):
                let image = imageResult.image
                completion?(image)
            case .failure(let error):
                BPCommonConfig.share.delegate?.printCommonLog(log:"资源下载失败，地址：\(urlStr), 原因：" + (error.errorDescription ?? ""))
                completion?(nil)
            }
        }
    }
    
    public func video(name: String, urlStr: String, progress: CGFloatBlock?, completion: DataBlock?) {
        let config  = URLSessionConfiguration.background(withIdentifier: "tenant.cn")
        let session = URLSession(configuration: config, delegate: self, delegateQueue: queue)
        guard let url = URL(string: urlStr) else {
            completion?(nil)
            return
        }
        let task = session.downloadTask(with: URLRequest(url: url)) { url, response, error in
            guard let localUrl = url, let _data = try? Data(contentsOf: localUrl)  else {
                completion?(nil)
                return
            }
            completion?(_data)
            print("下载完成")
        }
        task.resume()
        progressBlockDic["\(task.taskIdentifier)"] = progress
        completeBlockDic["\(task.taskIdentifier)"] = completion
    }
    
    public func audio(name: String, urlStr: String, progress: CGFloatBlock?, completion: DataBlock?) {
        let config  = URLSessionConfiguration.background(withIdentifier: "tenant.cn")
        let session = URLSession(configuration: config, delegate: self, delegateQueue: queue)
        guard let url = URL(string: urlStr) else {
            completion?(nil)
            return
        }
        let task = session.downloadTask(with: URLRequest(url: url)) { url, response, error in
            guard let localUrl = url, let _data = try? Data(contentsOf: localUrl)  else {
                completion?(nil)
                return
            }
            completion?(_data)
            print("下载完成")
        }
        task.resume()
        progressBlockDic["\(task.taskIdentifier)"] = progress
        completeBlockDic["\(task.taskIdentifier)"] = completion
    }
    
    // MARK: ==== URLSessionDelegate ====
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let key = "\(downloadTask.taskIdentifier)"
        guard let block = completeBlockDic[key], let data = try? Data(contentsOf: location) else {
            return
        }
        block?(data)
        completeBlockDic.removeValue(forKey: key)
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let key = "\(downloadTask.taskIdentifier)"
        let progress = CGFloat(bytesWritten) / CGFloat(totalBytesWritten)
        guard let block = progressBlockDic[key] else {
            return
        }
        block?(progress)
    }
}
