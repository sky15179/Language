//
//  Parser.swift
//  data-Base-exercises
//
//  Created by 王智刚 on 2017/6/29.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import Foundation

//1.确定解析器的构造,由一个解析函数构成
struct Parser<A>{
    typealias Stream = String.CharacterView
    let parse:(Stream)-> (A,Stream)?
}


extension Parser{
    //2.解析器的基本能力,这里只考虑解析字符串,方便查看结果的函数封装,对多个的处理,类型转换的基本能力
    /// 将解析器结果重新包装成string,方便查看结果
    ///
    /// - Parameter string: 要解析的zifuc
    /// - Returns: 元组结果:(符合条件的字符串,剩余的字符串)
    func run(_ string:String) -> (A,String)? {
        guard let (result,remainder) = parse(string.characters) else { return nil}
        return (result,String(remainder))
    }
    
    /// 多次执行解析器,并将结果封装到一个数组,有问题:对空字符串求解会崩溃
    var many:Parser<[A]>{
        return Parser<[A]>{ input in
            var result:[A] = []
            var remainder = input
            
            while let (element,newRemainder) = self.parse(remainder) {
                result.append(element)
                remainder = newRemainder
            }
            return (result,remainder)
        }
    }
    
    
    /// 函子操作,支持类结构体的改造从A类型->T类型
    /// 应用:为了完成对拆分的数字字符串数组合并成一个完整的整数类型
    /// - Parameter transform: 类型转换函数
    /// - Returns: 新的类结构体的解析器
    func map<T>(_ transform:@escaping (A)->T) -> Parser<T> {
        return Parser<T>{ input in
            guard let (result,remainder) = self.parse(input) else{ return nil }
            return (transform(result),remainder)
        }
    }
    
    //3.处理多个解析器的能力,顺序解析每个解析器的结果
    
    /// 顺序合并解析器
    /// 问题:存在不断嵌套元组的问题,因为每个解析器的返回结果类型不同
    /// 解决方法:元组,数组,柯里化函数:“与其先将它们包裹在一个嵌套的多元组里然后再去计算，不如依次向每个解析器的结果传入一个可执行的函数，倘若如此做，我们就可以避免这个问题。”,这里的最优解就是柯里化函数
    /// - Parameter other: 待合并的解析器
    /// - Returns: 一个通过元组封装两个解析器结果的新的解析器
    func follow<T>(by other:Parser<T>) -> Parser<(A,T)> {
        return Parser<(A,T)>{ input in
            guard let (result,remainder) = self.parse(input) else { return nil}
            guard let (result2,remainder2) = other.parse(remainder) else { return nil}
            return ((result,result2),remainder2)
        }
    }
    
    //5.更多的解析运算支持,或,定义或运算符
    
    /// 或运算解析器
    ///
    /// - Parameter other: <#other description#>
    /// - Returns: <#return value description#>
    func or(_ other:Parser<A>) -> Parser<A> {
        return Parser<A>{ input in
            return self.parse(input) ?? other.parse(input)
        }
    }
    
    //6.优化现有有问题函数,many在处理空字符串的时候会有问题,可选解析器的提供
    /// 先执行一次,再通过柯里化合并结果,要好好理解curry 和 运算符的意义
    var many1:Parser<[A]>{
        return curry({ [$0] + $1 })<^>self<*>self.many
    }
    
    var optional:Parser<A?>{
        return Parser<A?>{ input in
            guard let (result,remainder) = self.parse(input) else {
                return (nil,input)
            }
            return (result,remainder)
        }
    }
}

//4.运算符组合复杂功能,发现有重复的处理部分,可以优化抽象出一个顺序解析运算符,这也是一个适用函子
//        let multiplication3 = p1.follow(by: character{$0 == "*"}).map{ f,op in f(op) }.follow(by: integer).map{ f,x in f(x) }
precedencegroup SequencePrecedence{
    associativity: left
    higherThan:AdditionPrecedence
}

infix operator <*>:SequencePrecedence
infix operator <^>:SequencePrecedence
infix operator *>:SequencePrecedence
infix operator <*:SequencePrecedence
infix operator <|>:SequencePrecedence

/// 顺序解析器运算符,简化柯里化后的函数,适用函子的一个典型
///
/// - Parameters:
///   - lhs: A->B 的柯里化转换函数
///   - rhs: 原解析器 
/// - Returns: 转换成B的解析器
func <*><A,B>(lhs:Parser<(A)->B>,rhs:Parser<A>) -> Parser<B> {
    return lhs.follow(by: rhs).map{ f,x in f(x)}
}


/// 简化顺序解析器的map操作
/// integer.map(curriedMultiply)
/// - Parameters:
///   - lhs: 转换函数
///   - rhs: 原解析器
/// - Returns: B解析器
func <^><A,B>(lhs:@escaping (A)->B,rhs:Parser<A>) -> Parser<B> {
    return rhs.map(lhs)
}


/// 合并解析器,只保留左边的解析器结果
///
/// - Parameters:
///   - lhs: <#lhs description#>
///   - rhs: <#rhs description#>
/// - Returns: <#return value description#>
func <*<A,B>(lhs:Parser<A>,rhs:Parser<B>) -> Parser<A> {
    return curry({ x,_ in x})<^>lhs<*>rhs
}


/// 合并解析器,只保留右边的解析器结果
///
/// - Parameters:
///   - lhs: <#lhs description#>
///   - rhs: <#rhs description#>
/// - Returns: <#return value description#>
func *><A,B>(lhs:Parser<A>,rhs:Parser<B>) -> Parser<B> {
    return curry({ $1 })<^>lhs<*>rhs
}


/// 两个解析器的或结果
///
/// - Parameters:
///   - lhs: 优先
///   - rhs: 其次
/// - Returns: <#return value description#>
func <|><A>(lhs:Parser<A>,rhs:Parser<A>) -> Parser<A> {
    return lhs.or(rhs)
}

/// 处理一般的字符串解析,但是只能处理单个字符串的解析器
///
/// - Parameter condition: 解析条件
/// - Returns: 解析器
func character(condition:@escaping (Character)->Bool) -> Parser<Character> {
    return Parser<Character> { input in
        
        guard let char = input.first, condition(char) else { return nil}
        return (char,input.dropFirst())
    }
}

/// 柯里化合并解析结果
///
/// - Parameter x: <#x description#>
/// - Returns: <#return value description#>
func curriedMultiply(_ x:Int) -> (Character) -> (Int) -> Int {
    return {
        op in
        return {
            y in
            return x * y
        }
    }
}

func lazy<A>(_ parser:@escaping @autoclosure ()->Parser<A>) -> Parser<A> {
    return Parser<A>{
        parser().parse($0)
    }
}


/// 匹配特定字符串
///
/// - Parameter string: <#string description#>
/// - Returns: <#return value description#>
func string(_ string:String) -> Parser<String> {
    return Parser<String>{ input in
        var remainder = input
        for c in string.characters {
            let parser = character { $0 == c }
            guard let (_, newRemainder) = parser.parse(remainder) else { return nil }
            remainder = newRemainder
        }
        return (string, remainder)
    }
}

extension Parser{
    
    /// 忽略括号
    var parenthesized:Parser<A>{
            return string("(")*>self<*string(")")
    }
}


let digit = character{ CharacterSet.decimalDigits.contains($0) }
let integer = digit.many1.map{ Int(String($0))! }
let capitalLetter = character{ CharacterSet.uppercaseLetters.contains($0) }



