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



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
     
        let provider = MYNetRequest()
        
        provider.request(ApiManager.testHome)
        
        
        
    }
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

