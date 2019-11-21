//
//  Decoder+Extension.swift
//  MYPCache
//
//  Created by 王智刚 on 2017/10/22.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import Foundation

extension Decoder {
    static func decode<T: Decodable>(string: String) throws -> T {
        guard let data = string.data(using: .utf8) else {
            throw MYPCacheError.decodingFailed }
        return try JSONDecoder().decode(T.self, from: data)
    }
}
