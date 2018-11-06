//
//  MYAudioRecorder.swift
//  MY_Demo
//
//  Created by magic on 2018/10/27.
//  Copyright © 2018 magic. All rights reserved.
//

import UIKit
import AVFoundation

protocol MYAudioRecorderDelegate : NSObjectProtocol{
    func recordSoundLevel(_ level: NSInteger)
    func recordFileSuccess(path: String,time: NSInteger,name: String)
    func recordFileFaile(name: String)
}

class MYAudioRecorder: NSObject,AVAudioRecorderDelegate{
    
    /// 设置录音格式 默认kAudioFormatLinearPCM
    var formatIDKey : AudioFormatID = kAudioFormatLinearPCM
    /// 设置录音采样率(Hz) 8000/44100/96000（影响音频的质量） 默认 44100
    var sampleRateKey : NSInteger = 44100
    /// 录音通道数  1 或 2 默认为2
    var channelsKey : NSInteger = 2
    /// 线性采样位数  8、16、24、32 默认 16
    var bitDepthKey : NSInteger = 16
    /// 录音的质量 默认QualityMin
    var qualityKey : AVAudioQuality = .min
    /// 是否录制完毕后 转 mp3 默认: 边录边转
    var isEndRecord_MP3 : Bool = false
    /// 判断当前录音机状态
    private(set) var isRecording : Bool = false
    /// 获取文件名
    private(set) var fileName : String?
    /// 录音机代理
    weak var delegate : MYAudioRecorderDelegate?
    /// 缓存路径
    private var cachePath : String?
    
    private var mp3Path : String = ""
    private var cafPath : String = ""
    /// 检测声波
    private var levelTimer : Timer?
    /// 录音机
    private var audioRecorder : AVAudioRecorder?
    /// 声波等级
    private var lowPassResults : CGFloat = 0
    init(cachePath : String?) {
        super.init()
        if cachePath == nil {
            self.cachePath = cachePath
        }
        
    }
    
    override init() {
        super.init()
        
    }
    
    //MARK: 公开方法
    
    /// 开始录音
    public func record() {
        //判断是否有声音播放
        if !self.isRecording {
            recordSessionModel()
            self.isRecording = true
            //创建一个录音机,并开始录音
            if self.audioRecorder == nil {
                createRecord()
            }
            self.audioRecorder?.record()
            if !self.isEndRecord_MP3 {
                //边录边转
                MYConverAudioFile.sharedInstance().conventToMp3(withCafFilePath: self.cafPath, mp3FilePath: self.mp3Path, sampleRate: Int32(self.sampleRateKey)) {[weak self] (result) in
                    let fileManager = FileManager.default
                    if fileManager.fileExists(atPath: result.cafPath) {
                        print("回调 删除 caf 文件: \(result.cafPath)")
                        try? fileManager.removeItem(atPath: result.cafPath)
                    }
                    let resulePath = result.resultPath as NSString
                    let extenstionPanth = resulePath.lastPathComponent
                    let fileName = extenstionPanth.components(separatedBy: ".").first
                    if result.isSuccess {
                        let time =  MYEasyAduioPlayer.shared.getAudioDuration(with: URL.init(fileURLWithPath: result.resultPath))
                        self?.delegate?.recordFileSuccess(path: result.resultPath, time: time, name: fileName ?? "")
                    }else {
                        if !result.isCancel {
                            print("回调 MP3转换失败\n")
                            //删除转换的 mp3地址
                            if fileManager.fileExists(atPath: result.resultPath) {
                                print("回调 删除 mp3 文件: \(result.resultPath)")
                                try? fileManager.removeItem(atPath: result.resultPath)
                            }
                            self?.delegate?.recordFileFaile(name: fileName ?? "")
                        }
                    }
                     
                }
            }
            //打开定时器,监测声波
            self.levelTimer = createLevelTimer()
            self.levelTimer?.fire()
        }
        
    }
    
    public func stop() {
        self.isRecording = false
        self.levelTimer?.invalidate()
        self.levelTimer = nil
        self.audioRecorder?.stop()
    }
    
    public func cancelSend() {
        self.audioRecorder?.delegate = nil
        self.stop()
        self.audioRecorder = nil
        //取消转换
        MYConverAudioFile.sharedInstance().cancelSendEndRecord()
        playbackSessionModel()
        deleteLastRecord()
    }
    
    /// 删除最后录音文件
    public func deleteLastRecord() {
        deleteCafFile()
        deleteMP3File()
    }
    
