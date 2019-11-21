//
//  Expression.swift
//  data-Base-exercises
//
//  Created by 王智刚 on 2017/6/29.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import Foundation

//7.算数表达式的解析器
//expression = minus
//minus = addition ("-" addition)?
//addition = division ("+" division)?
//division = multiplication ("/" multiplication)?
//multiplication = integer ("*" integer)?

let multiplication = curry({ $0 * ($1 ?? 1) })<^>integer<*>(character{$0 == "*"}*>integer).optional
let division = curry({ $0 / ($1 ?? 1) }) <^>
    multiplication <*> (character { $0 == "/" } *> multiplication).optional
let addition = curry({ $0 + ($1 ?? 0) }) <^>
    division <*> (character { $0 == "+" } *> division).optional
let minus = curry({ $0 - ($1 ?? 0) }) <^>
    addition <*> (character { $0 == "-" } *> addition).optional
let expression = minus

//8.为了处理通用的数据,需要将数据转换成可执行的语句,通过抽象语法树来对普通编码进行转换,分离为获取解析器,求值两部
indirect enum myExpression{
    case int(Int) //简单数值
    case reference(String,Int) //A3,单元格和行号组成
    case infix(myExpression,String,myExpression) //支持运算操作
    case function(String,myExpression) //支持方法:SUM,MIN
}

func combineOperands(first:myExpression,_ reset:[(String,myExpression)]) -> myExpression {
    return reset.reduce(first){
        result,pair in
        return myExpression.infix(result, pair.0, pair.1)
    }
}

extension myExpression{
    
    /// 9.构建抽象语法树,输出对应的解析器
    
    static var intParser:Parser<myExpression>{
        return { .int($0)}<^>integer
    }
    
    static var referenceParser:Parser<myExpression>{
        return curry{ .reference(String($0),$1) }<^>capitalLetter<*>integer
    }
    
    static var functionParser:Parser<myExpression>{
        let name = {String($0)}<^>capitalLetter.many1
        let argument = curry{myExpression.infix($0, String($1), $2)}<^>referenceParser<*>string(":")<*>referenceParser
        return curry{ .function($0,$1) }<^>name<*>argument.parenthesized
    }
    
    static var productParser:Parser<myExpression>{
        let multiplier = curry({ ($0,$1) })<^>(string("*")<|>string("/"))<*>intParser
        return curry(combineOperands)<^>intParser<*>multiplier.many1
    }
    
    static var primitiveParser:Parser<myExpression>{
        return intParser<|>referenceParser<|>functionParser<|>lazy(parser).parenthesized
    }
    
    static var sumParser:Parser<myExpression>{
        let sum = curry({ ($0,$1) })<^>(string("+")<|>string("-"))<*>intParser
        return curry(combineOperands)<^>productParser<*>sum.many1
    }
    
    static var parser = sumParser
    
}

//10.根据解析器求值

enum Result {
    case int(Int)
    case list([Result])
    case error(String)
}

func lift(_ op:@escaping (Int,Int)->Int) -> (Result,Result)->Result {
    return { lhs,rhs in
        guard case let (.int(x),.int(y)) = (lhs,rhs) else { return .error("Invalid operands \(lhs, rhs) for integer operator") }
        return .int(op(x,y))
    }
}

//解析器求值
extension myExpression{
    
    func evaluateFunction(context:[myExpression?]) -> Result? {
        guard
            case let .function(name,parameter) = self,
            case let .list(list) = parameter.evaluate(context:context)
        else { return nil }
        
        switch name {
        case "SUM":
            return list.reduce(.int(0), lift(+))
        case "MIN":
            return list.reduce(.int(Int.max), lift{ min($0, $1) })
        default:
            return .error("Unknown function \(name)")
        }
    }
    
    func evaluateArithmetic(context:[myExpression?]) -> Result? {
        guard case let .infix(l,op,r) = self else { return nil }
        let x = l.evaluate(context: context)
        let y = r.evaluate(context: context)
        
        switch op {
        case "+":return lift(+)(x,y)
        case "-":return lift(-)(x,y)
        case "*":return lift(*)(x,y)
        case "/":return lift(/)(x,y)
        default:
            return nil
        }
        
    }
    
    func evaluateList(context:[myExpression?]) -> Result? {
        guard
            case let .infix(l,op,r) = self,
            op == ":",
            case let .reference("A",row1) = l,
            case let .reference("A",row2) = r
            else {return nil}
        return .list((row1...row2).map{
            myExpression.reference("A", $0).evaluate(context:context)
        })
    }
    
    func evaluate(context:[myExpression?]) -> Result {
        switch self {
        case let .int(x):
            return .int(x)
        case let .reference("A",row):
            return context[row]?.evaluate(context:context) ?? .error("invalid reference\(self)")
        case .function:
            return self.evaluateFunction(context: context) ?? self.evaluateList(context: context) ?? .error("invalid function\(self)")
        case let .infix(l, op, r):
            return self.evaluateArithmetic(context: context) ?? self.evaluateList(context: context) ?? .error("Invalid operator \(op) for operands \(l, r)")
        default:
            return .error("couldn't evaluate context:\(self)")
        }
    }
}

func evaluate(expressions:[myExpression?]) -> [Result] {
    return expressions.map{ $0?.evaluate(context: expressions) ?? .error("invalid expression\($0)") }
}

