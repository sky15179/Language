//
//  ZGBase.swift
//  data-Base-exercises
//
//  Created by 王智刚 on 2017/7/1.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import Foundation
import UIKit

public typealias Image = UIImage

/// 自己的库的通用表达式
public final class ZGBase<Base> {
    public let base:Base
    public init(_ base:Base) {
        self.base = base
    }
}


/// 通过兼容类来拓展自己的库
public protocol ZGBaseCompatible {
    associatedtype CompatibleType
    var zg:CompatibleType { get }
}

public extension ZGBaseCompatible{
    
    /// 默认实现协议来提供类型和具体实例的通用能力,通用类的前缀表达式
    public var zg:ZGBase<Self>{
        get {return ZGBase(self)}
    }
}

// MARK: - 具体使用
extension Image:ZGBaseCompatible{}
