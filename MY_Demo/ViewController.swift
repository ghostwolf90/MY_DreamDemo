//
//  ViewController.swift
//  MY_Demo
//
//  Created by 马慧莹 on 2018/9/14.
//  Copyright © 2018年 magic. All rights reserved.
//

import UIKit
 



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
     self.view.backgroundColor = .white
//        let parm = ["courseId":"158","uuId":"4302A11D-8BC4-4618-90EF-4ACCAED84D7C","userId":"2"]
        var custom = MYCustomRequest()
        custom.isSave = true
//        custom.parameter = parm
        let provider = MYNetRequest(custom)
        
        provider.request(ApiManager.testHome).subscribe(onNext: { (result) in
            print(result)
        }, onError: { (error) in
            print(error)
        }, onCompleted: {
            print("完成!!")
        }).disposed(by: dispose)
        
        let inputView = MYKeyboardInputView()
        let height = inputView.heightWithFit()
        //        inputView.frame = CGRect.init(x: 0, y: MYSCREEN_HEIGHT - MYTopHeight - MYSafeAreaHeight - height, width: MYSCREEN_WIDTH, height: height)
        var bottom : CGFloat = 0.0
        if #available(iOS 11.0, *) {
            bottom =  (UIApplication.shared.delegate?.window??.safeAreaInsets.bottom)!
        }
        let top = UIApplication.shared.statusBarFrame.height
        inputView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height)
        inputView.initFrame = inputView.frame
        
        
        let view = UIView.init(frame: CGRect.init(x: 0, y: 100, width: UIScreen.main.bounds.width, height: height))
        self.view.addSubview(view)
        
        view.addSubview(inputView)
        
    }
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

