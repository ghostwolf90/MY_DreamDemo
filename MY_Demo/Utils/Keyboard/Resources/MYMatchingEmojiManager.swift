//
//  MYMatchingEmojiManager.swift
//  MYTool
//
//  Created by magic on 2018/8/23.
//  Copyright © 2018年 MY. All rights reserved.
//

import UIKit

class MYMatchingEmojiManager: NSObject {

    static let share = MYMatchingEmojiManager()
    
    override init() {
        super.init()
        self.getAllEmoji()
    }
    
    /// 获取全部的表情包
    var allEmojiPackages : Array<MYEmojiPackageModel>{
        
        return self.allEmojiPack
    }
    
    private var allEmojiPack  = Array<MYEmojiPackageModel>()
    
    // MARK: - 获取全部表情包
    
    private func getAllEmoji() {
        let bundle = Bundle.init(for: MYKeyboardInputView.self)
        
        guard let url = bundle.url(forResource: "MYKeyboardBundle", withExtension: "bundle") else {
            return
        }
        
        let fileBundle = Bundle.init(url: url)
        guard let path = fileBundle?.path(forResource: "KeyboardEmojiInfo", ofType: "plist") else {
            return
        }
        let array = NSArray.init(contentsOfFile: path)
         
        allEmojiPack = (array?.map({ (packInfo) -> MYEmojiPackageModel in
            let info = packInfo as! Dictionary<String, Any>
            var packModel = MYEmojiPackageModel()
            
            packModel.emojiPackageName = info["packagename"] as? String
            
            let emojiArray = info["emoticons"] as! Array<Any>
            packModel.emojis = emojiArray.map({ (packInfo) -> MYEmojiModel in
                let emojiDict = packInfo as! Dictionary<String, String>
                var emojiModel = MYEmojiModel()
                emojiModel.imageName = emojiDict["image"]
                emojiModel.emojiDescription = emojiDict["desc"]
                return emojiModel
            })
            
            return packModel
        }))!
        
    }
    
    // MARK: - 将富文本转为明文
    
    public func exchangePlainText(_ attribute: NSAttributedString!) -> String?{
        let range = NSRange(location: 0, length: attribute.length)
        if range.location == NSNotFound || range.length == NSNotFound {
            return nil
        }
        var result = ""
        if range.length == 0 {
            return result
        }
        let string = attribute.string as NSString
        
        attribute.enumerateAttribute(NSAttributedString.Key(rawValue: MYAddEmojiTag), in: range, options: NSAttributedString.EnumerationOptions.longestEffectiveRangeNotRequired) { (value, range, stop) in
            if value != nil {
                let tagString = value as! String
                result = result + tagString
                
            }else{
                let rangString = string.substring(with: range)
                result = result + rangString
            }
        }
        return result
        
    }
    
    public func exchangeAttribute(_ string: String,font: UIFont = UIFont.systemFont(ofSize: MYTextViewTextFont)) -> NSMutableAttributedString{
        let emojiAttributedString = NSMutableAttributedString(string: string)
        if string.count == 0 {
            return emojiAttributedString
        }
        
        let matchingResults = matchingEmoji(string)
        if matchingResults != nil {
            var offset = 0 //每替换一个将要缩进或者增加一段距离
            for result in matchingResults! {
                // 创建一个 emoji 的富文本,替换原来的标记文本
                let emojiAttribute = NSMutableAttributedString()
                if result.isHaveImage {
                    let emojiHeight = font.lineHeight
                    let attachment = NSTextAttachment()
                    attachment.image = result.emojiImage!
                    attachment.bounds = .init(x: 0, y: font.descender, width: emojiHeight, height: emojiHeight)
                    emojiAttribute.setAttributedString(NSAttributedString(attachment: attachment))
                    emojiAttribute.addAttribute(NSAttributedString.Key(rawValue: MYAddEmojiTag), value: result.showingDescription!, range: .init(location: 0, length: emojiAttribute.length))
                    
                }else{
                    emojiAttribute.setAttributedString(NSAttributedString(string: result.showingDescription!))
                }
                let actualRange = NSRange.init(location: result.range!.location - offset, length: result.showingDescription!.count)//替换的range
                emojiAttributedString.replaceCharacters(in: actualRange, with: emojiAttribute)
                offset += result.showingDescription!.count - emojiAttribute.length
            }
        }
        return emojiAttributedString
    }
    
    public func matchingEmoji(_ string: String) ->Array<MYMatchingEmojiResult>?{
        if string.count == 0 {
            return nil
        }
        //正则匹配,匹配[]中间的内容,如果出现[a[a]]则只匹配出[a]
        //正则验证网站:https://c.runoob.com/front-end/854  表达式: \[([a-z])+?\]
        let regex = try! NSRegularExpression.init(pattern: "\\[([a-z])+?\\]")
        let results = regex.matches(in: string
            , options: NSRegularExpression.MatchingOptions.reportProgress, range: .init(location: 0, length: string.count))
        
        if results.count > 0 {
            var emojiMatchingResults = Array<MYMatchingEmojiResult>()
            let tempSrring = string as NSString
            for result in results {
                var showingDescription = tempSrring.substring(with: result.range)//没有去掉[]的
                showingDescription.remove(at: showingDescription.startIndex)//去掉[
                showingDescription.removeLast()//去掉]
                let emojiModel = findEmojiModel(with: showingDescription)
                let emojiMatchingResult = MYMatchingEmojiResult()
                emojiMatchingResult.range = result.range
                emojiMatchingResult.showingDescription = "[\(showingDescription)]"//将中括号再加上
                emojiMatchingResult.imageName = showingDescription
                if emojiModel != nil {
                    // 有那个图片
                    emojiMatchingResult.isHaveImage = true
                    emojiMatchingResult.emojiImage = UIImage.image(name: showingDescription, path: "emoji")
                }
                emojiMatchingResults.append(emojiMatchingResult)
            }
           return emojiMatchingResults
        }
        return nil
    }
    
    public func findEmojiModel(with name:String) -> MYEmojiModel?{
        for package in self.allEmojiPack {
            for emoji in package.emojis! {
                if emoji.imageName! == name {
                    return emoji
                }
            }
        }
        return nil
    }
    
    
}


