//
//  MYObservable+ObjectMapper.swift
//  MY_Demo
//
//  Created by 马慧莹 on 2018/9/20.
//  Copyright © 2018年 magic. All rights reserved.
//

import Foundation
import RxSwift

extension Observable {
    
    func mapObject<T: Mappable>(type: T.Type) -> Observable<T> {
        return self.map { response in
            
            guard let dict = response as? [String: Any] else {
                throw RxSwiftMoyaError.ParseJSONError
            }
            guard (dict["success"] as?Bool) != nil else{
                throw RxSwiftMoyaError.ParseJSONError
            }
            
            return Mapper<T>().map(JSON: dict)!
        }
    }
    
    
    
}



enum RxSwiftMoyaError: String {
    case ParseJSONError
    case OtherError
}

extension RxSwiftMoyaError: Swift.Error {
    
    
}
