//
//  MYVoiceTouchView.swift
//  MY_Demo
//
//  Created by 马慧莹 on 2018/10/26.
//  Copyright © 2018 magic. All rights reserved.
//

import UIKit
import AVFoundation
class MYVoiceTouchView: UIView {
    
    var slidArea : CGFloat = -MYKeyboardSpace20
    private var isUpSlide : Bool = false
    private var timeCount : NSInteger = 0
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    func addSubviews()  {
        layer.masksToBounds = true
        layer.cornerRadius = MYKeyboardSpace5
        layer.borderWidth = 0.5
        layer.borderColor = MYColorForRGB(219, 219, 219).cgColor
        addSubview(self.voiceButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.voiceButton.frame = self.bounds
    }
    
    // MARK: - 响应方法
    
    @objc private func voiceButtontnLong(_ gestureRecognizer : UILongPressGestureRecognizer){
        if gestureRecognizer.state ==  .began{
            let authStatus = AVCaptureDevice.authorizationStatus(for: .audio)
            if authStatus == .notDetermined {
                //初始化录音机
                return
            }
            if authStatus == .denied {
                //提示开启麦克风
                let rootControl = UIApplication.shared.delegate?.window!?.rootViewController
                let control = topViewControlWithRootViewControler(rootControl)
                let tipContoler = UIAlertController(title: "麦克风权限未开启", message: "麦克风权限未开启，请进入系统【设置】>【隐私】>【麦克风】中打开开关,开启麦克风功能", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                let okAction = UIAlertAction(title: "去开启", style: .default) { (action) in
                    UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
                }
                tipContoler.addAction(cancelAction)
                tipContoler.addAction(okAction)
                control.present(tipContoler, animated: true)
                return
            }
            beganEvent()
            self.isUpSlide = false
            //开启定时器
            self.timer.fire()
            //展示HUD视图
        }else if (gestureRecognizer.state == .ended){
            voiceEndEvent()
        }
        if self.voiceButton.isSelected {
            let point = gestureRecognizer.location(in: self.voiceButton)
            if point.y > self.slidArea {
                self.isUpSlide = false
            }else{
                //上滑
                self.isUpSlide = true
            }
            
        }
    }
    
    @objc private func timeEvent(){
        if self.timeCount == 1 {
            //开始录音
        }
        self.timeCount += 1
        if self.timeCount == 61 {
            //时间到,结束录音
            invalidateTimeer()
        }
    }
    
    // MARK: - 私有方法
    
    private func beganEvent() {
        self.voiceButton.isSelected = true
        self.voiceButton.backgroundColor = MYColorForRGB(181, 182, 186)
        layer.borderColor = MYColorForRGB(181, 182, 186).cgColor
    }
    
    private func endEvent() {
        self.voiceButton.isSelected = false
        self.voiceButton.backgroundColor = .white
        layer.borderColor = MYColorForRGB(219, 219, 219).cgColor
    }
    
    private func voiceEndEvent() {
        
        if self.timeCount <= 1 {
            //时间太短
        }else{
            if self.isUpSlide {
                //上滑取消
            }else{
                //触摸结束
            }
        }
        invalidateTimeer()
    }
    
    
    
    private func invalidateTimeer() {
        self.timer.invalidate()
        self.timeCount = 0
        //隐藏HUD
        endEvent()
    }
    
    // MARK: - 懒加载
    
    private lazy var voiceButton : UIButton = {
        let button = UIButton.init(type: .custom)
        
        button.backgroundColor = .white
        button.setTitle("按住 说话", for: .normal)
        button.setTitle("松开 结束", for: .selected)
        button.setTitleColor(MYColorForRGB(92, 92, 92), for: .normal)
        button.setTitleColor(MYColorForRGB(92, 92, 92), for: .selected)
        button.titleLabel?.font = UIFont.init(name: "Helvetica-Bold", size: 17)
        let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(voiceButtontnLong(_:)))
        longPress.minimumPressDuration = 0.3
        button.addGestureRecognizer(longPress)
        return button
    }()
    
    private lazy var timer : Timer = {
        let timer = Timer(timeInterval: 1.0, target: self, selector: #selector(timeEvent), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .default)
        return timer
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
