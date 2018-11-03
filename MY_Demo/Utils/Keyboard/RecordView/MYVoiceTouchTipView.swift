//
//  MYVoiceTouchTipView.swift
//  MY_Demo
//
//  Created by magic on 2018/10/29.
//  Copyright © 2018 magic. All rights reserved.
//

import UIKit

class MYVoiceTouchTipView: UIView {
    
    private let imageArray : [String] = ["voice1","voice2","voice3","voice4","voice5","voice6"]
    private var showLevel : Bool = false
    init() {
        super.init(frame: .zero)
        addsubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addsubviews()
    }
    
    private func addsubviews() {
        isHidden = true
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        layer.masksToBounds = true
        layer.cornerRadius = 5
        self.height = 140.0
        self.width = 140.0
        addSubview(self.imageView)
        addSubview(self.tipLabel)
    }
    
    // MARK: - 公开方法
    
    public func showView() {
        isShowCancel()
        isHidden = false
    }
    
    public func hiddenView() {
        isHidden = true
    }
    
    public func isShowCancel(_ isCancel : Bool = false) {
        self.showLevel = isCancel
        if isCancel {
            imageView.image = UIImage.init(named: "loosen")
            tipLabel.text = "松开手指,取消发送"
            tipLabel.font = UIFont.init(name: "Helvetica-Bold", size: 14)
            tipLabel.backgroundColor = MYColorForRGB(145, 63, 58)
        }else{
            tipLabel.text = "手指上滑,取消发送"
            tipLabel.backgroundColor = .clear
            tipLabel.font = UIFont.systemFont(ofSize: 14)
        }
    }
    
    public func showSoundlevel( level : inout NSInteger) {
        if !self.showLevel {
            if (level >= self.imageArray.count - 1) {
                level = self.imageArray.count - 1;
            }
            imageView.image = UIImage.init(named: self.imageArray[level])
        }
    }
    
    public func showTimeShort() {
        tipLabel.font = UIFont.systemFont(ofSize: 14)
        tipLabel.backgroundColor = .clear
        tipLabel.text = "说话时间太短"
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {[weak self] in
            self?.hiddenView()
        }
    }
    
    // MARK: - 懒加载
    
    private lazy var imageView : UIImageView = {
        let view = UIImageView(image: UIImage(named: "voice1"))
        view.contentMode = .scaleAspectFit
        let width : CGFloat = 60
        view.frame = CGRect(x: (self.width - width)/2.0, y: width/2.5, width: width, height: width)
        return view
    }()
    
    private lazy var tipLabel : UILabel = {
        let label = UILabel()
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 2
        label.text = "手指上滑,取消发送"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.frame = CGRect(x: 15.0/2.0, y: self.height - 30.0, width: self.width - 15.0, height: 20.0)
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
