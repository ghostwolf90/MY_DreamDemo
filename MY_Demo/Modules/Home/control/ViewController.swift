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
    
    private let tableView = MYAcceptListView(frame: .init(x: 0, y: 0, width: MYSCREEN_WIDTH, height: 300), style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = .white

        let inputView = MYKeyboardInputView()
        let height = inputView.defineHeight
        
        inputView.frame = CGRect.init(x: 0, y: MYSCREEN_HEIGHT - height, width: UIScreen.main.bounds.width, height: height)
        inputView.delegate = self
        inputView.initFrame = inputView.frame
        
        self.view.addSubview(inputView)
        tableView.backgroundColor = MYColorForRGB(239, 243, 246)
        self.view.addSubview(tableView)
        
        
    }
    
    
    func keyboardOutPutAttribute(_ attribute: NSAttributedString) {
        let string = MYMatchingEmojiManager.share.exchangePlainText(attribute)
        print(string!)
        tableView.addTextMessage(attribute)
       
    }
    
    func recordInit(_ name: String) {
        tableView.addVoiceBlankMessag(name)
    }
    
    func recordCancel(_ name: String) {
        tableView.cancelVoiceMessage(name)
    }
    
    func recordFileSuccess(path: String, time: NSInteger, name: String) {
        tableView.addVoiceMessage(path: path, time: time, name: name)
    }
    
    func recordFileFaile(name: String) {
        print(name)
        tableView.addVoiceBlankMessag(name)
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

