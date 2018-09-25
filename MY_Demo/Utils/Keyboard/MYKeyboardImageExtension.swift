//
//  MYKeyboardImageExtension.swift
//  MYTool
//
//  Created by 马慧莹 on 2018/8/20.
//  Copyright © 2018年 MY. All rights reserved.
//

import Foundation
import UIKit
public extension UIImage {
    class func image(name: String, path: String) -> UIImage?{
        let bundle = Bundle.init(for:MYKeyboardInputView.self)
        let url = bundle.url(forResource: "MYKeyboardBundle", withExtension: "bundle")
        if url == nil {
            return nil
        }
        let imgUrl = (url?.absoluteString)! + path + "/"
        let imageBundle = Bundle.init(url: URL.init(string: imgUrl)!)
        if imageBundle == nil {
            return nil
        }
        let scale = UIScreen.main.scale
        let resourcePath = (imageBundle?.resourcePath)!
        
        var imageNamePath = resourcePath + "/" + name
        if scale == 2.0 {
            imageNamePath = imageNamePath + "@2x"
        }else if scale == 3.0{
            imageNamePath = imageNamePath + "@3x"
            let image = UIImage.init(named: imageNamePath)
            if image != nil {
                return image
            }else{
                imageNamePath = imageNamePath + "@2x"
                let image = UIImage.init(named: imageNamePath)
                if image != nil {
                    return image
                }
            }
        }
        let image = UIImage.init(named: imageNamePath)
        if image != nil {
            return image
        }else{
            let image = UIImage.init(named: resourcePath + "/" + name)
            if image != nil {
                return image
            }
        }
        
        
        return nil
    }
}
