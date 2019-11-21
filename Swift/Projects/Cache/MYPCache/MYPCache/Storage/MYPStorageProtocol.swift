//
//  MYPStorageProtocol.swift
//  MYPCache
//
//  Created by 王智刚 on 2017/10/23.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import UIKit

/// 缓存的抽象协议: 统一缓存的使用公共接口,缓存的对象必须遵守codable协议
public protocol MYPStorageProtocol {
    
    /// 获取缓存的对象
    /// - Parameters:
    ///   - ofType: 缓存的类型
    ///   - forKey: 缓存对象的键值,注意键值必须是唯一的
    /// - Returns: 缓存对象
    func object<T: Codable>(ofType type: T.Type, forKey key: String) throws -> T
    
    /// 缓存对象
    ///
    /// - Parameters:
    ///   - object: 被缓存的对象
    ///   - forKy: 缓存对象的键值,注意键值必须是唯一的
    func setObject<T: Codable>(object: T, forKey key: String, expiry: MYPCahceExpiry?) throws
    
    /// 获取缓存对象的详细相关信息: 过期时间等
    ///
    /// - Parameters:
    ///   - ofType: 缓存的类型
    ///   - forKey: 缓存对象的键值,注意键值必须是唯一的
    /// - Returns: 包含详细信息的容器对象
    func wapper<T: Codable>(ofType type: T.Type, forKey key: String) throws -> MYPCacheWrapper<T>
    
    /// 删除所有缓存
    func removeAll() throws
    
    /// 根据键值删除缓存对象
    ///
    /// - Parameter key: 键值
    /// - Returns: 被删除的缓存对象
    func removeObejct(forKey key: String) throws
    
    /// 删除过期和超过缓存上限的缓存数据
    func removeExpiredObjects() throws
    
    /// 根据键值检测是否存在缓存对象
    ///
    /// - Parameters:
    ///   - type: 对象类型
    ///   - key: 键值
    func existObject<T: Codable>(ofType type: T.Type, forKey key: String) throws -> Bool
}

public extension MYPStorageProtocol {
    func object<T: Codable>(ofType type: T.Type, forKey key: String) throws -> T {
        return try wapper(ofType: type, forKey: key).object
    }
    
    func existObject<T: Codable>(ofType type: T.Type, forKey key: String) throws -> Bool {
        do {
            let _: T = try object(ofType: type, forKey: key)
            return true
        } catch {
            return false
        }
    }
}
