//
//  MYPHybridCache.swift
//  MYPCache
//
//  Created by 王智刚 on 2017/11/2.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import UIKit

public class MYPHybridCache {
    private let diskCahe: MYPDiskCache
    private let memoryCahe: MYPMemoryCache
    
    init(diskCahe: MYPDiskCache, memoryCahe: MYPMemoryCache) {
        self.diskCahe = diskCahe
        self.memoryCahe = memoryCahe
    }
}

extension MYPHybridCache: MYPStorageProtocol {
    public func wapper<T>(ofType type: T.Type, forKey key: String) throws -> MYPCacheWrapper<T> where T : Decodable, T : Encodable {
        do {
            return try memoryCahe.wapper(ofType: type, forKey: key)
        } catch {
            let warpper = try self.diskCahe.wapper(ofType: type, forKey: key)
            self.memoryCahe.setObject(object: warpper.object, forKey: key)
            return warpper
        }
    }
    
    public func setObject<T>(object: T, forKey key: String, expiry: MYPCahceExpiry?) throws where T : Decodable, T : Encodable {
        try self.diskCahe.setObject(object: object, forKey: key, expiry: expiry)
        self.memoryCahe.setObject(object: object, forKey: key, expiry: expiry)
    }
    
    public func removeObejct(forKey key: String) throws {
        try self.diskCahe.removeObejct(forKey: key)
        self.memoryCahe.removeObejct(forKey: key)
    }
    
    public func removeExpiredObjects() throws {
        try self.diskCahe.removeExpiredObjects()
        self.memoryCahe.removeExpiredObjects()
    }
    
    public func removeAll() throws {
        try self.diskCahe.removeAll()
        self.memoryCahe.removeAll()
    }
}
