//
//  MYPCacheDiskConfig.swift
//  MYPCache
//
//  Created by 王智刚 on 2017/10/31.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import UIKit
import Foundation

/// 磁盘缓存配置
struct MYPCacheDiskConfig {
    
    let name: String
    
    /// 磁盘文件路径
    let directory: URL?
    
    /// 缓存对象数量限制,默认无限制
    let countLimit: UInt
    
    /// 缓存占用空间(单位:bytes),默认无限制
    let costLimit: UInt
    
    /// 有效期
    let expiry: MYPCahceExpiry
    
    init(name: String, directory: URL? = nil, countLimit: UInt = UInt.max, costLimit: UInt = UInt.max, expiry: MYPCahceExpiry = .never) {
        self.name = name
        self.directory = directory
        self.countLimit = countLimit
        self.costLimit = costLimit
        self.expiry = expiry
    }
}
