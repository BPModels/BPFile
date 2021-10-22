//
//  BPAuthoriationManager.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/4.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import Photos
import UserNotifications
import UIKit
import Contacts

public enum BPAuthorizationType: String {
    /// 相册
    case photo        = "相册"
    /// 照相机
    case camera       = "照相机"
    /// 麦克风
    case microphone   = "麦克风"
    /// 定位
    case location     = "定位"
    /// 通知
    case notification = "通知"
    /// 网络
    case network      = "网络"
    /// 通讯录
    case contact      = "通讯录"
}

public class BPAuthorizationManager: NSObject, CLLocationManagerDelegate {
    
    public static let share = BPAuthorizationManager()
    
    // MARK: - ---获取相册权限
    public func photo(completion:@escaping (Bool) -> Void) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            BPCommonConfig.share.delegate?.albumUseless()
            return
        }
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            completion(true)
        case .denied, .restricted:
            completion(false)
            BPCommonConfig.share.delegate?.noPermission(type: .photo)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status) in
                DispatchQueue.main.async {
                    let result = status == PHAuthorizationStatus.authorized
                    completion(result)
                    if (!result) {
                        BPCommonConfig.share.delegate?.noPermission(type: .photo)
                    }
                }
            })
        case .limited:
            completion(true)
        @unknown default:
            return
        }
    }
    
    // MARK: - --相机权限
    public func camera(completion:@escaping (Bool) -> Void ) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            BPCommonConfig.share.delegate?.cameraUseless()
            return
        }
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch status {
        case .authorized:
            completion(true)
        case .denied:
            completion(false)
            BPCommonConfig.share.delegate?.noPermission(type: .camera)
        case .restricted:
            completion(false)
            BPCommonConfig.share.delegate?.noPermission(type: .camera)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) in
                DispatchQueue.main.async {
                    completion(granted)
                    if (!granted) {
                        BPCommonConfig.share.delegate?.noPermission(type: .camera)
                    }
                }
            })
        @unknown default:
            return
        }
    }
    
    // MARK: - --麦克风权限
    public func authorizeMicrophoneWith(_ autoAlert: Bool = true, completion:@escaping (Bool) -> Void ) {
        
        let status = AVAudioSession.sharedInstance().recordPermission
        
        switch status {
        case .granted:
            completion(true)
        case .denied:
            completion(false)
            if autoAlert {
                BPCommonConfig.share.delegate?.noPermission(type: .microphone)
            }
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { (allow) in
                DispatchQueue.main.async {
                    completion(allow)
                    if (!allow && autoAlert) {
                        BPCommonConfig.share.delegate?.noPermission(type: .microphone)
                    }
                }
            }
        @unknown default:
            return
        }
    }
    let locationManager = CLLocationManager()
    // MARK: - --位置权限
    public func authorizeLocationWith(completion: ((Bool) -> Void)?) {
        locationManager.delegate  = self
        self.authorizationComplet = completion
        if CLLocationManager.locationServicesEnabled() {
            let authStatus = CLLocationManager.authorizationStatus()
            if authStatus == .notDetermined {
                // App没有显示过授权
                locationManager.requestWhenInUseAuthorization()
                //                completion?(false)
            } else if authStatus == .authorizedWhenInUse {
                // 已经授权
                completion?(true)
            } else if authStatus == .restricted || authStatus == .denied { // App没有授权，或者授权后用户手动关闭了
                completion?(false)
                BPCommonConfig.share.delegate?.noPermission(type: .location)
            }
        } else {
            completion?(false)
            BPCommonConfig.share.delegate?.noPermission(type: .location)
        }
    }
    
    // MARK: - --远程通知权限
    public func authorizeRemoteNotification(_ completion:@escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            DispatchQueue.main.async {
                if settings.authorizationStatus == .denied || settings.authorizationStatus == .notDetermined {
                    completion(false)
                }else{
                    completion(true)
                }
            }
        }
    }
    
    private var authorizationComplet: BoolBlock?
    // MARK: ==== CLLocationManagerDelegate ====
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            self.authorizationComplet?(true)
        default:
            self.authorizationComplet?(false)
        }
    }
    
    
    // MARK: -- 通讯录权限
    public func contact(completion:@escaping (Bool) -> Void ) {
        let status = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        switch status {
        case .authorized:
            completion(true)
        case .denied, .restricted:
            completion(false)
            BPCommonConfig.share.delegate?.noPermission(type: .contact)
        case .notDetermined:
            CNContactStore().requestAccess(for: .contacts, completionHandler: { (granted, error) in
                completion(granted)
                if (!granted) {
                    BPCommonConfig.share.delegate?.noPermission(type: .contact)
                }
            })
        @unknown default:
            return
        }
    }
    
    
    
}
