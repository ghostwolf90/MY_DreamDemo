//
//  ViewController.swift
//  MY_Demo
//
//  Created by 马慧莹 on 2018/9/14.
//  Copyright © 2018年 magic. All rights reserved.
//

import UIKit
import Kingfisher
import MYEasyHUDSDK


class ViewController: UIViewController {

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
        let height = inputView.heightWithFit()
        
 
        inputView.frame = CGRect.init(x: 0, y: MYSCREEN_HEIGHT  - MYSafeAreaHeight - height, width: UIScreen.main.bounds.width, height: height)
        inputView.initFrame = inputView.frame
        
        
        
        self.view.addSubview(inputView)
        
//
//        let imageView = UIImageView(frame: .init(x: 50, y: 50, width: 100, height: 100));
//        imageView.backgroundColor = .red
//        self.view.addSubview(imageView)
//        let path = Bundle.main.path(forResource: "loading", ofType: "gif")
//        let imageResource = ImageResource.init(downloadURL: URL.init(fileURLWithPath: path!))
//        imageView.kf.setImage(with: imageResource)
        
        
        
    }
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

