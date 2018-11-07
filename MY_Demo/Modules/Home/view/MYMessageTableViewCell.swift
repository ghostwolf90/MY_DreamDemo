//
//  MYMessageTableViewCell.swift
//  MY_Demo
//
//  Created by 马慧莹 on 2018/11/7.
//  Copyright © 2018 magic. All rights reserved.
//

import UIKit

class MYMessageTableViewCell: UITableViewCell {


    typealias clickBlcok = () -> Void
    
    private let head = UIImageView()
    private let bubbles = UIImageView()
    private let message = UILabel()
    private let voiceImageView = UIImageView()
    private let timeLabel = UILabel()
    private let keyID = "BubbleBreathLight"
    private (set) var isPlaying = false
    var handle: clickBlcok?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        head.backgroundColor = .red
        selectionStyle = .none
        message.numberOfLines = 0
        contentView.addSubview(head)
        contentView.addSubview(bubbles)
        bubbles.addSubview(message)
        contentView.backgroundColor = MYColorForRGB(239, 243, 246)
        bubbles.addSubview(voiceImageView)
        voiceImageView.contentMode = .scaleAspectFit
        voiceImageView.animationDuration = 1.2
        voiceImageView.isHidden = true
        voiceImageView.animationImages = [UIImage(named: "wechatvoice4_0"),UIImage(named: "wechatvoice4_1"),UIImage(named: "wechatvoice4")] as? [UIImage]
        voiceImageView.image = UIImage(named: "wechatvoice4")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickEvent))
        bubbles.addGestureRecognizer(tapGesture)
        bubbles.isUserInteractionEnabled = true
        contentView.addSubview(timeLabel)
        timeLabel.isHidden = true
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        timeLabel.textAlignment = .center
        timeLabel.textColor = .lightGray
    }
    
    func updataFrame(_ model: MYMessageModel)  {
        timeLabel.isHidden = true
        voiceImageView.isHidden = true
        var image = UIImage(named: "chat_receiver_bg")
        message.frame = .init(x: 15, y: 6, width: model.frame.width - 15, height: model.frame.height - 15)
        message.isHidden = false
        if model.isVoice {
            
            message.isHidden = true
            if model.time == 0 {
                addAlphaAnimation()
            }else{
                timeLabel.isHidden = false
                voiceImageView.isHidden = false
                voiceImageView.frame = CGRect.init(x: model.frame.width - 10 - 15, y: 8, width: 12, height: 20)
                timeLabel.frame = CGRect.init(x: model.frame.origin.x - 5 - 30, y:model.frame.origin.y + 8.0, width: 30, height: 20)
                timeLabel.text = "\(model.time)\""
                removeAnimation()
            }
        }
        if model.source == 0 {
            head.image = UIImage(named: "other")
            //别人
            head.frame = .init(x: 12, y: 10, width: 35, height: 35)
            bubbles.frame = model.frame
        }else{
            head.image = UIImage(named: "my")
            image = UIImage(named: "chat_sender_bg")
            bubbles.frame = model.frame
            head.frame = .init(x: bubbles.my.right + 10, y: 10, width: 35, height: 35)
        }
        let make = UIEdgeInsets.init(top: image!.size.height * 0.8 - 1.0, left: image!.size.width * 0.5, bottom: image!.size.height * 0.2, right: image!.size.width * 0.5 - 1.0)
        bubbles.image = image?.resizableImage(withCapInsets: make, resizingMode: .stretch)
        message.attributedText = model.attribute
    }
    
    private func addAlphaAnimation () {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = NSNumber.init(value: 1.0)
        animation.toValue = NSNumber.init(value: 0.2)
        animation.autoreverses = true
        animation.duration = 1.0
        animation.repeatCount = MAXFLOAT
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        bubbles.layer.add(animation, forKey: keyID)
    }
    
    private func removeAnimation() {
        bubbles.layer.removeAnimation(forKey: keyID)
    }
    
    func playAnimation(){
        self.isPlaying = true
        voiceImageView.startAnimating()
    }
    
    func stopAnimation()  {
        self.isPlaying = false
        voiceImageView.stopAnimating()
    }
    @objc func clickEvent(){
        self.handle?()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
