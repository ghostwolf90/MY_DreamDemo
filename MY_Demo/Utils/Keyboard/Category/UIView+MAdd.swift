//
//  UIView+MAdd.swift
//  MY_Demo
//
//  Created by 马慧莹 on 2018/11/7.
//  Copyright © 2018 magic. All rights reserved.
//

import Foundation
import UIKit

extension MYExtension where Base : UIView {
    // MARK: - 扩展属性
    /// x
    public var x: CGFloat {
        get {
            return my.frame.origin.x
        }
        set {
            my.frame.origin.x = newValue
        }
    }
    
    /// y
    public var y: CGFloat {
        get {
            return my.frame.origin.y
        }
        set {
            my.frame.origin.y = newValue
        }
    }
    
    /// top
    public var top: CGFloat {
        get {
            return my.frame.origin.y
        }
        set {
            my.frame.origin.y = newValue
        }
    }
    
    /// left
    public var left: CGFloat {
        get {
            return my.frame.origin.x
        }
        set {
            my.frame.origin.x = newValue
        }
    }
    
    /// bottom
    public var bottom: CGFloat {
        get {
            return my.frame.origin.y + my.frame.size.height
        }
        set {
            my.frame.origin.y = newValue - my.frame.size.height
        }
    }
    
    /// right
    public var right: CGFloat {
        get {
            return my.frame.origin.x + my.frame.size.width
        }
        set {
            my.frame.origin.x = newValue - my.frame.size.width
        }
    }
    
    /// width
    public var width: CGFloat {
        get {
            return my.frame.size.width
        }
        set {
            my.frame.size.width = newValue
        }
    }
    
    /// height
    public var height: CGFloat {
        get {
            return my.frame.size.height
        }
        set {
            my.frame.size.height = newValue
        }
    }
    
    /// centerx
    public var centerX: CGFloat {
        get {
            return my.center.x
        }
        set {
            my.center.x = newValue
        }
    }
    
    /// centery
    public var centerY: CGFloat {
        get {
            return my.center.y
        }
        set {
            my.center.y = newValue
        }
    }
    
    /// size
    public var size: CGSize {
        get {
            return my.frame.size
        }
        set {
            my.frame.size = newValue
        }
    }
    
    /// 边框颜色
    public var borderColor: UIColor? {
        get {
            guard let color = my.layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            guard let color = newValue else {
                my.layer.borderColor = nil
                return
            }
            // Fix React-Native conflict issue
            guard String(describing: type(of: color)) != "__NSCFType" else { return }
            my.layer.borderColor = color.cgColor
        }
    }
    
    /// 边框宽度
    public var borderWidth: CGFloat {
        get {
            return my.layer.borderWidth
        }
        set {
            my.layer.borderWidth = newValue
        }
    }
    
    /// 设置圆角
    public var cornerRadius: CGFloat {
        get {
            return my.layer.cornerRadius
        }
        set {
            my.layer.masksToBounds = true
            my.layer.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
        }
    }
    
    // MARK: - 扩展方法
    
    /// 设置圆角
    ///
    /// - Parameters:
    ///   - corners: 圆角模式
    ///   - radius: 圆角角度
    public func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(
            roundedRect: my.bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius))
        
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        my.layer.mask = shape
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

extension UIView : MYCompatible {}
