//
//  MYRequestApi.swift
//  MY_Demo
//
//  Created by 马慧莹 on 2018/9/18.
//  Copyright © 2018年 magic. All rights reserved.
//

/*
 * Moya 网络请求,各个接口配置,集中管理快捷方便
 */

import Foundation
import Moya

let cachePath = NSHomeDirectory() + "/Library/Caches" + "/MYLazyRequestCache"


enum ApiManager {
    case testHome
    case testUser([String:Any])
}

///执行代理
extension ApiManager : Moya.TargetType {
    
    
    var baseURL: URL {
        switch self {
        case .testHome:
            return URL.init(string: "http://t.268xue.com/app/")!
            
        default:
            return URL.init(string: "http://t.268xue.com/app/")!
            
        }
    }
    
    var path: String {
        switch self {
        case .testHome:
            return "course/info"
        default:
            return "course/info"
            
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .testHome:
            return .post
            
        default:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .testHome:
            return .requestParameters(parameters: ["courseId":"158","uuId":"4302A11D-8BC4-4618-90EF-4ACCAED84D7C","userId":"2"], encoding: URLEncoding.default)
        case .testUser(let paramete):
            return .requestParameters(parameters: paramete, encoding: URLEncoding.default)
            
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
  
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
 
}
 
