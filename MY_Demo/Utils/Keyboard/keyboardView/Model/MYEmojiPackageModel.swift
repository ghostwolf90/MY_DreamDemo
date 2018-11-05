//
//  MYEmojiPackageModel.swift
//  MYTool
//
//  Created by magic on 2018/8/23.
//  Copyright © 2018年 MY. All rights reserved.
//

import UIKit

class MYEmojiPackageModel: NSObject {
    
    var emojiPackageName : String?
    var emojis : Array<MYEmojiModel>?
    var isSelect : Bool = false
    
    
}

class MYEmojiModel: NSObject {
    
    var imageName : String?
    var emojiDescription : String?
}


 
