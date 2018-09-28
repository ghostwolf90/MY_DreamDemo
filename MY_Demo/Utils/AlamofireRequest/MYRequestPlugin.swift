//
//  MYRequestPlugin.swift
//  MY_Demo
//
//  Created by 马慧莹 on 2018/9/18.
//  Copyright © 2018年 magic. All rights reserved.
//

/*
 * 网络请求插件
 */

import Foundation
import Moya
import Result

/// 设置网络请求导航栏小菊花
let networkActivityPlugin = NetworkActivityPlugin { (change, targeType) in

    
        switch(change){
            
        case .ended:
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
        case .began:
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
        }
    
    
}

func MYbase64(_ base64: String) -> String {
    guard let decodedData = base64.data(using: .utf8) else { return "" }
    
    return decodedData.base64EncodedString()
}

/// 此类不允许继承
public final class MYRequestLoadingPlugin: PluginType {
    var custom : MYCustomRequest
    
    init(_ custom : MYCustomRequest) {
        self.custom = custom
        ///初始化 hud
    }
    
    public func willSend(_ request: RequestType, target: TargetType) {
        print("请求开始")
        
        
    }
    
    
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        print("结束请求")
        DispatchQueue.global().async { [weak self] in
            
            if (self?.custom.isSave)! {
                switch result {
                case let .success(response):
                    var hostUrl = target.baseURL.absoluteString + target.path
                    if self?.custom.parameter != nil {
                        self?.custom.parameter?.forEach({ (arg) in
                            let (key, value) = arg
                            hostUrl = hostUrl.appendingFormat("&%@=%@", key,value as! CVarArg)
                        })
                    }
                    let base64 = MYbase64(hostUrl)
                    if FileManager.default.fileExists(atPath: cachePath) {
                        let filePath = cachePath + "/\(base64)"
                        print(filePath)
                        NSKeyedArchiver.archiveRootObject(response.data, toFile: filePath)
                    }
                   
                default:
                    break
                }
            }
        }
        
    }
    
    deinit {
        print("插件销毁!!!")
    }
}
