//
//  MYTextView.swift
//  MYTool
//
//  Created by magic on 2018/8/17.
//  Copyright © 2018年 MY. All rights reserved.
//

import UIKit

class MYTextView: UITextView {
    
    var placeholder : String? {
        set{
            self.placeholderLabel.text = newValue
            setNeedsLayout()
        }
        get{
            return self.placeholderLabel.text
        }
    }
    var placeholderColor : UIColor? {
        set{
           self.placeholderLabel.textColor = newValue
        }
        get{
            return self.placeholderLabel.textColor
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        var frame = frame
        if frame.size.height < 34.0 {
            frame.size.height = 34.0
        }
        super.init(frame: frame, textContainer: textContainer)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        showPlaceholder()
        self.placeholderLabel.frame = calcuatePlaceholderFrame()
    }
    
    override var font: UIFont? {
        didSet {
            self.placeholderLabel.font = font
        }
    }

    override var text: String! {
        didSet {
            showPlaceholder()
        }
        
    }
    
    override var attributedText: NSAttributedString! {
        didSet {
            showPlaceholder()
        }
    }
    
    // MARK: - 剪切,复制,拷贝功能
    
    override func cut(_ sender: Any?) {
        let sting = MYMatchingEmojiManager.share.exchangePlainText(self.attributedText)
        if sting != nil {
            UIPasteboard.general.string = sting
            let selectedRange = self.selectedRange
            let attributeContent = NSMutableAttributedString(attributedString: self.attributedText)
            attributeContent.replaceCharacters(in: self.selectedRange, with: "")
            attributeContent.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: MYTextViewTextFont), range: .init(location: 0, length: attributeContent.length))
            self.attributedText = attributeContent
            self.selectedRange = .init(location: selectedRange.location, length: 0)
            self.delegate?.textViewDidChange!(self)
            
        }
    }
    
    override func copy(_ sender: Any?) {
        let sting = MYMatchingEmojiManager.share.exchangePlainText(self.attributedText)
        if sting != nil {
            UIPasteboard.general.string = sting
        }
    }
    
    override func paste(_ sender: Any?) {
        let stringP = UIPasteboard.general.string
        guard let string = stringP else {
            return
        }
        let attributedPasteString = MYMatchingEmojiManager.share.exchangeAttribute(string)
        let selectedRange = self.selectedRange
        let attributeContent = NSMutableAttributedString(attributedString: self.attributedText)
        attributeContent.insert(attributedPasteString, at: self.selectedRange.location)
        attributeContent.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: MYTextViewTextFont), range: .init(location: 0, length: attributeContent.length))
        
        self.attributedText = attributeContent
        self.selectedRange = .init(location: selectedRange.location + attributedPasteString.length, length: 0)
        self.delegate?.textViewDidChange!(self)
    }
    
    // MARK: - 判断placeholder是否显示
    private func placeholderState() -> Bool{
        if (self.text.count == 0 && self.placeholder!.count > 0) {
            return true
        }
        return false
    }
    
    private func showPlaceholder() {
        self.placeholderLabel.isHidden = !placeholderState()
    }
    
    // MARK: - 计算 placeholder frame
    
    private func calcuatePlaceholderFrame() -> CGRect {
        let insets = UIEdgeInsets.init(top: 7.0, left: 4.0, bottom: 7.0, right: 4.0)
        let maxWidth = self.bounds.size.width - insets.right - insets.left
        let placeSize = calculatePlaceholderSize(maxWidth)
        let caretRect = self.caretRect(for: self.beginningOfDocument)
        
        var labelFrame = CGRect()
        labelFrame.size = placeSize
        labelFrame.origin.x = caretRect.origin.x
        labelFrame.origin.y = caretRect.origin.y
        
        return labelFrame
    }
    
    private func calculatePlaceholderSize(_ maxWidth: CGFloat) ->CGSize {
        let string = self.placeholder! as NSString
        var attribute = [NSAttributedString.Key : Any]()
        attribute[.font] = self.placeholderLabel.font
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byCharWrapping
        attribute[.paragraphStyle] = paragraphStyle
        
        let size = string.boundingRect(with: CGSize.init(width: maxWidth, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: attribute, context: nil)
        
        return size.size
    }
    
    // MARK: - 响应方法
    
    @objc func textDidChange(_ nitification: Notification){
        showPlaceholder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - 懒加载
    
    lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.isHidden = true
        label.text = ""
        label.numberOfLines = 0
        self.addSubview(label)
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