    public func deinitRecored() {
        //取消发送
        cancelSend()
        //删除最后一次录音文件
        deleteLastRecord()
    }
    
    //MARK: 录音机代理
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            playbackSessionModel()
            self.audioRecorder = nil
            DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
             MYConverAudioFile.sharedInstance().sendEndRecord()
            }
        }
    }
    
    //MARK: 响应方法
    /// 监测录音机声波
    @objc private func levelTimerCallback(_ timer : Timer) {
        self.audioRecorder?.updateMeters()
        let peakPower = self.audioRecorder?.peakPower(forChannel: 0) ?? 0
        let result = powf(6.0, 0.05*peakPower)
        self.lowPassResults = CGFloat(0.5 * result) + 0.5 * self.lowPassResults
        let currentLevel = Int(lowPassResults/0.1)
        
        self.delegate?.recordSoundLevel(currentLevel)
        
    }
    
    //MARK: 私有方法
    
    /// 删除 caf 文件
    private func deleteCafFile() {
        let path = self.cafPath
        DispatchQueue.global().async {
            if FileManager.default.fileExists(atPath: path) {
                print("删除 caf 文件\(path)")
                try? FileManager.default.removeItem(atPath: path)
            }
        }
    }
    
    /// 删除 mp3文件
    private func deleteMP3File() {
        let path = self.mp3Path
        DispatchQueue.global().async {
            if FileManager.default.fileExists(atPath: path) {
                print("删除 mp3 文件\(path)")
                try? FileManager.default.removeItem(atPath: path)
            }
        }
    }
    
    /// 获取当前录音机生成的文件名 以时间戳为名字(毫秒)
    private func createFileName() -> String {
        let date = Date(timeIntervalSinceNow: 0)
        let timeInterval: TimeInterval = date.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return "\(millisecond)"
    }
    
    /// 生成定时器
    private func createLevelTimer() -> Timer {
        let timer = Timer.init(timeInterval: 0.2, target: self, selector: #selector(levelTimerCallback(_:)), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .default)
        return timer
    }
    
    //MARK: 创建录音机
    /// 改变 session 模式,创建录音机开始录音
    private func  createRecord () {
        
        do {
            self.audioRecorder = try AVAudioRecorder.init(url: setUpSavePath(), settings: getAudioSeting())
            self.audioRecorder?.delegate = self
            self.audioRecorder?.isMeteringEnabled = true
            self.audioRecorder?.prepareToRecord()
             
        } catch  {
            print("录音机创建失败")
        }
        
    }
    
    /// 切换为录音模式
    private func recordSessionModel() {
        let session = AVAudioSession.sharedInstance()
        if #available(iOS 10.0, *) {
            try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default)
        } else {
            // Fallback on earlier versions
            
        }
        try! session.setActive(true)
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
    
    //MARK: 获取录音文件存放路径
    /// 录音文件存放路径
    private func setUpSavePath() -> URL {
        guard let cachePaths = self.cachePath else {
            let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
            let fileSavePath = documentPath + "/" + "voiceRecordCache"
            let fileManager = FileManager.default
            if !fileManager.fileExists(atPath: fileSavePath) {
                try! fileManager.createDirectory(atPath: fileSavePath, withIntermediateDirectories: true, attributes: nil)
            }
            
            setCafPath(fileSavePath)
            return URL(fileURLWithPath: self.cafPath)
        }
        setCafPath(cachePaths)
        return URL(fileURLWithPath: self.cafPath)
    }
    
    /// 创建两个文件路径,便于转换
    private func setCafPath(_ rootPath : String) {
        self.fileName = createFileName()
        let cafFileName = "\(self.fileName!).caf"
        let mp3FileName = "\(self.fileName!).mp3"
        self.cafPath = rootPath + "/" + cafFileName
        self.mp3Path = rootPath + "/" + mp3FileName
    }
    
    //MARK: 获取录音机设置
    /// 录音机设置
    private func getAudioSeting() -> [String : Any]{
        var setting = [String : Any]()
        setting[AVFormatIDKey] = NSNumber(value: self.formatIDKey)
        setting[AVSampleRateKey] = NSNumber(value: self.sampleRateKey)
        setting[AVNumberOfChannelsKey] = NSNumber(value: self.channelsKey)
        setting[AVLinearPCMBitDepthKey] = NSNumber(value: self.bitDepthKey)
        setting[AVEncoderAudioQualityKey] = NSNumber(value: self.qualityKey.rawValue)
        return setting
    }
   
    //MARK: 懒加载
    
    

}
