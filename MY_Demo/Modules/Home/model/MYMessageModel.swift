//
//  MYMessageModel.swift
//  MY_Demo
//
//  Created by 马慧莹 on 2018/11/7.
//  Copyright © 2018 magic. All rights reserved.
//

import UIKit

class MYMessageModel: NSObject {

    var attribute : NSAttributedString!//应该是字符串的,xxx[xx]xxxx
    var isVoice : Bool = false
    var path : String = ""
    var time : Int = 0
    var name : String = ""
    var source : Int = 0 //为了展示左右样式
    var frame : CGRect = .zero
    
    func calculate()  {
        let maxWith : CGFloat = 200
        
        if isVoice {
            //就放左边
            if time == 0 {
                frame = .init(x: MYSCREEN_WIDTH - 10 - 35 - 10 - 10 - 45 , y: 10, width: 45, height: 35)
            }else{
                let aaa = 45 + 150 * (CGFloat(self.time)/60.0)
                frame = CGRect.init(x: MYSCREEN_WIDTH - 10 - 35 - 10 - 10 - aaa, y: 10, width: aaa, height: 35)
            }
        }else{
            let messageRect = self.attribute.boundingRect(with: .init(width: maxWith, height: CGFloat(HUGE)), options: [.usesLineFragmentOrigin,.usesFontLeading], context: nil)
            let row = Int(messageRect.height)/20 + 1
            var height = CGFloat(row * 20)
            var width = messageRect.width
            
            if width < 30.0 {
                width = 30.0
            }
            width += 30
            height += 25
            if source == 0 {
                //别人
                frame = .init(x: 10 + 35 + 10 , y: 10, width: width, height: height)
            }else{
                //自己
                frame = .init(x: MYSCREEN_WIDTH - 35 - 10 - 10 - width , y: 10, width: width, height: height)
                
            }
        }
        
    }
}
