//
//  MYEmojiIndictorPackView.swift
//  MY_Demo
//
//  Created by 马慧莹 on 2018/11/3.
//  Copyright © 2018 magic. All rights reserved.
//

import UIKit

typealias SelectPacks = (_ index: NSInteger) -> Void

class MYEmojiIndictorPackView: UICollectionView,UICollectionViewDelegate,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    
    var  selectBlock : SelectPacks?
    private let cellID = "CollectionCellIdentifier"
    
    private let data = MYMatchingEmojiManager.share.allEmojiPack
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    
        super.init(frame: frame, collectionViewLayout: layout)
        let model = data.first
        model?.isSelect = true
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
        button.isUserInteractionEnabled = false
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        data.forEach { (model) in
            model.isSelect = false
        }
        let model = data[indexPath.row]
        if !model.isSelect {
            model.isSelect = true
            self.selectBlock?(indexPath.row)
            collectionView.reloadData()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
