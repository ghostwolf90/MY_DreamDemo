//
//  MYExtenstionDefine.swift
//  MY_Demo
//
//  Created by 马慧莹 on 2018/11/7.
//  Copyright © 2018 magic. All rights reserved.
//

import Foundation
import UIKit

public protocol MYCompatible {
    associatedtype MYCompatibleType
    var my : MYCompatibleType { get }
    
}

public final class MYExtension<myBase>: MYCompatible {
    public let my: myBase
    public init(_ my:myBase) {
        self.my = my
    }
}

public extension MYCompatible {
    public var my:MYExtension<Self>{
        return MYExtension(self)
    }
}
