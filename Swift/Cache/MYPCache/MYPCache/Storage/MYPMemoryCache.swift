//
//  MYPMemoryCache.swift
//  MYPCache
//
//  Created by 王智刚 on 2017/10/22.
//  Copyright © 2017年 王智刚. All rights reserved.
//  内存缓存

import Foundation
import QuartzCore

internal class MYPMemoryCacheObject: MYPLRUObj{
    var key: String = ""
    var cost: UInt = 0
    var time: MYPCahceExpiry
    var value: Codable
    
    init(key: String, value: Codable, cost: UInt = 0, time: MYPCahceExpiry = .never) {
        self.key = key
        self.value = value
        self.cost = cost
        self.time = time
    }
    
    static func ==(lhs: MYPMemoryCacheObject, rhs: MYPMemoryCacheObject) -> Bool {
        return lhs.key == rhs.key
    }
}

final class MYPMemoryCache {
    public var didReceiveMemoryWarningClosure: ((MYPMemoryCache) -> Void)?
    public var didEnterBackgroundClosure: ((MYPMemoryCache) -> Void)?
    private let cache = MYPLRU<MYPMemoryCacheObject>()
    private let config: MYPCacheMemoryConfig
    
    public init(with config: MYPCacheMemoryConfig) {
        self.config = config

        NotificationCenter.default.addObserver(self, selector: #selector(_didReceiveMemoryWarningNotification), name: .UIApplicationDidReceiveMemoryWarning, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(_didEnterBackgroundNotification), name: .UIApplicationDidEnterBackground, object: nil)
    }
}

extension MYPMemoryCache: MYPStorageProtocol {
    public func wapper<T>(ofType type: T.Type, forKey key: String) throws -> MYPCacheWrapper<T> where T : Decodable, T : Encodable {
        guard let mObj = cache.object(forKey: key) else {
            throw MYPCacheError.notFound
        }
        
        guard let obj = mObj.value as? T else {
            throw MYPCacheError.typeNotMactch
        }
        
        let warpper = MYPCacheWrapper(object: obj, expiry: mObj.time)
        return warpper
    }
    
    public func setObject<T>(object: T, forKey key: String, expiry: MYPCahceExpiry? = nil) where T : Decodable, T : Encodable {
        let objc = MYPMemoryCacheObject(key: key, value: object, cost: 0, time: expiry ?? config.expiry)
        cache.set(object: objc, forKey: key)
        if cache.totalCost > self.config.costLimit {
            unsafeTrim(toCost: self.config.costLimit)
        }
        
        if cache.totalCount > self.config.countLimit {
            unsafeTrim(toCost: self.config.countLimit)
        }
    }
    
    public func removeObejct(forKey key: String) {
        cache.removeObject(forKey: key)
    }
    
    public func removeExpiredObjects() {
        unsafeTrim(toCost: config.costLimit)
        unsafeTrim(toCount: config.countLimit)
        unsafeTrim(toAge: config.expiry.time)
    }
    
    public func removeAll() {
        cache.removeAll()
    }
}


// MARK: Method - Private
extension MYPMemoryCache {
    private func unsafeTrim(toCount count: UInt) {
        if cache.totalCount < count {
            return
        }
        
        if config.countLimit == 0 {
            cache.removeAll()
        }
        
        if let _ = cache.lastObject {
            while count < cache.totalCount {
                cache.removeLastObject()
                guard let _: MYPMemoryCacheObject = cache.lastObject else { break }
            }
        }
    }
    
    private func unsafeTrim(toCost cost: UInt) {
        if cache.totalCost < cost {
            return
        }
        
        if config.costLimit == 0 {
            cache.removeAll()
        }
        
        if let _ = cache.lastObject {
            while cost < cache.totalCost {
                cache.removeLastObject()
                guard let _: MYPMemoryCacheObject = cache.lastObject else { break }
            }
        }
    }
    
    private func unsafeTrim(toAge age: TimeInterval) {
        if let obj = cache.lastObject {
            while obj.time.isExpired {
                cache.removeLastObject()
                guard let _: MYPMemoryCacheObject = cache.lastObject else { break }
            }
        }
    }
    
    @objc private func _didReceiveMemoryWarningNotification() {
        if let Closure = self.didReceiveMemoryWarningClosure {
            Closure(self)
        }
        if config.shouldRemoveAllObjectsOnMemoryWarning {
            removeAll()
        }
    }
    
    @objc private func _didEnterBackgroundNotification() {
        if let Closure = self.didEnterBackgroundClosure {
            Closure(self)
        }
        if config.shouldRemoveAllObjectsWhenEnteringBackground {
            removeAll()
        }
    }
}
