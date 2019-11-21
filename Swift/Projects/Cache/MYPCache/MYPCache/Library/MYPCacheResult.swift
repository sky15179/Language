//
//  MYPCacheResult.swift
//  MYPCache
//
//  Created by 王智刚 on 2017/11/7.
//  Copyright © 2017年 王智刚. All rights reserved.
//

public enum MYPCacheResult<T> {
    case value(T)
    case error(Error)
    
    public func map<U>(_ transform: (T) -> U) -> MYPCacheResult<U> {
        switch self {
        case .value(let value):
            return MYPCacheResult<U>.value(transform(value))
        case .error(let error):
            return MYPCacheResult<U>.error(error)
        }
    }
}
