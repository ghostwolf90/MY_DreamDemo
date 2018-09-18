//
//  TestModel.swift
//  MY_Demo
//
//  Created by 马慧莹 on 2018/9/18.
//  Copyright © 2018年 magic. All rights reserved.
//

import UIKit
 

class TestModel: Mappable {
    
    var id : String = ""
    var title : String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        
        id <- (map["id"], IntTransString)
        title <- map["title"]
    }
    

}
