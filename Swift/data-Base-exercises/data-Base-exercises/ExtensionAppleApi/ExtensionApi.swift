//
//  ExtensionApi.swift
//  data-Base-exercises
//
//  Created by 王智刚 on 2017/6/15.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import Foundation


// MARK: - 拓展系统协议
extension IteratorProtocol{
    
    /// 找出符合条件的元素的迭代器
    /// 注意:只会返回第一个符合条件的
    /// - Parameter predicate: 过滤算法
    /// - Returns:第一个符合条件的元素
    public mutating func find(predicate:(Element)->Bool)->Element?{
        while let x = next() {
            if predicate(x) {
                return x
            }
        }
        return nil
    }
}

protocol Smaller {
    func smaller() -> AnyIterator<Self>
}


///顶层函数,合并迭代器
///
/// - Parameters:
///   - first: 首先执行的迭代器
///   - second: 第一个迭代器完全执行完后继续执行的迭代器
/// - Returns: 合并后的迭代器
func +<I:IteratorProtocol,J:IteratorProtocol>(first:I,second:@escaping @autoclosure ()->J) -> AnyIterator<I.Element> where I.Element == J.Element {
    var one = first
    var other:J? = nil
    return AnyIterator{
        if other != nil{
            return other!.next()
        }else if let result = one.next(){
            return result
        }else{
            other = second()
            return other!.next()
        }
    }
}

extension Int{
    
    /// 自减
    ///
    /// - Returns: <#return value description#>
    func countDown() -> AnyIterator<Int> {
        var i = self - 1
        return AnyIterator{
            guard i >= 0 else{return nil}
            defer {i -= 1}
            return i
        }
        
    }
}

extension String{
    var length:UInt{
        get{
            return UInt(self.characters.count)
        }
    }
    
}

// MARK: - 获取数组内的只减少一个的子集
extension Array:Smaller{
    func smaller() -> AnyIterator<[Element]> {
        var i = 0
        return AnyIterator{
            guard i < self.endIndex else{return nil}
            var result = self
            result.remove(at: i)
            i += 1
            return result
        }
    }
}

//单例
//单例的几种写法
private let shareInstance = Singleton2()
class Singleton2 {
    var shareInstance2:Singleton2{
        return shareInstance
    }
}

/// 最简单
class Singleton {
    static let shareInstance = Singleton()
    private init(){}
}
