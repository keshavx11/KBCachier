//
//  Image+Extension.swift
//  KBCachier
//
//  Created by Keshav Bansal on 13/08/19.
//  Copyright © 2019 kb. All rights reserved.
//

import UIKit

public extension UIImageView {
    
    func setImage(withUrl url:String, placeholder: UIImage?, completion: SuccessCallback? = nil) -> CachierTask? {
        if let placeholder = placeholder {
            self.image = placeholder
        }
        return Cachier.shared.downloadImage(fromUrl: url, completion: { (image) in
            self.image = image
            completion?(true)
        }, error: { _ in
            completion?(false)
        })
    }
    
}
