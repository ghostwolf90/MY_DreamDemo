//
//  MYRecordHandled.swift
//  MY_Demo
//
//  Created by magic on 2018/10/29.
//  Copyright © 2018 magic. All rights reserved.
//

import UIKit

protocol MYRecordOutputDelegate : NSObjectProtocol {
    func recordInit(_ name: String)
    func recordFileSuccess(path: String, time: Int, name: String)
    func recordFileFaile(name: String)
    func recordCancel(_ name: String)
}

class MYRecordHandled: NSObject,MYVoiceTouchViewDelegate,MYAudioRecorderDelegate{
    
    weak var delegate : MYRecordOutputDelegate?
    private var audioRecord : MYAudioRecorder?
    
    // MARK: - touchView 代理
    
    func touchBegan() {
        print("开始录音")
        if self.audioRecord == nil {
            self.audioRecord = createRecorder()
        }
        self.audioRecord?.record()
        self.showView.showView()
    }
    
    func touchEnd() {
        print("结束录音")
        self.audioRecord?.stop()
        self.showView.hiddenView()
    }
    
    func touchUpSlideEnd() {
        print("上滑取消")
        self.delegate?.recordCancel(self.audioRecord!.fileName)
        self.audioRecord?.cancelSend()
        self.showView.hiddenView()
    }
    
    func touchTimeEnd() {
        print("时间到")
        
        self.audioRecord?.stop()
        self.showView.hiddenView()
    }
    
    func touchTimeShort() {
        print("时间太短")
        self.delegate?.recordInit(self.audioRecord!.fileName)
        self.audioRecord?.cancelSend()
        self.showView.showTimeShort()
    }
    
    func sendVoiceInteractionEvent() {
        print("录音已开始")
        self.delegate?.recordInit(self.audioRecord!.fileName)
    }
    
    func isShowCancen(_ isCancel: Bool) {
        self.showView.isShowCancel(isCancel)
    }
    
    // MARK: - 录音机代理
    
    func recordSoundLevel(_ level: NSInteger) {
        var temp = level
        self.showView.showSoundlevel(level: &temp)
    }
    
    func recordFileSuccess(path: String, time: NSInteger, name: String) {
        DispatchQueue.main.async {
            self.delegate?.recordFileSuccess(path: path, time: time, name: name)
        }
        
    }
    
    func recordFileFaile(name: String) {
        DispatchQueue.main.async {
            self.delegate?.recordFileFaile(name: name)
        }
    }
    
    // MARK: - 创建录音机
    
    private func createRecorder() ->MYAudioRecorder {
        let recorder = MYAudioRecorder()
        recorder.delegate = self
        return recorder
    }
    
    // MARK: - 懒加载
    
    private lazy var showView : MYVoiceTouchTipView = {
        let view = MYVoiceTouchTipView()
        let windows = UIApplication.shared.keyWindow!
        view.center = windows.center
        windows.addSubview(view)
        return view
    }()
    
}
