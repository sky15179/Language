//
//  MYPCacheError.swift
//  MYPCache
//
//  Created by 王智刚 on 2017/10/22.
//  Copyright © 2017年 王智刚. All rights reserved.
//

enum MYPCacheError: Error {
    /// 不能正确encode
    case encodingFailed
    /// 不能正确decode
    case decodingFailed
    /// 错误的文件信息
    case malformedFileAttribute
    /// 未找到
    case notFound
    /// 类型不匹配
    case typeNotMactch
    case deallocated
}
