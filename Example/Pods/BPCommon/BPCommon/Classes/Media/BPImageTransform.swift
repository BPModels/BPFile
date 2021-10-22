//
//  BPImageTransform.swift
//  Tenant
//
//  Created by samsha on 2021/4/1.
//

import ObjectMapper

public class BPImageTransform: TransformType {

    public typealias Object = UIImage
    
    public typealias JSON = Any?
    
    init() {}
        
    public func transformFromJSON(_ value: Any?) -> UIImage? {
        var result: UIImage?
        guard let json = value as? String else {
            return result
        }
        if let imageData = Data(base64Encoded: json, options: .ignoreUnknownCharacters) {
            result = UIImage(data: imageData)
        }
        return result
    }
    
    public func transformToJSON(_ value: UIImage?) -> Any?? {
        guard let _value = value else {
            return nil
        }
        return _value.pngData()?.base64EncodedString()
    }
}
