//
//  MYPDataSerializer.swift
//  MYPCache
//
//  Created by 王智刚 on 2017/10/22.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import Foundation

class MYPDataSerializer {
    
    /// 序列化
    ///
    /// - Parameter objct: 对象
    /// - Returns: 二进制数据
    static func serialize<T: Encodable>(objct: T) throws ->  Data {
        let encoder = JSONEncoder()
        return try encoder.encode(objct)
    }
    
    /// 反序列化
    ///
    /// - Parameter data: 二进制数据
    /// - Returns: 对象
    static func deserialize<T: Decodable>(data: Data) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}
