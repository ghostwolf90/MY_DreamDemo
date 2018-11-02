//
//  MYPageControlView.swift
//  MY_Demo
//
//  Created by 马慧莹 on 2018/11/2.
//  Copyright © 2018 magic. All rights reserved.
//

import UIKit

class MYPageControlView: UIView {
    
    private var views: Array<UIView>?
    private var indexView = UIView()
    
    init() {
        super.init(frame: .zero)
        self.width = MYStickerControlPageHeight
        self.height = MYStickerControlPageHeight
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func totlePage(_ totle: Int)  {
        self.height = MYStickerControlPageHeight
        self.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        var right : CGFloat = 1.0
        
        for _ in 0..<totle {
            let view = UIView(frame: .init(x: right, y: 1, width: MYKeyboardSpace5, height: MYKeyboardSpace5))
            view.layer.masksToBounds = true
            view.layer.cornerRadius = 2.5
            view.backgroundColor = MYColorForRGB(188, 188, 188)
            addSubview(view)
            views?.append(view)
            right+=(MYKeyboardSpace5 + MYKeyboardSpace8)
        }
        self.width = right + 1.0 - MYKeyboardSpace8;
        addSubview(indexView)
        indexView.backgroundColor = MYColorForRGB(245, 166, 35)
        indexView.frame = .init(x: 0, y: 0, width: MYStickerControlPageHeight, height: MYStickerControlPageHeight)
        indexView.layer.masksToBounds = true
        indexView.layer.cornerRadius = 3.5
    }
    
    func scroll(start: Int,end: Int , progress:CGFloat)  {
        let starX = CGFloat(start) * (MYStickerControlPageHeight*2 - 1.0)
        let endX = CGFloat(end) * (MYStickerControlPageHeight*2 - 1.0)
        
        indexView.x = starX + (endX - starX) * progress
    }
    

}
