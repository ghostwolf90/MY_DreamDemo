//
//  MYVoiceTouchView.swift
//  MY_Demo
//
//  Created by magic on 2018/10/26.
//  Copyright © 2018 magic. All rights reserved.
//

import UIKit
import AVFoundation

protocol MYVoiceTouchViewDelegate : NSObjectProtocol {
    
    /// 开始录音
    func touchBegan()
    /// 录音结束
    func touchEnd()
    /// 上滑取消
    func touchUpSlideEnd()
    /// 时间到,录音结束
    func touchTimeEnd()
    /// 录音时间太短
    func touchTimeShort()
    /// 发送录音事件
    func sendVoiceInteractionEvent()
    /// 是否展示取消
    func isShowCancen(_ isCancel : Bool)
}

class MYVoiceTouchView: UIView {
    
    /// 代理
    weak var delegate : MYVoiceTouchViewDelegate?
    /// 滑动距离,负数
    var slidArea : CGFloat = -MYKeyboardSpace20
    /// 是否滑动到上方,上滑取消判断
    private var isUpSlide : Bool = false
    /// 计时,1分钟
    private var timeCount : NSInteger = 0
    private var timer : Timer?
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(interruptionEvent(_:)), name: AVAudioSession.interruptionNotification, object: nil)//声音被打断,来电,闹铃等
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
                AVCaptureDevice.requestAccess(for: .audio) {(granted) in
                    if granted {
                        print("点击允许访问麦克风")
                    }else{
                        print("点击拒绝访问麦克风")
                    }
                }
                return
            }
            if authStatus == .denied {
                //提示开启麦克风
                let rootControl = UIApplication.shared.delegate?.window!?.rootViewController
                let control = my.topViewControlWithRootViewControler(rootControl)
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
            self.timer = createTimer()
            self.timer?.fire()
            //展示HUD视图
            self.delegate?.touchBegan()
        }else if (gestureRecognizer.state == .ended){
            if self.voiceButton.isSelected {
               voiceEndEvent()
            }
            
        }else if(gestureRecognizer.state == .changed){
            if self.voiceButton.isSelected {
                let point = gestureRecognizer.location(in: self.voiceButton)
                if point.y > self.slidArea {
                    self.isUpSlide = false
                }else{
                    //上滑
                    self.isUpSlide = true
                }
                self.delegate?.isShowCancen(self.isUpSlide)
            }
        }else if(gestureRecognizer.state == .cancelled || gestureRecognizer.state == .ended || gestureRecognizer.state == .failed){
            if self.voiceButton.isSelected {
                voiceEndEvent()
            }
        }
        
    }
    
    // MARK: - 响应方法
    
    /// 定时器响应
    @objc private func timeEvent(){
         
        if self.timeCount == 1 {
            //开始录音
            self.delegate?.sendVoiceInteractionEvent()
        }
        self.timeCount += 1
        if self.timeCount == 61 {
            //时间到,结束录音
            self.delegate?.touchTimeEnd()
            invalidateTimer()
        }
    }
    
    @objc private func interruptionEvent(_ notification: Notification) {
        if self.voiceButton.isSelected {
            voiceEndEvent()
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
    
    /// 触摸结束
    private func voiceEndEvent() {
        
        if self.timeCount <= 1 {
            //时间太短
            self.delegate?.touchTimeShort()
        }else{
            if self.isUpSlide {
                //上滑取消
                self.delegate?.touchUpSlideEnd()
            }else{
                //触摸结束
                self.delegate?.touchEnd()
            }
        }
        invalidateTimer()
    }
    
    /// 取消定时器,结束事件
    private func invalidateTimer() {
        self.timer?.invalidate()
        self.timer = nil
        self.timeCount = 0
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
        longPress.minimumPressDuration = 0.2
        button.addGestureRecognizer(longPress)
        return button
    }()
    
    //创建定时器
    private func createTimer() -> Timer{
        
        let timer = Timer(timeInterval: 1.0, target: self, selector: #selector(timeEvent), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .default)
        return timer
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
