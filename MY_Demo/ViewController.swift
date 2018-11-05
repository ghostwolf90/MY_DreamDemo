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
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
     self.view.backgroundColor = UIColor.lightGray
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
        let height = inputView.heightWithFit()
        
        inputView.frame = CGRect.init(x: 0, y: MYSCREEN_HEIGHT  - MYSafeAreaHeight - height, width: UIScreen.main.bounds.width, height: height)
        inputView.delegate = self
        inputView.initFrame = inputView.frame
        
        self.view.addSubview(inputView)
        
       
    }
    
    
    
    func keyboardOutPutAttribute(_ attribute: NSAttributedString) {
        print(attribute)
    }
    
    func recordFileSuccess(path: String, time: NSInteger, name: String) {
        print(time)
    }
    
    func recordFileFaile(name: String) {
        print(name)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

