//
//  MYKeyboardButtonExtension.swift
//  MYTool
//
//  Created by 马慧莹 on 2018/8/23.
//  Copyright © 2018年 MY. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    private struct AssociatedKeys {
        static var indicatorName = "my_indicatorName"
        static var indicatorColor = "my_indicatorColor"
    }
    
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
            self.subviews.forEach { (lineView) in
                lineView.removeFromSuperview()
            }
            let width  = 1.0/UIScreen.main.scale
            let leftLine = UIView.init(frame: .init(x: 0, y: frame.height/4.0, width: width, height: frame.height/2.0))
            leftLine.backgroundColor = self.indicatorColor
            let rightLine = UIView.init(frame: .init(x: frame.width - width, y: frame.height/4.0, width: width, height: frame.height/2.0))
            rightLine.backgroundColor = self.indicatorColor
            switch newValue {
                
            case .Left:
                addSubview(leftLine)
                break
            case .Right:
                addSubview(rightLine)
                break
            case .Boths:
                addSubview(leftLine)
                addSubview(rightLine)
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
