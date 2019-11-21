//
//  MYPCache.swift
//  MYPCache
//
//  Created by 王智刚 on 2017/10/22.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import Foundation


class MYPCahe {
    
    //MARK: Porperty - Private
    
    private let internalCache: MYPStorageProtocol
    private let sync: MYPCacheSync
    public lazy var async: MYPCacheAsync = MYPCacheAsync(cache: self.internalCache, queue: DispatchQueue(label: "Cahe.Async.ConcurrentQueue"))
    
    //MARK: LiftCycle
    
    /// 初始化内部缓存方式
    ///
    /// - Parameters:
    ///   - diskConfig: 开启磁盘缓存
    ///   - memoryConfig: 开启内存缓存
    /// cahce默认的缓存方法是同步执行的,如果要使用异步的方式,使用cache.async执行
    init(with diskConfig: MYPCacheDiskConfig, memoryConfig: MYPCacheMemoryConfig? = nil) throws {
        if let mConfig = memoryConfig {
            let diskCahe = try MYPDiskCache(with: diskConfig)
            let memoryCache = MYPMemoryCache(with: mConfig)
            self.internalCache = MYPHybridCache(diskCahe: diskCahe, memoryCahe: memoryCache)
        } else {
            self.internalCache = try MYPDiskCache(with: diskConfig)
        }
        self.sync = MYPCacheSync(cache: self.internalCache, serialQueue: DispatchQueue(label: "Cahe.Sync.SerialQueue"))
    }
}

extension MYPCahe: MYPStorageProtocol {
    
    public func wapper<T>(ofType type: T.Type, forKey key: String) throws -> MYPCacheWrapper<T> where T : Decodable, T : Encodable {
        return try self.sync.wapper(ofType: type, forKey: key)
    }
    
    public func setObject<T>(object: T, forKey key: String, expiry: MYPCahceExpiry? = nil) throws where T : Decodable, T : Encodable {
        try self.sync.setObject(object: object, forKey: key, expiry: expiry)
    }
    
    public func removeObejct(forKey key: String) throws {
        try self.sync.removeObejct(forKey: key)
    }
    
    public func removeExpiredObjects() throws {
        try self.sync.removeExpiredObjects()
    }
    
    public func removeAll() throws {
        try self.sync.removeAll()
    }
}
