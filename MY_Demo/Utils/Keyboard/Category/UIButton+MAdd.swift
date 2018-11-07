//
//  UIButton+MAdd.swift
//  MY_Demo
//
//  Created by 马慧莹 on 2018/11/7.
//  Copyright © 2018 magic. All rights reserved.
//

import Foundation
import UIKit
struct AssociatedKeys {
    static var indicatorName = "my_indicatorName"
    static var indicatorColor = "my_indicatorColor"
}

extension MYExtension where myBase : UIButton {
    
    enum MYEmojiIndicatorType {
        case None
        case Left
        case Right
        case Boths
    }
    
    var indicatorType : MYEmojiIndicatorType {
        get{
            return objc_getAssociatedObject(self, &AssociatedKeys.indicatorName) as! MYEmojiIndicatorType
        }
        
        set{
                
            my.subviews.forEach { (lineView) in
                lineView.removeFromSuperview()
            }
            let width  = 1.0/UIScreen.main.scale
            let leftLine = UIView.init(frame: .init(x: 0, y: my.frame.height/4.0, width: width, height: my.frame.height/2.0))
            leftLine.backgroundColor = self.indicatorColor
            let rightLine = UIView.init(frame: .init(x: my.frame.width - width, y: my.frame.height/4.0, width: width, height: my.frame.height/2.0))
            rightLine.backgroundColor = self.indicatorColor
            switch newValue {
                
            case .Left:
                my.addSubview(leftLine)
                break
            case .Right:
                my.addSubview(rightLine)
                break
            case .Boths:
                my.addSubview(leftLine)
                my.addSubview(rightLine)
                break
            default:
                break
            }
            objc_setAssociatedObject(self, &AssociatedKeys.indicatorName, newValue, .OBJC_ASSOCIATION_ASSIGN)
            
        }
    }
    
    var indicatorColor : UIColor {
        get{
            let any = objc_getAssociatedObject(self, &AssociatedKeys.indicatorColor)
            if any == nil {
                return UIColor.init(red: 209.0/255.0, green: 209.0/255.0, blue: 209.0/255.0, alpha: 1.0)
            }
            return any as! UIColor
        }
        set{
            objc_setAssociatedObject(self, &AssociatedKeys.indicatorColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}


