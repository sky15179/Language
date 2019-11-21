//
//  MYPCacheSync.swift
//  MYPCache
//
//  Created by 王智刚 on 2017/11/2.
//  Copyright © 2017年 王智刚. All rights reserved.
//  同步缓存数据接口

import Foundation

public class MYPCacheSync {
    private let serialQueue: DispatchQueue
    private let internalCahce: MYPStorageProtocol
    
    init(cache: MYPStorageProtocol, serialQueue: DispatchQueue) {
        self.serialQueue = serialQueue
        self.internalCahce = cache
    }
}

extension MYPCacheSync: MYPStorageProtocol {
    public func wapper<T>(ofType type: T.Type, forKey key: String) throws -> MYPCacheWrapper<T> where T : Decodable, T : Encodable {
        var warpper: MYPCacheWrapper<T>!
        try serialQueue.sync {
           warpper = try self.internalCahce.wapper(ofType: type, forKey: key)
        }
        return warpper
    }
    
    public func setObject<T>(object: T, forKey key: String, expiry: MYPCahceExpiry? = nil) throws where T : Decodable, T : Encodable {
        try serialQueue.sync {
            try self.internalCahce.setObject(object: object, forKey: key, expiry: expiry)
        }
    }
    
    public func removeObejct(forKey key: String) throws {
        try serialQueue.sync {
            try self.internalCahce.removeObejct(forKey: key)
        }
    }
    
    public func removeExpiredObjects() throws {
        try serialQueue.sync {
            try self.internalCahce.removeExpiredObjects()
        }
    }
    
    public func removeAll() throws {
        try serialQueue.sync {
            try self.internalCahce.removeAll()
        }
    }
}
