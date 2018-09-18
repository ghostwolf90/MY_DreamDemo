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


enum ApiManager {
    case testHome
    case testUser
}


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
            return "index/banner"
        default:
            return "index/banner"
            
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .testHome:
            return .post
            
        default:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
            
        default:
            return "".data(using: String.Encoding.utf8)!
        }
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        switch self {
         
        default:
            return nil
        }
    }
    
    var isShowNavigationHUD : Bool {
        switch self {
        
        default:
            return false
        }
    }
    
    var isSave: Bool {
        return false
    }
    
    var cashTime: NSInteger {
        return 0
    }
 
}

public extension TargetType {
    var isSave : Bool {
        return false
    }
    
    var cashTime: NSInteger {
        return 0
    }
    var isShowNavigationHUD : Bool {
        return false
    }
}
