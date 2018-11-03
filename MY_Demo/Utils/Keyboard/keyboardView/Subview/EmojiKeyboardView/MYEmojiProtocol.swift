//
//  MYEmojiProtocol.swift
//  MY_Demo
//
//  Created by magic on 2018/11/2.
//  Copyright © 2018 magic. All rights reserved.
//

import UIKit

protocol MYEmojiProtocolDelegate : NSObjectProtocol {
    func didClickEmoji(with model:MYEmojiModel)
    func didClickDelete()
    
}

 
