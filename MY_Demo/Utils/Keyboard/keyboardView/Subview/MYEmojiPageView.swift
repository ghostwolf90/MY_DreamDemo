//
//  MYEmojiPageView.swift
//  MY_Demo
//
//  Created by 马慧莹 on 2018/11/1.
//  Copyright © 2018 magic. All rights reserved.
//

import UIKit

class MYEmojiPageView: UIView {

    weak var pageDelegate : MYEmojiProtocolDelegate?
    private var emojiModelArray : Array<MYEmojiModel> = Array<MYEmojiModel>()
    private var emojiButtons : Array<UIButton> = Array<UIButton>()
    private var deleteEmojiTimer : Timer?
    init(frame:CGRect,emojis:Array<MYEmojiModel>) {
        super.init(frame: frame)
        self.emojiModelArray = emojis
        var index : Int = 0
        let screenWidth = frame.width
        let spaceBetweenButtons = (screenWidth - CGFloat(MYEmojiPageMaxColumn) * MYEmojiButtonWH) / (CGFloat(MYEmojiPageMaxColumn) + 1.0)
        
        emojis.forEach { (model) in
            let line = index / MYEmojiPageMaxColumn
            let row = index % MYEmojiPageMaxColumn
            let minX = CGFloat(row) * MYEmojiButtonWH + (CGFloat(row) + 1) * CGFloat(spaceBetweenButtons)
            let minY = CGFloat(line) * (MYEmojiButtonWH + MYEmojiButtonVerticalMargin)
            let button = UIButton(frame: .init(x: minX, y: minY, width: MYEmojiButtonWH, height: MYEmojiButtonWH))
            addSubview(button)
            button.setImage(UIImage.image(name: model.imageName ?? "", path: "emoji"), for: .normal)
            button.imageEdgeInsets = .init(top: 5, left: 5, bottom: 5, right: 5)
            button.tag = index
            button.addTarget(self, action: #selector(emojiEvent(_:)), for: .touchUpInside)
            let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressEvent(_:)))
            longPressRecognizer.minimumPressDuration = 0.2
            longPressRecognizer.view?.tag = index
            button.addGestureRecognizer(longPressRecognizer)
            emojiButtons.append(button)
            index+=1
        }
        let minDeleteX = screenWidth - spaceBetweenButtons - MYEmojiButtonWH
        let minDeleteY = CGFloat(MYEmojiPageMaxRow - 1) * (MYEmojiButtonWH + MYEmojiButtonVerticalMargin)
        self.deleteButton.frame = .init(x: minDeleteX, y: minDeleteY, width: MYEmojiButtonWH, height: MYEmojiButtonWH)
        self.deleteButton.imageEdgeInsets = .init(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    
    @objc func emojiEvent(_ sender: UIButton) {
        
        let model = self.emojiModelArray[sender.tag]
        self.pageDelegate?.didClickEmoji(with: model)
    }
    
    @objc func longPressEvent(_ sender: UILongPressGestureRecognizer) {
        
    }
    
    @objc func didTouchDownDeleteButton(_ sender: UIButton) {
        invalidateTimer()
        self.deleteEmojiTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(deleEmojiEvent), userInfo: nil, repeats: true)
    }
    
    @objc func didTouchUpOutsideDeleteButton(_ sender: UIButton) {
        invalidateTimer()
    }
    
    @objc func didTouchUpInsideDeleteButton(_ sender: UIButton) {
        deleEmojiEvent()
        invalidateTimer()
    }
    
    private func invalidateTimer(){
        if self.deleteEmojiTimer != nil {
            self.deleteEmojiTimer?.invalidate()
            self.deleteEmojiTimer = nil
            
        }
    }
    
    @objc private func deleEmojiEvent(){
        self.pageDelegate?.didClickDelete()
    }
    
    private lazy var deleteButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "delete_emoji"), for: .normal)
        button.addTarget(self, action: #selector(didTouchDownDeleteButton(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(didTouchUpOutsideDeleteButton(_:)), for: .touchUpOutside)
        button.addTarget(self, action: #selector(didTouchUpInsideDeleteButton(_:)), for: .touchUpInside)
        addSubview(button)
        return button
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
