//
//  MYEmojiPageView.swift
//  MY_Demo
//
//  Created by magic on 2018/11/1.
//  Copyright © 2018 magic. All rights reserved.
//

import UIKit



/// emoji按钮界面
class MYEmojiPageView: UIView {

    weak var pageDelegate : MYEmojiProtocolDelegate?
    private var emojiModelArray : Array<MYEmojiModel> = Array<MYEmojiModel>()
    private var emojiButtons : Array<UIButton> = Array<UIButton>()
    private var deleteEmojiTimer : Timer?
    private var emojiPreviewView = MYEmojiPreviewView()
    init(frame:CGRect,emojis:Array<MYEmojiModel>) {
        super.init(frame: frame)
        self.emojiModelArray = emojis
        var index : Int = 0
        let screenWidth = frame.width
        let spaceBetweenButtons = (screenWidth - CGFloat(MYEmojiPageMaxColumn) * MYEmojiButtonWH) / (CGFloat(MYEmojiPageMaxColumn) + 1.0)
        layer.masksToBounds = false
        emojis.forEach { (model) in
            let line = index / MYEmojiPageMaxColumn
            let row = index % MYEmojiPageMaxColumn
            let minX = CGFloat(row) * MYEmojiButtonWH + (CGFloat(row) + 1) * CGFloat(spaceBetweenButtons)
            let minY = CGFloat(line) * (MYEmojiButtonWH + MYEmojiButtonVerticalMargin)
            let button = UIButton(frame: .init(x: minX, y: minY, width: MYEmojiButtonWH, height: MYEmojiButtonWH))
            addSubview(button)
            button.setImage(UIImage.image(name: model.imageName ?? "", path: "emoji"), for: .normal)
            button.imageEdgeInsets = .init(top: 2, left: 2, bottom: 2, right: 2)
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
        self.deleteButton.imageEdgeInsets = .init(top: 2, left: 2, bottom: 2, right: 2)
        
    }
    
    
    @objc private func emojiEvent(_ sender: UIButton) {
        
        let model = self.emojiModelArray[sender.tag]
        self.pageDelegate?.didClickEmoji(with: model)
    }
    
    
    @objc private func longPressEvent(_ sender: UILongPressGestureRecognizer) {
        let index = sender.view!.tag
        let model = self.emojiModelArray[index]
        let button = self.emojiButtons[index]
        
        switch sender.state {
        case .began:

            showPreview(with: model, button: button)
            break
        case .changed:
            showPreview(with: model, button: button)
            break
        case .ended:
            emojiPreviewView.removeFromSuperview()
            emojiEvent(button)
            break
            
        default:
            emojiPreviewView.removeFromSuperview()
            break
        }
    }
    
    @objc private func didTouchDownDeleteButton(_ sender: UIButton) {
        invalidateTimer()
        self.deleteEmojiTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(deleEmojiEvent), userInfo: nil, repeats: true)
    }
    
    @objc private func didTouchUpOutsideDeleteButton(_ sender: UIButton) {
        invalidateTimer()
    }
    
    @objc private func didTouchUpInsideDeleteButton(_ sender: UIButton) {
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
    
    // MARK: - 展示预览界面
    
    private func showPreview(with model: MYEmojiModel,button: UIButton) {
        
        emojiPreviewView.frame = .init(origin: .zero, size: .init(width: MYEmojiPreviewWidth, height: MYEmojiPreviewHeight))
        emojiPreviewView.bottom = button.bottom
        emojiPreviewView.x = button.left - (MYEmojiPreviewWidth - button.width)/2
        emojiPreviewView.preview(with: model)
        addSubview(emojiPreviewView)
        
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
