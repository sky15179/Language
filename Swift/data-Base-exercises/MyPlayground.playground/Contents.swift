//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

struct Parer<A>{
    typealias Stream = String.CharacterView
    let parer:(Stream)->(A,Stream)?
}

func curry<A,B,C>(_ f:@escaping (A,B)->C) -> (A) ->(B) -> C {
    return{a in {b in f(a,b)}}
}

func character(matching condition:@escaping (Character)->Bool) -> Parer<Character> {
    return Parer<Character>{
        input in
        guard let char = input.first,condition(char) else{
            return nil
        }
        
        return(char,input.dropFirst())
    }
}


extension Parer{
    
    func run(_ string:String) -> (A,String)? {
        guard let (result,remainder) = parer(string.characters) else {
            return nil
        }
        return (result,String(remainder))
    }
    
    
    /// 有问题,对空字符串的解析
    var many:Parer<[A]>{
        return Parer<[A]>{
            input in
            var result:[A] = []
            var remainder = input
            
            while let (element,newRemainder) = self.parer(remainder) {
                remainder = newRemainder
                result.append(element)
            }
            return (result,remainder)
        }
    }
    
    var many1:Parer<[A]>{
        return curry{[$0] + $1}<^>self<*>self.many
    }
    
    var optional:Parer<A?>{
        return Parer<A?>{ input in
            guard let (result,remainder) = self.parer(input) else {
                return (nil,input)
            }
            return (result,remainder)
        }
    }
    
    
    func map<T>(_ transform:@escaping (A)->T) -> Parer<T> {
        return Parer<T>{
            input in
            guard let (result,remainder) = self.parer(input) else {
                return nil
            }
            return (transform(result),remainder)
        }
    }
    
    func follow<T>(by other:Parer<T>) -> Parer<(A,T)> {
        return Parer<(A,T)>{
            input in
            guard let (result1,remainder1) = self.parer(input) else {
                return nil
            }
            
            guard let (result2,remainder2) = other.parer(remainder1) else{
                return nil
            }
            
            return ((result1,result2),remainder2)
        }
    }
    
    func or(_ other:Parer<A>) -> Parer<A> {
        return Parer<A>{ input in
            return self.parer(input) ?? other.parer(input)
        }
    }
    
}

extension CharacterSet{
    public func contains(_ c:Character) -> Bool {
        let scalars = String(c).unicodeScalars
        guard scalars.count == 1 else {
            return false
        }
        return contains(scalars.first!)
    }
}

func curriedMultiply(_ x:Int)->(Character)->(Int)->Int{
    return { op in
        return{ y in
            return x * y
        }
    }
}

precedencegroup SequencePrecedence{
    associativity: left
    higherThan:AdditionPrecedence
}

infix operator <*>:SequencePrecedence
infix operator <^>:SequencePrecedence
infix operator *>:SequencePrecedence
infix operator <*:SequencePrecedence
infix operator <|>:SequencePrecedence

func <*><A,B>(lhs:Parer<(A)->B>,rhs:Parer<A>)->Parer<B>{
    return lhs.follow(by: rhs).map{f,x in f(x)}
}

func <^><A,B>(lhs:@escaping (A)->B,rhs:Parer<A>)->Parer<B>{
    return rhs.map(lhs)
}

func *><A,B>(lhs:Parer<A>,rhs:Parer<B>)->Parer<B>{
    return curry{_,y in y}<^>lhs<*>rhs
}

func <*<A,B>(lhs:Parer<A>,rhs:Parer<B>)->Parer<A>{
    return curry{x,_ in x}<^>lhs<*>rhs
}

func <|><A>(lhs:Parer<A>,rhs:Parer<A>) -> Parer<A>{
    return lhs.or(rhs)
}

let digt = character{CharacterSet.decimalDigits.contains($0)}
digt.run("345")
let integer = digt.many.map {Int(String($0))!}
integer.run("323")

let multiplication = integer.follow(by: character(){$0 == "*"}).follow(by: integer)
multiplication.run("2*3")
let multiplication2 = multiplication.map { $0.0 * $1 }
multiplication2.run("2*3")

let multiplication3 = integer.map(curriedMultiply).follow(by: character{$0 == "*"}).map{f,op in f(op)}.follow(by: integer).map{f,y in f(y)}

let multiplication4 = curriedMultiply<^>integer<*>character{$0 == "*"}<*>integer

let arr = ["a":"ddd","b":"bbbb","c":"ccccc"]





