//
//  BPImageModel.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/10/29.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import ObjectMapper
import Kingfisher
import Photos



public class BPMediaModel: Mappable, Equatable {
    
    /// 资源ID
    public var id: String = ""
    /// 资源名称
    public var name: String = ""
    /// 聊天室消息ID（仅用于IM）
    public var messageId: String?
    /// 聊天室ID（仅用于IM）
    public var sessionId: String?
    /// 资源类型
    public var type: BPMediaType = .image(type: .image)
    /// 图片MD5
    public var md5: String?
    /// 文件大小
    public var fileLength: Int = .zero
    
    public init() {}
    
    required public init?(map: Map) {}
    
    public func mapping(map: Map) {
    }
    
    // MARK: ==== Tools ====
    public static func == (lhs: BPMediaModel, rhs: BPMediaModel) -> Bool {
        return lhs.id == rhs.id
    }
}

public enum BPMediaType {
    /// 图片
    case image(type: BPMediaImageType)
    /// 视频
    case video
    /// 音频
    case audio
    /// 文件
    case file
}


public enum BPMediaImageType {
    /// 头像
    case icon
    /// 地图消息
    case mapMessage
    /// 缩略图
    case thumbImage
    /// 大图（压缩后）
    case image
    /// 原图（未压缩）
    case originImage
    
    public var typeStr: String {
        get {
            switch self {
            case .icon:
                return "_pic_icon"
            case .mapMessage:
                return "_pic_map"
            case .thumbImage:
                return "_pic_thum"
            case .image:
                return "_pic"
            case .originImage:
                return "_pic_hd"
            }
        }
    }
}
