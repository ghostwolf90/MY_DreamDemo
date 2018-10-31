//
//  MYEmojiPackageModel.swift
//  MYTool
//
//  Created by 马慧莹 on 2018/8/23.
//  Copyright © 2018年 MY. All rights reserved.
//

import UIKit

struct MYEmojiPackageModel{
    
    var emojiPackageName : String?
    var emojis : Array<MYEmojiModel>?
    var isSelect : Bool = false
    
    
}

struct MYEmojiModel {
    
    var imageName : String?
    var emojiDescription : String?
}


 
