//
//  MYPCacheAsync.swift
//  MYPCache
//
//  Created by 王智刚 on 2017/11/2.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import Foundation

public class MYPCacheAsync {
    private let internalCache: MYPStorageProtocol
    private var _pthreadLock: pthread_mutex_t = pthread_mutex_t()
    public let queue: DispatchQueue
    init(cache: MYPStorageProtocol, queue: DispatchQueue) {
        self.internalCache = cache
        self.queue = queue
    }
}

extension MYPCacheAsync {
     public func wapper<T>(ofType type: T.Type, forKey key: String, completion: @escaping (MYPCacheResult<MYPCacheWrapper<T>>) -> Void) {
        self.queue.async { [weak self] in
            guard let `self` = self else {
                completion(MYPCacheResult.error(MYPCacheError.deallocated))
                return
            }
            
            do {
                self.lock()
                let wapper = try self.internalCache.wapper(ofType: type, forKey: key)
                self.unlock()
                completion(MYPCacheResult.value(wapper))
            } catch {
                completion(MYPCacheResult.error(error))
            }
        }
    }
    
    public func setObject<T: Codable>(object: T, forKey key: String, expiry: MYPCahceExpiry?, completion: @escaping (MYPCacheResult<()>) -> Void) {
        self.queue.async { [weak self] in
            guard let `self` = self else {
                completion(MYPCacheResult.error(MYPCacheError.deallocated))
                return
            }
            
            do {
                self.lock()
                try self.internalCache.setObject(object: object, forKey: key, expiry: expiry)
                self.unlock()
                completion(MYPCacheResult.value(()))
            } catch {
                completion(MYPCacheResult.error(error))
            }
        }
    }
    
    public func removeObejct(forKey key: String, completion: @escaping (MYPCacheResult<()>) -> Void) {
        self.queue.async { [weak self] in
            guard let `self` = self else {
                completion(MYPCacheResult.error(MYPCacheError.deallocated))
                return
            }
            
            do {
                self.lock()
                try self.internalCache.removeObejct(forKey: key)
                self.unlock()
                completion(MYPCacheResult.value(()))
            } catch {
                completion(MYPCacheResult.error(error))
            }
        }
    }
    
    public func removeExpiredObjects(completion: @escaping (MYPCacheResult<()>) -> Void) {
        self.queue.async { [weak self] in
            guard let `self` = self else {
                completion(MYPCacheResult.error(MYPCacheError.deallocated))
                return
            }
            
            do {
                self.lock()
                try self.internalCache.removeExpiredObjects()
                self.unlock()
                completion(MYPCacheResult.value(()))
            } catch {
                completion(MYPCacheResult.error(error))
            }
        }
    }
    
    public func removeAll(completion: @escaping (MYPCacheResult<()>) -> Void) {
        self.queue.async { [weak self] in
            guard let `self` = self else {
                completion(MYPCacheResult.error(MYPCacheError.deallocated))
                return
            }
            
            do {
                self.lock()
                try self.internalCache.removeAll()
                self.unlock()
                completion(MYPCacheResult.value(()))
            } catch {
                completion(MYPCacheResult.error(error))
            }
        }
    }
    
    func object<T: Codable>(ofType type: T.Type, forKey key: String, completion: @escaping (MYPCacheResult<T>) -> Void) {
        wapper(ofType: type, forKey: key) { (result: MYPCacheResult<MYPCacheWrapper<T>>) in
            completion(result.map {
                return $0.object
            })
        }
    }

    func existObject<T: Codable>(ofType type: T.Type, forKey key: String, completion: @escaping (MYPCacheResult<Bool>) -> Void) {
        object(ofType: type, forKey: key) { (result: MYPCacheResult<T>) in
            completion(result.map({ _ in
                return true
            }))
        }
    }
    
    private func lock(){
        pthread_mutex_lock(&_pthreadLock)
    }
    
    private func unlock(){
        pthread_mutex_unlock(&_pthreadLock)
    }
}
