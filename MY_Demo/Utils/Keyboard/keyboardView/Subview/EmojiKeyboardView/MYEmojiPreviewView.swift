//
//  MYEmojiPreviewView.swift
//  MY_Demo
//
//  Created by 马慧莹 on 2018/11/3.
//  Copyright © 2018 magic. All rights reserved.
//

import UIKit

class MYEmojiPreviewView: UIImageView {

    init() {
        super.init(frame: .zero)
        image = UIImage(named: "emoji_preview")
        addSubview(self.emojiImageView)
        addSubview(self.describeLabel)
    }
    
    public func preview(with model: MYEmojiModel){
        self.emojiImageView.image = UIImage.image(name: model.imageName!, path: "emoji")
        self.describeLabel.text = model.emojiDescription!
        self.emojiImageView.frame = .init(x: MYEmojiPreviewLFSpace, y: MYEmojiPreviewTopSpace, width: MYEmojiPreviewImageWH, height: MYEmojiPreviewImageWH)
        self.describeLabel.sizeToFit()
        let labelSize = self.describeLabel.size
        
        self.describeLabel.frame = .init(origin: .init(x: (width - labelSize.width)/2.0, y: self.emojiImageView.bottom + 3), size: labelSize)
    }
    
    private lazy var emojiImageView : UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    private lazy var describeLabel : UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 11)
        label.textColor = MYColorForRGB(74, 74, 74)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
