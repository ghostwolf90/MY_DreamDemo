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

struct MYCustomRequest {
    var isSave : Bool = false
    var cacheTime : NSInteger = 5
    var isActivityIndicator : Bool = false
    var parameter : [String:Any]? = nil
    
}
 

public final class MYNetRequest: NSObject {

    var provider : MoyaProvider<ApiManager>
    var customRequest : MYCustomRequest

    init(_ custom : MYCustomRequest? = MYCustomRequest()) {
        self.customRequest = custom!
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        let policies: [String: ServerTrustPolicy] = [
            
            "ap.grtstar.cn": .disableEvaluation
        ]
        let manager = Alamofire.SessionManager(configuration: configuration,serverTrustPolicyManager: ServerTrustPolicyManager(policies: policies))
        
        manager.startRequestsImmediately = false
        /// 设置请求头,超时时间等
        if (custom?.isActivityIndicator)! {
           self.provider = MoyaProvider<ApiManager>(manager: manager,plugins: [networkActivityPlugin,MYRequestLoadingPlugin(self.customRequest)])
        }else{
            self.provider = MoyaProvider<ApiManager>(manager: manager,plugins: [MYRequestLoadingPlugin(self.customRequest)])
        }
        
    }
    
    @discardableResult
    public func request(_ token : Moya.TargetType, callbackQueue: DispatchQueue? = nil) -> Observable<Any> {
        return self.provider.rx.request(token as! ApiManager, callbackQueue: callbackQueue).asObservable()
            .mapJSON()
    }
    
    deinit {
        print("网络请求对象销毁!!!")
    }
    
}
