//
//  MYPCacheWrapper.swift
//  MYPCache
//
//  Created by 王智刚 on 2017/10/23.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import Foundation

/// 缓存对象的容器,用来封装缓存对象相关的配置信息
public struct MYPCacheWrapper<T: Codable> {
    public typealias Info = [String: Any]
    public let object: T
    public let expiry: MYPCahceExpiry
    public let meta: Info
    
    init(object: T, expiry: MYPCahceExpiry, meta: Info = [:]) {
        self.object = object
        self.expiry = expiry
        self.meta = meta
    }
}
