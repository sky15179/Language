//
//  Random.swift
//  moviePro
//
//  Created by 王智刚 on 2018/9/5.
//  Copyright © 2018年 sankuai. All rights reserved.
//

import Foundation
import UIKit

#if DEBUG

protocol Random {
    associatedtype ReturnType
    static var random: ReturnType { get }
}

extension UIColor: Random {
    //返回随机颜色
    static var random: UIColor {
        let red = CGFloat(arc4random() % 256) / 255.0
        let green = CGFloat(arc4random() % 256) / 255.0
        let blue = CGFloat(arc4random() % 256) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

extension Int {
    func repeatTimes(closure: (Int) -> Void) {
        var index = self
        repeat {
            closure(index)
            index = index.decrease()
        } while (index >= 0)
    }
    
    func increase() -> Int {
        return self + 1
    }
    
    func decrease() -> Int {
        return self - 1
    }
}

extension String {
    func split() -> [String] {
        var result: [String] = []
        self.forEach { (char) in
            result.append(String(char))
        }
        return result
    }
}

extension Int: Random {
    //随机数,默认范围为0~100
    static var random: Int {
        return Int(arc4random() % 100) + 1
    }
    
    static func random(range: Range<Int>) -> Int {
        let count = range.upperBound - range.lowerBound
        return Int(arc4random_uniform(UInt32(count))) + range.lowerBound
    }
    
    static func random(count: Int) -> Array<Int> {
        var result: [Int] = []
        count.repeatTimes { _ in
            result.append(Int.random)
        }
        return result
    }
}

extension Array {
    var random: Element {
        let range = Range(0...self.count)
        let random = Int.random(range: range)
        return self[random]
    }
}

extension String: Random {
    static var random: String {
        return "测试"
    }
    
    private static func random(source: String, length: Int) -> String {
        var result = ""
        length.repeatTimes { _ in
            let range = Range(0...source.split().count)
            let random = Int.random(range: range)
            let word = source.split()[random]
            result.append(word)
        }
        return result
    }
    
    private static func random(source: Array<String>, length: Int) -> Array<String> {
        var result: [String] = []
        length.repeatTimes { _ in
            let range = Range(0...source.count)
            let random = Int.random(range: range)
            let word = source[random]
            result.append(word)
        }
        return result
    }
    
    static func randomEnWord(length: Int = 10) -> String {
        let allWords = "abcdefghijklmnopqrstuvwxyz"
        return String.random(source: allWords, length: length)
    }
    
    static func randomChWord(length: Int = 10) -> String {
        return "测试"
    }
    
    static func randomNumberWord(length: Int = 10) -> String {
        let allWords = "0123456789"
        return String.random(source: allWords, length: length)
    }
    
//    func randomName(count: Int = 10)-> Array<String> {
//        return ["测试"]
//    }
//
//    func randomMovie(count: Int = 10)-> Array<String> {
//        return ["测试"]
//    }
//
//    static var randomMixWord: String {
//        return "测试"
//    }
}

#endif
