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

    if targeType.isShowNavigationHUD {
        switch(change){
            
        case .ended:
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
        case .began:
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
        }
    }
    
}

/// 此类不允许继承
public final class MYRequestLoadingPlugin: PluginType {
    init() {
        ///初始化一个 hud 做提示
        
    }
    
    public func willSend(_ request: RequestType, target: TargetType) {
        print("请求开始")
        
        
    }
    
    
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        print("结束请求")
        
        
    }
}
