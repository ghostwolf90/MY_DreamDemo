//
//  MYEmojiKeyboardView.swift
//  MY_Demo
//
//  Created by magic on 2018/9/26.
//  Copyright © 2018年 magic. All rights reserved.
//

import UIKit

protocol MYEmojiKeyboardViewDelegate : MYEmojiProtocolDelegate {
    func didSendButton()
}

class MYEmojiKeyboardView: UIView,MYEmojiPageScrollViewDelegate{
    
    weak var delegate : MYEmojiKeyboardViewDelegate?
    /// 顶部分割线
    private var line : UIView = UIView()
    /// 总数据
    private let emojiPacks = MYMatchingEmojiManager.share.allEmojiPackages
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    private func addSubviews() {
        backgroundColor = MYColorForRGB(244, 244, 244)
        self.line.frame = .init(x: 0, y: 0, width: width, height: 0.5)
        self.line.backgroundColor = MYColorForRGB(211, 211, 211)
        addSubview(self.line)
        addSubview(self.emojiScrollView)
        addSubview(self.pageControl)
        addSubview(self.bottomView)
        self.bottomView.addSubview(self.sendButton)
        self.bottomView.addSubview(self.indictorPackView)
        selectEmojiPack(with: 0)
        
    }
    
    override func layoutSubviews() {
        self.line.frame = .init(x: 0, y: 0, width: width, height: 0.5)
        self.emojiScrollView.frame = .init(x: 0, y: MYStickerTopSpace, width: width, height: MYStickerScrollerHeight)
        
        let viewHeight = MYStickerSenderBtnHeight + safeAreaBottom()
        self.bottomView.frame = .init(x: 0, y: self.height - viewHeight, width: width, height: viewHeight)
        self.sendButton.frame = .init(x: width - MYStickerSenderBtnWidth, y: 0, width: MYStickerSenderBtnWidth, height: MYStickerSenderBtnHeight)
    }
    
    // MARK: - 代理方法
    
    func didClickEmoji(with model: MYEmojiModel) {
        self.delegate?.didClickEmoji(with: model)
        
    }
    
    func didClickDelete() {
        self.delegate?.didClickDelete()
        
    }
    
    func scroll(with start: Int, end: Int,progress: CGFloat){
        
        self.pageControl.scroll(start: start, end: end, progress: progress)
    }
    
    // MARK: - 响应方法
    
    @objc private func sendEvent(){
        self.delegate?.didSendButton()
         
    }
    
    
    // MARK: - 私有方法
    
    /// 先获取当前表情包下的总 emoji 页数
    private func totlePage(with emojiNumber: NSInteger) -> NSInteger {
        let pageViewMaxEmojiCount = MYEmojiPageMaxRow * MYEmojiPageMaxColumn - 1//每一页有一个删除按钮
        let numberOfPage = (emojiNumber / pageViewMaxEmojiCount) + (emojiNumber % pageViewMaxEmojiCount == 0 ? 0 : 1)
        return numberOfPage
    }
    
    /// 选择哪个表情包
    private func selectEmojiPack(with index: NSInteger) {
        if index >= self.emojiPacks.count || index < 0 {
            return
        }
        let packModel = self.emojiPacks[index]
        createEmojiPage(packModel)
    }
    
    /// 按照每页的表情数分割表情包
    private func createEmojiPage(_ model: MYEmojiPackageModel){
        guard let emojis = model.emojis else {
            print("没有表情啊")
            return
        }
        let totle = totlePage(with: emojis.count)
        var emojiPages = Array<MYEmojiPageView>()
        self.pageControl.totlePage(totle)
        self.pageControl.center = self.center
        self.pageControl.y = self.emojiScrollView.bottom + MYStickerControlPageTopBottomSpace
        for index in 0..<totle {
             
            //根据下标挑选对应页的数据
            guard let emojiArray = selectEmojiData(with: index, emojis: emojis) else {
                return
            }
            let page = MYEmojiPageView(frame: self.bounds, emojis: emojiArray)
            emojiPages.append(page)
        }
        self.emojiScrollView.data = emojiPages
        
    }
    
    /// 筛选每页表情的数据
    private func selectEmojiData(with index: NSInteger, emojis: Array<MYEmojiModel>) ->Array<MYEmojiModel>? {
        if emojis.count == 0 {
            return nil
        }
        let totle = totlePage(with: emojis.count)
        let isLastPage = index == totle - 1 ? true : false
        let maxEmojiCount = MYEmojiPageMaxRow * MYEmojiPageMaxColumn - 1//每一页有一个删除按钮
        let beginIndex = index * maxEmojiCount
        let length = isLastPage ? (emojis.count - index * maxEmojiCount) : maxEmojiCount
        
        let emojiArray = emojis[beginIndex..<(beginIndex+length)]
        return Array(emojiArray)
        
    }
    
    // MARK: - 懒加载
    
    private lazy var emojiScrollView : MYEmojiPageScrollView = {
        let view = MYEmojiPageScrollView(frame: .init(x: 0, y: MYStickerTopSpace, width: width, height: MYStickerScrollerHeight))
        view.scrollDelegate = self
        return view
    }()
    
    private lazy var pageControl : MYPageControlView = {
        let control = MYPageControlView()
        return control
    }()
    
    private lazy var sendButton : UIButton = {
        let button = UIButton(frame: .init(x: width - MYStickerSenderBtnWidth, y: 0, width: MYStickerSenderBtnWidth, height: MYStickerSenderBtnHeight))
        button.indicatorType = .Left
        button.indicatorColor = MYColorForRGB(209, 209, 209)
        button.setTitle("发送", for: .normal)
        button.setTitleColor(MYColorForRGB(62, 131, 229), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(sendEvent), for: .touchUpInside)
        return button
    }()
    
    private lazy var bottomView : UIView = {
        let viewHeight = MYStickerSenderBtnHeight + safeAreaBottom()
        let view = UIView(frame: .init(x: 0, y: self.height - viewHeight, width: width, height: viewHeight))
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var indictorPackView : MYEmojiIndictorPackView = {
        let flaowLayout = UICollectionViewFlowLayout()
        flaowLayout.scrollDirection = .horizontal
        flaowLayout.itemSize = .init(width: MYStickerSenderBtnHeight, height: MYStickerSenderBtnHeight)
        let view = MYEmojiIndictorPackView(frame: .init(x: 0, y: 0, width: width - MYStickerSenderBtnWidth, height: MYStickerSenderBtnHeight), collectionViewLayout: flaowLayout)
        return view
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
