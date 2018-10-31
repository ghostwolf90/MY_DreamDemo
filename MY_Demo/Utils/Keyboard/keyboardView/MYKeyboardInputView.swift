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
    /// 获取键盘默认宽高
    var defineHeight : CGFloat {
        return heightWithFit()
    }
    /// 获取键盘是否展示状态
    private(set) var isShowKeyboard : Bool = false
    
    ///初始化
    init() {
        super.init(frame: .zero)
        addInit()
    }
    /// 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initFrame = frame
        addInit()
    }
    
    /// 初始化控件,增加通知
    private func addInit(){
        self.layer.masksToBounds = true
        ///设置为YES的话可以阻止同一个window中其他控件与他响应
        isExclusiveTouch = true
        backgroundColor = MYColorForRGB(244, 244, 244)
        layer.borderWidth = 0.5
        layer.borderColor = MYColorForRGB(211, 211, 211).cgColor
        //默认宽高
        width = UIScreen.main.bounds.width
        height = heightWithFit()
        addSubview(emojiView)
        addSubview(funcsView)
        addSubview(textView)
        addSubview(emojiButton)
        addSubview(voiceButton)
        addSubview(funcButton)
        addSubview(voiceView)
        //增加监听
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /// 重写layout frame 改变后重新布局
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
    
    // 清除文本
    func clearText()  {
        self.textView.text = nil
        self.textView.font = UIFont.systemFont(ofSize: MYTextViewTextFont)
        // 收回键盘
        //改变 keyboard 状态
        self.keyboardType = .Record
        resignTextViewResponder()
    }
    
    // MARK: - 计算高度,frame
    
    /// 通过最大行和最小行计算textView 高度
    func heightWithFit() -> CGFloat {
        let textViewHeight = textView.layoutManager.usedRect(for: textView.textContainer).size.height + MYTextViewTextDefineHeight

        let minHeight = heightWithLine(MYEmojiTextMinLine)
        let maxHeight = heightWithLine(MYEmojiTextMaxLine)
        let calculateHeight = min(maxHeight, max(minHeight, textViewHeight))
        
        return calculateHeight + MYTextViewTopBottomSpace * 2
    }
    
    /// 计算行高
    private func heightWithLine(_ lineNumber : Int) -> CGFloat{
        let onelineStr = NSString()
        let onelineRect = onelineStr.boundingRect(with: CGSize(width: textView.width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [.font:UIFont.systemFont(ofSize: MYTextViewTextFont)], context: nil)
        return onelineRect.size.height * CGFloat(lineNumber) + MYTextViewTextDefineHeight
    }
    
    /// 计算各个控件的 frame
    private func calculateWidgetFrame(){
        let left = MYEmojiBtnWH + MYInputViewWidgetSpace * 2.0
        let top = MYTextViewTopBottomSpace
        let totleHeight = heightWithFit()
        
        let widgetY = totleHeight - MYEmojiBtnWH - MYInputViewWidgetSpace
        
        voiceButton.frame = CGRect.init(x: MYInputViewWidgetSpace, y:  widgetY, width: MYEmojiBtnWH, height: MYEmojiBtnWH)
        funcButton.frame = CGRect.init(x: self.width - MYInputViewWidgetSpace - MYEmojiBtnWH, y: widgetY, width: MYEmojiBtnWH, height: MYEmojiBtnWH)
        emojiButton.frame = CGRect.init(x: funcButton.left - MYEmojiBtnWH - MYInputViewWidgetSpace, y: widgetY, width: MYEmojiBtnWH, height: MYEmojiBtnWH)
        let width = emojiButton.left - left - MYInputViewWidgetSpace
        let height = totleHeight - MYTextViewTopBottomSpace * 2.0
        textView.frame = CGRect.init(x: left, y: top, width: width, height: height)
        voiceView.frame = textView.frame
        
    }
    
    // MARK: - 方法响应
    
    /// 录音按钮响应方法
    @objc func voiceButtonDown(_ sender: UIButton){
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.keyboardType = .System
        }else{
            self.keyboardType = .Record
        }
        
    }
    
    ///emoji 按钮响应方法
    @objc func emojiButtonDown(_ sender: UIButton){
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.keyboardType = .Emoji
        }else{
            self.keyboardType = .System
        }
        
    }
    
    /// 更多按钮响应
    @objc func moreFuncButtonDown(_ sender: UIButton){
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.keyboardType = .Funcs
        }else{
            self.keyboardType = .System
        }
    }
    
    
    // MARK: - 键盘通知 WillShow;WillHide
    
    @objc func keyboardWillShow(_ notification: Notification){
        if self.superview == nil {
            return
        }
        self.keyboardType = .System
        self.voiceButton.isSelected = true
        self.emojiButton.isSelected = false
        self.funcButton.isSelected = false
        voiceView.isHidden = true
        isShowKeyboard = true
        let userInfo = notification.userInfo!
        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        var inputViewFrame = self.frame
        let textViewHeight = heightWithFit()
        inputViewFrame.origin.y = (self.superview?.bounds.height)! - keyboardFrame.height - textViewHeight
        inputViewFrame.size.height = textViewHeight + emojiViewMaxHeight
        inputViewFrame.origin.x = -(self.superview?.left ?? 0)
        UIView.animate(withDuration: duration, animations: {
            self.frame = inputViewFrame
            self.emojiView.y = self.emojiViewMaxHeight
            self.funcsView.y = self.emojiViewMaxHeight
        }) { (finish) in
            self.emojiView.isHidden = true
            self.funcsView.isHidden = true
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification){
        if self.superview == nil {
            return
        }
        if self.keyboardType == .Record || self.keyboardType == .None{
            voiceView.isHidden = false
            isShowKeyboard = false
            voiceButton.isSelected = false
            let userInfo = notification.userInfo!
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
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
        let newFrame = CGRect.init(x: self.frame.minX, y: self.frame.maxY - size.height - self.emojiViewMaxHeight, width: size.width, height: size.height + self.emojiViewMaxHeight)
        frameAnimated(newFrame)
        textView.scrollRangeToVisible(textView.selectedRange)
    }
    
    // MARK: - 点击注销键盘
    
    //判断是否能够成为响应者链条
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if self.isShowKeyboard {
            return true
        }
        return super.point(inside: point, with: event)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchPoint = touch?.location(in: self)
        if !self.bounds.contains(touchPoint!) {
            if self.isShowKeyboard {
                self.keyboardType = .Record
                resignTextViewResponder()
            }
        }else{
            super.touchesBegan(touches, with: event)
        }
        
    }
    
    /// 注销键盘第一响应
    private func resignTextViewResponder()  {
        //改变按钮状态
        setNeedsLayout()
        textView.resignFirstResponder()
    }
    
    // MARK: - 自适应键盘高度
    
    /// 重写 sizefit 方法
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
        
        UIView.animate(withDuration: MYDuration, animations: animate)
    }
    
    // MARK: - 私有方法
    
    /// 通过 keyboardType 值,计算动画,改变布局
    private var keyboardType : MYKeyboardInputViewEnum.KeyboardType = .None {
        willSet{
            if keyboardType == newValue {
                return
            }
            self.keyboardType = newValue;
            switch newValue {
            
            case .Emoji:
                self.isShowKeyboard = true
                self.textView.resignFirstResponder()
                self.voiceView.isHidden = true
                self.emojiView.isHidden = false
                self.voiceButton.isSelected = true
                var inputViewFrame = self.frame
                let textViewHeight = heightWithFit()
                inputViewFrame.origin.y = (self.superview?.bounds.height)! - emojiViewMaxHeight - textViewHeight
                inputViewFrame.size.height = textViewHeight + emojiViewMaxHeight
                
                UIView.animate(withDuration: MYDuration, animations: {
                    self.frame = inputViewFrame
                    self.funcsView.y = inputViewFrame.size.height
                    self.emojiView.y = textViewHeight
                }) { (finish) in
                    self.funcsView.isHidden = true
                }
                    
                
                break
            case .System:
                if !self.textView.isFirstResponder {
                    self.emojiButton.isSelected = false
                    self.funcButton.isSelected = false
                    self.textView.becomeFirstResponder()
                    UIView.animate(withDuration: MYDuration, animations: {
                        self.emojiView.y = self.emojiViewMaxHeight
                        self.funcsView.y = self.emojiViewMaxHeight
                    }) { (finish) in
                        self.emojiView.isHidden = true
                        self.funcsView.isHidden = true
                    }
                }
                break
            case .Funcs:
                self.isShowKeyboard = true
                self.voiceButton.isSelected = true
                self.emojiButton.isSelected = false
                self.funcsView.isHidden = false
                if self.textView.isFirstResponder {
                    self.textView.resignFirstResponder()
                }
                var inputViewFrame = self.frame
                let textViewHeight = heightWithFit()
                inputViewFrame.origin.y = (self.superview?.bounds.height)! - emojiViewMaxHeight - textViewHeight
                inputViewFrame.size.height = textViewHeight + emojiViewMaxHeight
                UIView.animate(withDuration: MYDuration, animations: {
                    self.frame = inputViewFrame
                    self.emojiView.y = inputViewFrame.size.height
                    self.funcsView.y = textViewHeight
                }) { (finsh) in
                    self.emojiView.isHidden = true
                }
                
                break
            case .Record:
                self.emojiButton.isSelected = false
                self.funcButton.isSelected = false
                if self.textView.isFirstResponder {
                    self.textView.resignFirstResponder()
                }else{
                    self.voiceView.isHidden = false
                    var inputViewFrame = self.frame
                    let textViewHeight = heightWithFit()
                    inputViewFrame.origin.x = initFrame.minX
                    inputViewFrame.origin.y = initFrame.minY - (textViewHeight - initFrame.height)
                    inputViewFrame.size.width = initFrame.width
                    inputViewFrame.size.height = textViewHeight
                    
                    UIView.animate(withDuration: MYDuration, animations: {
                        self.frame = inputViewFrame
                    }) { (finish) in
                        self.emojiView.isHidden = true
                        self.funcsView.isHidden = true
                    }
                }
                break
            default:
                break
            }
            
        }
    }
    
    /// 计算 emojiview 最大高度
    private var emojiViewMaxHeight : CGFloat {
        get{
            
            return (safeAreaBottom() + MYStickerTopSpace + MYStickerScrollerHeight + MYStickerControlPageTopBottomSpace*2 + MYStickerControlPageHeight + MYStickerSenderBtnHeight)
        }
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
    
    private lazy var voiceView : MYVoiceTouchView = {
        let view = MYVoiceTouchView()
        view.delegate = self.recordHandle
        return view
    }()
    
    private lazy var voiceButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage(named: "toggle_record"), for: .selected)
        button.setImage(UIImage(named:"toggle_keyboard"), for: .normal)
        button.addTarget(self, action: #selector(voiceButtonDown(_:)), for: .touchUpInside)
        button.contentEdgeInsets = UIEdgeInsets.init(top: 2, left: 2, bottom: 2, right: 2)
        return button
    }()
    
    private lazy var funcButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage(named: "toggle_func"), for: .normal)
        button.setImage(UIImage(named: "toggle_func"), for: .selected)
        button.addTarget(self, action: #selector(moreFuncButtonDown(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var emojiButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage(named: "toggle_emoji"), for: .normal)
        button.setImage(UIImage(named: "toggle_keyboard"), for: .selected)
        button.addTarget(self, action: #selector(emojiButtonDown(_:)), for: .touchUpInside)
        button.contentEdgeInsets = UIEdgeInsets.init(top: 2, left: 2, bottom: 2, right: 2)
        return button
    }()
    
    private lazy var emojiView : MYEmojiKeyboardView = {
    
        let view = MYEmojiKeyboardView.init(frame: .init(x: 0, y: emojiViewMaxHeight, width: width, height: emojiViewMaxHeight))
        view.backgroundColor = .red
        view.isHidden = true
        return view
    }()
    
    private lazy var funcsView : MYEmojiKeyboardView = {
        
        let view = MYEmojiKeyboardView.init(frame: .init(x: 0, y: emojiViewMaxHeight, width: width, height: emojiViewMaxHeight))
        view.backgroundColor = UIColor.green
        view.isHidden = true
        
        return view
    }()
    
    private lazy var recordHandle : MYRecordHandled = {
        let handle = MYRecordHandled()
        return handle
    }()
   
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

