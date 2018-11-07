//
//  ViewController.swift
//  MY_Demo
//
//  Created by magic on 2018/9/14.
//  Copyright © 2018年 magic. All rights reserved.
//

import UIKit
import Kingfisher
import MYEasyHUDSDK


class ViewController: UIViewController,MYKeyboardInputViewDelegate {
    
    var tipLabel = UILabel()
    var playButton = UIButton()
    var playUrl = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = .white
        //        let parm = ["courseId":"158","uuId":"4302A11D-8BC4-4618-90EF-4ACCAED84D7C","userId":"2"]
        //        var custom = MYCustomRequest()
        //        custom.isSave = true
        ////        custom.parameter = parm
        //        let provider = MYNetRequest(custom)
        //
        //        provider.request(ApiManager.testHome).subscribe(onNext: { (result) in
        //            print(result)
        //        }, onError: { (error) in
        //            print(error)
        //        }, onCompleted: {
        //            print("完成!!")
        //        }).disposed(by: dispose)
        
        let inputView = MYKeyboardInputView()
        let height = inputView.defineHeight
        
        inputView.frame = CGRect.init(x: 0, y: MYSCREEN_HEIGHT - height, width: UIScreen.main.bounds.width, height: height)
        inputView.delegate = self
        inputView.initFrame = inputView.frame
         
        self.view.addSubview(inputView)
        
        tipLabel.frame = .init(x: 50, y: 80, width: 200, height: 50)
        tipLabel.backgroundColor = UIColor.lightGray
        self.view.addSubview(tipLabel)
        tipLabel.numberOfLines = 0
        playButton.setTitle("播放语音", for: .normal)
        self.view.addSubview(playButton)
        playButton.frame = .init(x: 270, y: 80, width: 80, height: 30)
        playButton.addTarget(self, action: #selector(playEvent), for: .touchUpInside)
    }
    
    @objc func playEvent(){
        MYEasyAduioPlayer.shared.play(with: URL.init(fileURLWithPath: self.playUrl))
    }
    
    func keyboardOutPutAttribute(_ attribute: NSAttributedString) {
        let string = MYMatchingEmojiManager.share.exchangePlainText(attribute)
        print(string!)
        tipLabel.attributedText = attribute
    }
    
    func recordFileSuccess(path: String, time: NSInteger, name: String) {
        
        self.tipLabel.text = "文件名:\(name),时长:\(time)"
        self.playUrl = path
    }
    
    func recordFileFaile(name: String) {
        print(name)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

