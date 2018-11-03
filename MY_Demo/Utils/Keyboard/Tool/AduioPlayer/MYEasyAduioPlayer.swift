//
//  MYEasyAduioPlayer.swift
//  MY_Demo
//
//  Created by magic on 2018/10/29.
//  Copyright © 2018 magic. All rights reserved.
//

import UIKit
import AVFoundation

enum MYAudioPlayerStatus {
    case unKown
    case playing
    case failed
    case pause
    case stop
    case finish
}

protocol MYEasyAudioPlayerDelegate : NSObjectProtocol {
    func changeStatus(_ status: MYAudioPlayerStatus)
}

class MYEasyAduioPlayer: NSObject {

    static let shared = MYEasyAduioPlayer()
    weak var delegate : MYEasyAudioPlayerDelegate?
    
    /// 获取状态
    private(set) var status : MYAudioPlayerStatus = .unKown
    /// 判断是否在播放状态
    private(set) var isPlaying : Bool = false
    /// 当前时间
    var currentTime : NSInteger {
        get{
            let time = self.player.currentTime()
            if time.timescale == 0 {
                return 0
            }
            
            return NSInteger(CMTimeValue(Int32(time.value) / time.timescale))
        }
        
    }
    /// 总时间
    var totleTime : NSInteger {
        get{
            let time = self.player.currentItem?.duration
            if time?.timescale == 0 {
                return 0
            }
            return NSInteger(CMTimeValue(Int32(time!.value) / time!.timescale))
        }
    }
    
    private var player : AVPlayer = AVPlayer()
    private var item : AVPlayerItem?
    private var playingURL : URL?
    
    
    private override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(sessionWasInterrupted(_:)), name: AVAudioSession.interruptionNotification, object: nil)//声音被打断,来电,闹铃等
        NotificationCenter.default.addObserver(self, selector: #selector(audioRouteChangeListen(_:)), name: AVAudioSession.routeChangeNotification, object: nil)//耳机拔插
    }
    
    
    /// 播放本地 url音频
    ///
    /// - Parameter voiceUrl: url
    public func play(with voiceUrl: URL) {
        playbackSessionModel()
        if self.playingURL != voiceUrl {
            //第一次或者另一个
            removeItem()
            //设置播放器
            setPlayer(with: voiceUrl)
            self.playingURL = voiceUrl
        }else {
            if status == .pause {
                resume()
            }else if status == .finish || status == .stop {
                seek(to: 0)
                resume()
            }
        }
    }
    
    /// 暂停
    public func pause() {
        self.isPlaying = false
        self.player.pause()
        self.status = .pause
        self.delegate?.changeStatus(self.status)
        playbackSessionModel()
    }
    
    /// 停止
    public func stop() {
        self.isPlaying = false
        self.player.pause()
        seek(to: 0)
        self.status = .stop
        self.delegate?.changeStatus(self.status)
        playbackSessionModel()
    }
    
    /// 继续播放
    public func resume() {
        self.isPlaying = true
        self.status = .playing
        self.player.play()
    }
    
    public func getAudioDuration(with url: URL) ->NSInteger {
        let audioAsset = AVURLAsset(url: url, options: nil)
        let audioDuration = audioAsset.duration
        var audioDurationSeconds = CMTimeGetSeconds(audioDuration) + 0.6
        if audioDurationSeconds <= 1.5 {
            audioDurationSeconds = 1.0
        }
        
        return NSInteger(audioDurationSeconds)
    }
    
    /// 移除 item
    private func removeItem(){
        if self.isPlaying {
            stop()
        }else if self.item != nil {
            itemRemoveObserver()
            self.item = nil
        }
    }
    
    /// 设置 play
    private func setPlayer(with Url: URL){
        if Url.absoluteString == "" {
            print("链接为空")
            return
        }
        let item = AVPlayerItem(url: Url)
        if self.item == nil {
            self.player = AVPlayer.init(playerItem: item)
        }else{
            //已存在,移除
            itemRemoveObserver()
            self.item = nil
            self.player.replaceCurrentItem(with: item)
        }
        self.item = item
        NotificationCenter.default.addObserver(self, selector: #selector(playFinished(_:)), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: self.item)
        resume()
    }
    
    /// 移除 item 监听
    private func itemRemoveObserver() {
        if self.item != nil {
            NotificationCenter.default.removeObserver(self, name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: self.item)
        }
    }
    
    private func seek(to new : NSInteger) {
        var time = self.player.currentTime()
        time.value = CMTimeValue(time.timescale * Int32(new))
        self.player.seek(to: time)
    }
    
    /// Playback 模式
    private func playbackSessionModel() {
        let session = AVAudioSession.sharedInstance()
        if #available(iOS 10.0, *) {
            try! session.setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default)
        } else {
            // Fallback on earlier versions
            
        }
        try! session.setActive(true)
    }
    // MARK: - 通知响应方法
    
    @objc private func sessionWasInterrupted(_ notification: Notification) {
        if self.isPlaying {
            stop()
        }
    }
    
    @objc private func audioRouteChangeListen(_ notification: Notification) {
        let userInfo = notification.userInfo
        let routeChangeReason = userInfo?[AVAudioSessionRouteChangeReasonKey] as! UInt
        if routeChangeReason == AVAudioSession.RouteChangeReason.oldDeviceUnavailable.rawValue {
            if self.isPlaying {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {[weak self] in
                    self?.resume()
                }
            }
        }
        
    }
    
    @objc private func playFinished(_ nitification: Notification) {
        self.isPlaying = false
        self.status = .finish
        self.delegate?.changeStatus(self.status)
        playbackSessionModel()
    }
    
}
