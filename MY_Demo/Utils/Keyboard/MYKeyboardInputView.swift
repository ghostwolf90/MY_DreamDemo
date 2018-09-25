//
//  MYKeyboardInputView.swift
//  MYTool
//
//  Created by 马慧莹 on 2018/8/16.
//  Copyright © 2018年 MY. All rights reserved.
//

import UIKit
 

class MYKeyboardInputView: UIView,UITextViewDelegate{
    /// 初始化 frame
    var initFrame : CGRect = .zero
    /// 获取键盘是否展示状态
    private(set) var isShowKeyboard : Bool = false
    /// 获取键盘默认宽高
    var defineHeight : CGFloat {
        return heightWithFit()
    }
    private var keyboardType = MYKeyboardInputViewEnum.KeyboardType.System
    
    init() {
        super.init(frame: .zero)
        
        addInit()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initFrame = frame
        addInit()
    }
    
    private func addInit(){
        ///设置为YES的话可以阻止同一个window中其他控件与他响应
        isExclusiveTouch = true
        backgroundColor = MYColorForRGB(244, 244, 244)
        layer.borderWidth = 0.5
        layer.borderColor = MYColorForRGB(211, 211, 211).cgColor
        //默认宽高
        width = UIScreen.main.bounds.size.width
        height = heightWithFit()
        addSubview(textView)
        addSubview(emojiButton)
        //增加监听
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        calculateWidgetFrame()
    }
    
    /// 重写 frame 属性,避免宽高小于默认宽高
    override var frame: CGRect {
        didSet{
            if frame.width < (MYEmojiBtnWH + MYInputViewWidgetSpace * 3)*2 {
                width = (MYEmojiBtnWH + MYInputViewWidgetSpace * 3)*2
            }
            if frame.height < heightWithFit() {
                height = heightWithFit()
            }
        }
    }
    
    // MARK: - 公开方法
    func clearText()  {
        self.textView.text = nil
        self.textView.font = UIFont.systemFont(ofSize: MYTextViewTextFont)
        
        resignTextViewResponder()
    }
    
    // MARK: - 计算高度
    
    func heightWithFit() -> CGFloat {
        let textViewHeight = textView.layoutManager.usedRect(for: textView.textContainer).size.height + MYTextViewTextDefineHeight

        let minHeight = heightWithLine(MYEmojiTextMinLine)
        let maxHeight = heightWithLine(MYEmojiTextMaxLine)
        let calculateHeight = min(maxHeight, max(minHeight, textViewHeight))
        
        return calculateHeight + MYTextViewTopBottomSpace * 2
    }
    
