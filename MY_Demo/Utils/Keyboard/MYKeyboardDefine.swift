//
//  MYKeyboardDefine.swift
//  MYTool
//
//  Created by magic on 2018/8/17.
//  Copyright © 2018年 MY. All rights reserved.
//

import Foundation
import UIKit

enum MYKeyboardInputViewEnum {
    enum KeyboardType {
        case None
        case System
        case Emoji
        case Record
        case Funcs
    }
    enum EmojiIndicatorType {
        case None
        case Left
        case Right
        case Boths
    }
    
}
let MYSCREEN_WIDTH = UIScreen.main.bounds.width
let MYSCREEN_HEIGHT = UIScreen.main.bounds.height
let MYStatusHeight : CGFloat = UIApplication.shared.statusBarFrame.size.height// 状态栏高度
let MYNavHeight : CGFloat = 44
let MYTopHeight : CGFloat = MYStatusHeight + CGFloat(MYNavHeight)
let MYSafeAreaHeight : CGFloat = Int(MYStatusHeight) > 20 ? 34 : 0// iphone X 安全区域高度
let MYTextViewTextFont : CGFloat = 16.0 //字号大小
let MYTextViewTextDefineHeight :CGFloat = 14.0//textView文字16号字,默认间距
let MYTextViewTopBottomSpace : CGFloat  = 7.0 //textview 上下间距
let MYInputViewWidgetSpace : CGFloat = 7.0 //控件内间距
let MYEmojiBtnWH : CGFloat = 30.0//emoji按钮宽高
let MYEmojiBtnSpace : CGFloat = 5.0//emoji按钮间距
let MYEmojiTextMaxLine : Int = 3
let MYEmojiTextMinLine : Int = 1//最大与最小行计算
//表情键盘页面
let MYStickerTopSpace : CGFloat = 12.0//顶部距离
let MYStickerScrollerHeight : CGFloat = 132.0//滚动高度
let MYStickerControlPageTopBottomSpace : CGFloat = 10.0//pageControl 间距
let MYStickerControlPageHeight : CGFloat = 7.0//pageControl 高度
let MYStickerSenderBtnWidth : CGFloat = 55.0//发送按钮宽
let MYStickerSenderBtnHeight : CGFloat = 40.0//发送按钮高
//表情行数
let MYEmojiPageMaxRow : Int = 3//最多几行
var MYEmojiPageMaxColumn : Int {
    get{
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 8
        }
        return 7
    }
}
//表情页面
let MYEmojiButtonWH : CGFloat = 32.0//一个 emoji button 的大小
let MYEmojiButtonVerticalMargin : CGFloat = 16.0//上下间距
//富文本表情,标记
let MYAddEmojiTag : String = "MYEmojiTextGeneralTag"
let MYPreviewNotificationName = "MYPreviewNotificationName"

//预览页面
let MYEmojiPreviewTopSpace : CGFloat = 15.0//距离顶部间距
let MYEmojiPreviewImageWH : CGFloat = 30.0//图片宽高
let MYEmojiPreviewLFSpace : CGFloat = 18.0//左右间距
let MYEmojiPreviewTextMaxWidth : CGFloat = 60.0//文字最大宽度
let MYEmojiPreviewTextHeight : CGFloat = 13.0//文字最大高度
let MYEmojiPreviewHeight : CGFloat = 100.0//界面高度
let MYEmojiPreviewWidth : CGFloat = 68.0//界面宽度
let MYDuration : TimeInterval = 0.25//动画执行时间

let MYKeyboardSpace5 : CGFloat = 5.0
let MYKeyboardSpace8 : CGFloat = 8.0
let MYKeyboardSpace20 : CGFloat = 20.0

func MYColorForRGB(_ r:Int,_ g: Int,_ b:Int) ->  UIColor{
    return UIColor.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1.0)
}

func safeAreaBottom() ->  CGFloat {
    var bottomInset : CGFloat = 0.0
    if #available(iOS 11.0, *) {
        bottomInset = (UIApplication.shared.delegate?.window??.safeAreaInsets.bottom)!
    }
    return bottomInset
}
