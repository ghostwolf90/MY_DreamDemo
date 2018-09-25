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

struct MYCustomRequest {
    var isSave : Bool = false
    var cacheTime : NSInteger = 5
    var isActivityIndicator : Bool = false
    var parameter : [String:Any]? = nil
    
}
 

public final class MYNetRequest: NSObject {

    var provider : MoyaProvider<ApiManager>
    var customRequest : MYCustomRequest

    init(_ custom : MYCustomRequest = MYCustomRequest()) {
        self.customRequest = custom

        /// 设置请求头,超时时间等
        if custom.isActivityIndicator {
           self.provider = MoyaProvider<ApiManager>(manager: Manager.default,plugins: [networkActivityPlugin,MYRequestLoadingPlugin(self.customRequest)])
        }else{
            self.provider = MoyaProvider<ApiManager>(manager: Manager.default,plugins: [MYRequestLoadingPlugin(self.customRequest)])
        }
        
    }
    
    @discardableResult
    func request(_ token : Moya.TargetType, callbackQueue: DispatchQueue? = .global()) -> Observable<MYResultModel> {
        
        return Observable<MYResultModel>.create({ (observer) -> Disposable in
            return self.provider.rx.request(token as! ApiManager, callbackQueue: callbackQueue)
                .asObservable()
                .mapJSON()
                .mapObject(type: MYResultModel.self).subscribe(onNext: { (result) in
                    DispatchQueue.global().async {
                        observer.onNext(result)
                        DispatchQueue.main.async {
                            observer.onCompleted()
                        }
                    }
                }, onError: { (error) in
                    DispatchQueue.main.async {
                        observer.onError(error)
                    }
                })
        })
        
        
    }
    
    
    
    deinit {
        print("网络请求对象销毁!!!")
    }
    
}

//        return Observable<Any>.create({ (observer) -> Disposable in
//            self.provider.rx.request(token as! ApiManager, callbackQueue: callbackQueue)
//                .asObservable()
//                .mapJSON()
//                .subscribe(onNext: { (result) in
//                    observer.onNext(result)
//                }, onError: { (error) in
//                    observer.onError(error)
//                }, onCompleted: {
//                    observer.onCompleted()
//                })
//
//        })
