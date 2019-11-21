//
//  Helper.swift
//  data-Base-exercises
//
//  Created by 王智刚 on 2017/6/28.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import Foundation


extension CharacterSet{
    
    /// 判断字符是否是十进制数字
    ///
    /// - Parameter c: 字符
    /// - Returns: 是否是数字
    public func contains(_ c:Character) -> Bool {
        let scalars = String(c).unicodeScalars
        guard scalars.count == 1 else {
            return false
        }
        return contains(scalars.first!)
    }
}


/// 柯里化合并函数,双参数
///
/// - Parameter f: 参数合并函数
/// - Returns: 根据参数决定返回到哪一步的函数
func curry<A,B,C>(_ f:@escaping (A,B)->C) -> (A) ->(B) -> C {
    return{a in {b in f(a,b)}}
}


/// 柯里化合并函数,三参数
///
/// - Parameter f: <#f description#>
/// - Returns: <#return value description#>
func curry<A,B,C,D>(_ f:@escaping (A,B,C)->D) -> (A) ->(B) -> (C) -> D {
    return{a in {b in {c in f(a,b,c)}}}
}