    private func heightWithLine(_ lineNumber : Int) -> CGFloat{
        let onelineStr = NSString()
        let onelineRect = onelineStr.boundingRect(with: CGSize(width: textView.width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [.font:UIFont.systemFont(ofSize: MYTextViewTextFont)], context: nil)
        return onelineRect.size.height * CGFloat(lineNumber) + MYTextViewTextDefineHeight
    }
    
    private func calculateWidgetFrame(){
        let left = MYEmojiBtnWH + MYInputViewWidgetSpace * 2.0
        let top = MYTextViewTopBottomSpace
        let width = self.width - left - MYInputViewWidgetSpace
        let height = heightWithFit() - MYTextViewTopBottomSpace * 2.0
        textView.frame = CGRect.init(x: left, y: top, width: width, height: height)
        emojiButton.frame = CGRect.init(x: MYInputViewWidgetSpace, y: textView.bottom - MYEmojiBtnWH , width: MYEmojiBtnWH, height: MYEmojiBtnWH)
        
    }
    
    // MARK: - 方法响应
    @objc func changeTheInputSource(_ sender: UIButton){
        if isShowKeyboard {
            /// 键盘已经弹出,要切换
            showKeyboardFromType(self.keyboardType == .System ? .Emoji : .System)
        }else {
            showKeyboardFromType(.Emoji)
            textView.becomeFirstResponder()
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification){
        if self.superview == nil {
            return
        }
        isShowKeyboard = true
        let userInfo = notification.userInfo!
        let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect
        var inputViewFrame = self.frame
        let textViewHeight = heightWithFit()
        inputViewFrame.origin.y = (self.superview?.bounds.height)! - keyboardFrame.height - textViewHeight
        inputViewFrame.size.height = textViewHeight
        UIView.animate(withDuration: duration) {
            self.frame = inputViewFrame
        }
        
    }
    
    @objc func keyboardWillHide(_ notification: Notification){
        if self.superview == nil {
            return
        }
        isShowKeyboard = false
        let userInfo = notification.userInfo!
        let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        var inputViewFrame = self.frame
        let textViewHeight = heightWithFit()
        inputViewFrame.origin.x = initFrame.minX
        inputViewFrame.origin.y = initFrame.minY - (textViewHeight - initFrame.height)
        inputViewFrame.size.width = initFrame.width
        inputViewFrame.size.height = textViewHeight
        UIView.animate(withDuration: duration) {
            self.frame = inputViewFrame
        }
    }
    
    // MARK: - textViewDelegate
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            print(textView.text)
            clearText()
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = sizeThatFits(self.size)
        let newFrame = CGRect.init(x: self.frame.minX, y: self.frame.maxY - size.height, width: size.width, height: size.height)
        frameAnimated(newFrame)
        textView.scrollRangeToVisible(textView.selectedRange)
    }
    
    // MARK: - 点击注销键盘
    
    //判断是否能够成为响应者链条
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if textView.isFirstResponder {
            return true
        }
        return super.point(inside: point, with: event)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchPoint = touch?.location(in: self)
        if !self.bounds.contains(touchPoint!) {
            if textView.isFirstResponder {
                resignTextViewResponder()
            }
        }else{
            super.touchesBegan(touches, with: event)
        }
        
    }
    
    private func resignTextViewResponder()  {
        //改变按钮状态
        setNeedsLayout()
        textView.resignFirstResponder()
    }
    
    // MARK: - 自适应键盘高度
    
    override func sizeToFit() {
        let size = sizeThatFits(self.size)
        self.frame = CGRect.init(x: self.frame.minX, y: self.frame.maxY - size.height, width: size.width, height: size.height)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize.init(width: size.width, height: heightWithFit())
    }
    
    // MARK: - 键盘动画
    
    private func frameAnimated(_ frame: CGRect) {
        if self.frame == frame {
            return
        }
        
        let animate = {
            self.frame = frame
            self.calculateWidgetFrame()
        }
        
        UIView.animate(withDuration: 0.25, animations: animate)
    }
    
    // MARK: - 私有方法
    
    private func showKeyboardFromType(_ type: MYKeyboardInputViewEnum.KeyboardType){
        if self.keyboardType == type {
            return
        }
        var name = "toggle_emoji"
        switch type {
        case .None:
            textView.inputView = nil
            break
        case .System:
            textView.inputView = nil
            
            break
        case .Emoji:
//            textView.inputView = self.emojiKeyboardView
            name = "toggle_keyboard"
            
            break
        }
        textView.reloadInputViews()
        emojiButton.setImage(UIImage.image(name: name, path: "keyboard"), for: .normal)
        self.keyboardType = type
        
    }
    
    // MARK: - 懒加载

    private lazy var textView: MYTextView = {
        let view = MYTextView.init(frame: .zero, textContainer: nil)
        view.font = UIFont.systemFont(ofSize: MYTextViewTextFont)
        view.scrollsToTop = false
        view.returnKeyType = .send
        view.clipsToBounds = true
        view.layer.cornerRadius = 5.0
        view.enablesReturnKeyAutomatically = true
        view.inputAccessoryView = UIView()
        if #available(iOS 11.0, *) {
           view.textDragInteraction?.isEnabled = false
        }
        view.delegate = self
        return view
    }()
    
    private lazy var emojiButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.image(name: "toggle_emoji", path: "keyboard"), for: .normal)
        button.addTarget(self, action: #selector(changeTheInputSource(_:)), for: .touchUpInside)
        return button
    }()
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

