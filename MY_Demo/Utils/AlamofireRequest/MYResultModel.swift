//
//  MYResultModel.swift
//  MY_Demo
//
//  Created by magic on 2018/9/20.
//  Copyright © 2018年 magic. All rights reserved.
//

import UIKit

class MYResultModel: Mappable {
    
    var message : String?
    var success : Bool?
    var entity : [String:Any]?
    
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        message <- map["message"]
        success <- map["success"]
        entity <- map["entity"]
    }

}
