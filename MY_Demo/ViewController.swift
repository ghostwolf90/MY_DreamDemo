//
//  ViewController.swift
//  MY_Demo
//
//  Created by 马慧莹 on 2018/9/14.
//  Copyright © 2018年 magic. All rights reserved.
//

import UIKit
import Moya
import RxSwift

let dispose = DisposeBag()

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
     
        let parm = ["courseId":"158","uuId":"4302A11D-8BC4-4618-90EF-4ACCAED84D7C","userId":"2"]
        var custom = MYCustomRequest()
        custom.isSave = true
        custom.parameter = parm
        let provider = MYNetRequest(custom)
        
        provider.request(ApiManager.testHome).subscribe(onNext: { (result) in
//            print(result)
        }, onError: { (error) in
//            print(error)
        }, onCompleted: {
            print("完成!!")
        }).disposed(by: dispose)
        
        
        
    }
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

