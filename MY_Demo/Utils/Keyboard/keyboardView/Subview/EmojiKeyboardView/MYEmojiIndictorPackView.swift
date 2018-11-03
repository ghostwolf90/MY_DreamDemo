//
//  MYEmojiIndictorPackView.swift
//  MY_Demo
//
//  Created by 马慧莹 on 2018/11/3.
//  Copyright © 2018 magic. All rights reserved.
//

import UIKit

class MYEmojiIndictorPackView: UICollectionView,UICollectionViewDelegate,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    private let cellID = "CollectionCellIdentifier"
    
    private let data = MYMatchingEmojiManager.share.allEmojiPackages
    

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    
        super.init(frame: frame, collectionViewLayout: layout)
        
        backgroundColor = .clear
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        delegate = self
        dataSource = self
        register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
    }
    

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.contentView.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        let model = data[indexPath.row]
        
        let button = UIButton(frame: cell.contentView.bounds)
        button.indicatorType = .Right
        button.indicatorColor = MYColorForRGB(209, 209, 209)
        button.contentMode = .scaleAspectFit
        button.contentEdgeInsets = .init(top: 5, left: 5, bottom: 5, right: 5)
        button.setImage(UIImage.image(name: model.emojiPackageName!, path: "emoji"), for: .normal)
        button.backgroundColor = .clear
        if model.isSelect {
            button.backgroundColor = MYColorForRGB(244, 244, 244)
        }
        cell.contentView.addSubview(button)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: MYStickerSenderBtnHeight, height: MYStickerSenderBtnHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
