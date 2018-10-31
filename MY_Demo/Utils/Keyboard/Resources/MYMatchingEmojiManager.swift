//
//  MYMatchingEmojiManager.swift
//  MYTool
//
//  Created by 马慧莹 on 2018/8/23.
//  Copyright © 2018年 MY. All rights reserved.
//

import UIKit

class MYMatchingEmojiManager: NSObject {

    static let share = MYMatchingEmojiManager()
    
    var allEmojiPackages : Array<MYEmojiPackageModel>{
        
        return self.allEmojiPack
    }
    
    private var allEmojiPack  = Array<MYEmojiPackageModel>()
    
    override init() {
        super.init()
        self.getAllEmoji()
    }
    
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
}
