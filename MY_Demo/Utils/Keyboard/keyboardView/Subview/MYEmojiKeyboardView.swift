//
//  MYEmojiKeyboardView.swift
//  MY_Demo
//
//  Created by 马慧莹 on 2018/9/26.
//  Copyright © 2018年 magic. All rights reserved.
//

import UIKit

class MYEmojiKeyboardView: UIView {

    /// 顶部分割线
    private var line : UIView = UIView()
    /// 总数据
    private let emojiPacks = MYMatchingEmojiManager.share.allEmojiPackages
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        
    }
    
    private func addSubviews() {
        backgroundColor = MYColorForRGB(244, 244, 244)
        self.line.frame = .init(x: 0, y: 0, width: width, height: 0.5)
        self.line.backgroundColor = MYColorForRGB(211, 211, 211)
    }
    
    override func layoutSubviews() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
