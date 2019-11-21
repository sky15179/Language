//
//  MYPCacheMemoryConfig.swift
//  MYPCache
//
//  Created by 王智刚 on 2017/11/1.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import Foundation

/// 内存缓存配置
struct MYPCacheMemoryConfig {
    /// 缓存过期限制
    let expiry: MYPCahceExpiry
    
    /// 缓存数量限制
    let countLimit: UInt
    
    /// 缓存占用内存限制
    let costLimit: UInt
    
    /// 在收到内存警告时是否删除内存缓存
    let shouldRemoveAllObjectsOnMemoryWarning: Bool
    
    /// 在进入后台时是否删除内存缓存
    let shouldRemoveAllObjectsWhenEnteringBackground: Bool
    
    init(expiry: MYPCahceExpiry = MYPCahceExpiry.never, countLimit: UInt = UInt.max, costLimit: UInt = UInt.max, shouldRemoveAllObjectsOnMemoryWarning: Bool = false, shouldRemoveAllObjectsWhenEnteringBackground: Bool = false) {
        self.expiry = expiry
        self.costLimit = costLimit
        self.countLimit = countLimit
        self.shouldRemoveAllObjectsOnMemoryWarning = shouldRemoveAllObjectsOnMemoryWarning
        self.shouldRemoveAllObjectsWhenEnteringBackground = shouldRemoveAllObjectsWhenEnteringBackground
    }
}
