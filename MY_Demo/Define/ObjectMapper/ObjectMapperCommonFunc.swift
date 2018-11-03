//
//  ObjectMapperCommonFunc.swift
//  MY_Demo
//
//  Created by magic on 2018/9/18.
//  Copyright © 2018年 magic. All rights reserved.
//

import Foundation
@_exported import ObjectMapper


let IntTransString = TransformOf<String,Int>(fromJSON: { (value) -> String? in
    if let value = value {
        return String(value)
    }
    return nil
}) { (value) -> Int? in
    return Int(value!)
}


let StingTransInt = TransformOf<Int,String>(fromJSON: { (value) -> Int? in
    return Int(value!)
}) { (value) -> String? in
    if let value = value {
        return String(value)
    }
    return nil
}


