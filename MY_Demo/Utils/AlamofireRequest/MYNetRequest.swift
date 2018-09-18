//
//  MYNetRequest.swift
//  MY_Demo
//
//  Created by 马慧莹 on 2018/9/18.
//  Copyright © 2018年 magic. All rights reserved.
//

import UIKit
import RxSwift
import Moya
import Alamofire

let dispose = DisposeBag()

public final class MYNetRequest: NSObject {

    var provider : MoyaProvider<ApiManager>
    

    override init() {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        let policies: [String: ServerTrustPolicy] = [
            
            "ap.grtstar.cn": .disableEvaluation
        ]
        let manager = Alamofire.SessionManager(configuration: configuration,serverTrustPolicyManager: ServerTrustPolicyManager(policies: policies))
        
        manager.startRequestsImmediately = false
        
        self.provider = MoyaProvider<ApiManager>(plugins: [networkActivityPlugin,MYRequestLoadingPlugin()])
        
    }
    
    public func request(_ token : Moya.TargetType, callbackQueue: DispatchQueue? = nil)  {
        
        
        self.provider.rx.request(token as! ApiManager, callbackQueue: callbackQueue).asObservable()
            .mapString().subscribe(onNext: { (s) in
                print(s)
            }, onError: { (e) in
                print(e)
            }).disposed(by: dispose)
        
        
    }
    
}
