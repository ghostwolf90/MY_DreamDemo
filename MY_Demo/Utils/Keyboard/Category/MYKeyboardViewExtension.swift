//
//  MYKeyboardViewExtension.swift
//  MYTool
//
//  Created by 马慧莹 on 2018/8/17.
//  Copyright © 2018年 MY. All rights reserved.
//

import Foundation
import UIKit

// MARK: - 扩展属性

public extension UIView {
    /// x
    public var x: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            frame.origin.x = newValue
        }
    }
    
    /// y
    public var y: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            frame.origin.y = newValue
        }
    }
    
    /// top
    public var top: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            frame.origin.y = newValue
        }
    }
    
    /// left
    public var left: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            frame.origin.x = newValue
        }
    }
    
    /// bottom
    public var bottom: CGFloat {
        get {
            return frame.origin.y + frame.size.height
        }
        set {
            frame.origin.y = newValue - frame.size.height
        }
    }
    
    /// right
    public var right: CGFloat {
        get {
            return frame.origin.x + frame.size.width
        }
        set {
            frame.origin.x = newValue - frame.size.width
        }
    }
    
    /// width
    public var width: CGFloat {
        get {
            return frame.size.width
        }
        set {
            frame.size.width = newValue
        }
    }
    
    /// height
    public var height: CGFloat {
        get {
            return frame.size.height
        }
        set {
            frame.size.height = newValue
        }
    }
    
    /// centerx
    public var centerX: CGFloat {
        get {
            return center.x
        }
        set {
            center.x = newValue
        }
    }
    
    /// centery
    public var centerY: CGFloat {
        get {
            return center.y
        }
        set {
            center.y = newValue
        }
    }
    
    /// size
    public var size: CGSize {
        get {
            return frame.size
        }
        set {
            frame.size = newValue
        }
    }
    
    /// 边框颜色
    public var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            guard let color = newValue else {
                layer.borderColor = nil
                return
            }
            // Fix React-Native conflict issue
            guard String(describing: type(of: color)) != "__NSCFType" else { return }
            layer.borderColor = color.cgColor
        }
    }
    
    /// 边框宽度
    public var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    /// 设置圆角
    public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.masksToBounds = true
            layer.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
        }
    }
    
}

// MARK: - 扩展方法

public extension UIView {
    
    /// 设置圆角
    ///
    /// - Parameters:
    ///   - corners: 圆角模式
    ///   - radius: 圆角角度
    public func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius))
        
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
    
    /// 设置圆角 默认: .allCorners
    ///
    /// - Parameter radius: 圆角角度
    public func defaultRoundCourners(_ radius: CGFloat) {
        self.roundCorners(.allCorners, radius: radius)
    }
    
    /// 获取当前栈顶的控制器
    ///
    /// - Parameter rootViewController: UIApplication.shared.delegate?.window.rootControl
    /// - Returns: 最顶层控制器
    public func topViewControlWithRootViewControler(_ rootViewController : UIViewController?) -> UIViewController {
        if rootViewController!.isKind(of: UITabBarController.self) {
            let tabBarControl = rootViewController as! UITabBarController
            return topViewControlWithRootViewControler(tabBarControl.selectedViewController)
        }else if rootViewController!.isKind(of: UINavigationController.self) {
            let navigationControl = rootViewController as! UINavigationController
            return topViewControlWithRootViewControler( navigationControl.visibleViewController)
        }else if (rootViewController!.presentedViewController != nil) {
            let presentedViewController = rootViewController?.presentedViewController
            return topViewControlWithRootViewControler(presentedViewController)
        }else {
            return rootViewController!
        }
    }
}
