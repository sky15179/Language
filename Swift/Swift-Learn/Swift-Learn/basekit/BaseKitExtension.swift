//
//  BaseKitExtension.swift
//  Swift-Learn
//
//  Created by 王智刚 on 16/6/29.
//  Copyright © 2016年 w.z.g. All rights reserved.
//

import Foundation

/**
 *  泛型版本的组合运算符
 */
infix operator >>> {associativity left}
func >>><A,B,C>(f:@escaping (A)->B,g:@escaping (B)->C) -> (A)->C {
    return {x in g(f(x))}
}

/**
 对两个函数进行柯里化处理
 
 - parameter f: 柯里化
 
 - returns: 柯里化结果
 */
func curry<A,B,C>(_ f:@escaping (A,B)->C) -> (A)->(B)->C {
    return {x in {y in f(x,y)}}
}

extension Array{
  
}
