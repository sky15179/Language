//
//  MYPTextParse.swift
//  moviePro
//
//  Created by 王智刚 on 2018/10/24.
//  Copyright © 2018年 sankuai. All rights reserved.
//

import Foundation

protocol MYPUnicodeRanges {
    static var ranges: [CountableClosedRange<Int>] { get }
    static func contain(unicode: Int) -> Bool
}

extension MYPUnicodeRanges {
    static func contain(unicode: Int) -> Bool {
        for range in ranges {
            if range.contains(unicode) {
                return true
            }
        }
        return false
    }
}

extension Range where Bound == String.Index {
    var location: Int {
        return self.lowerBound.encodedOffset
    }
    
    var length: Int {
        return self.upperBound.encodedOffset - location
    }
    
    var sumOfLocationAndLength: Int {
        return self.upperBound.encodedOffset
    }
}

extension Range where Bound == Int {
    init(_ location: Int, length: Int) {
        if length > 0 {
            self.init(location...(location + length))
        } else {
            self.init((location + length)...location)
        }
    }
    
    var location: Int {
        return self.lowerBound
    }
    
    var length: Int {
        return self.upperBound - location
    }
    
    var sumOfLocationAndLength: Int {
        return self.upperBound
    }
    
    struct Emoji: MYPUnicodeRanges {
        //emoji Unicode range: https://apps.timwhitlock.info/emoji/tables/unicode
        static var ranges: [CountableClosedRange<Int>] {
            get {
                return [0x1F600...0x1F64F, 0x1F300...0x1F5FF, 0x1F680...0x1F6FF, 0x2600...0x26FF, 0x2700...0x27BF, 0xFE00...0xFE0F, 0x1F900...0x1F9FF]
            }
        }
    }
    
    struct Symbol: MYPUnicodeRanges {
        static var ranges: [CountableClosedRange<Int>] {
            get {
                return [0xFF00...0xFFEF, 0x3000...0x303F, 0xFE10...0xFE1F, 0x2000...0x206F, 0x2E00...0x2E7F, 0x0020...0x002F, 0x003A...0x0040, 0x005B...0x0060, 0x007B...0x007E, 0xFF01...0xFF0F, 0xFF1A...0xFF20, 0xFF3B...0xFF40, 0xFF5B...0xFF5E]
            }
        }
    }
}

extension Unicode.Scalar {
    var isSpecial: Bool {
        get {
            return isSymbol || isEmoji
        }
    }
    var isSymbol: Bool {
        get {
            return Range<Int>.Symbol.contain(unicode: Int(self.value))
        }
    }
    var isEmoji: Bool {
        get {
            return Range<Int>.Emoji.contain(unicode: Int(self.value))
        }
    }
}

extension String {
    fileprivate var isAllSpace: Bool {
        get {
            return !(self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count > 0)
        }
    }
    
    fileprivate func contain(closure: (Unicode.Scalar) -> Bool) -> Bool {
        for scalar in unicodeScalars {
            if closure(scalar) {
                return true
            }
        }
        return false
    }
    
    var containSpecial: Bool {
        get {
            return containSymbol || containEmoji
        }
    }
    
    var containSymbol: Bool {
        get {
            return self.contain(closure: { (scalar) -> Bool in
                return scalar.isSymbol
            })
        }
    }
    
    var containEmoji: Bool {
        get {
            return self.contain(closure: { (scalar) -> Bool in
                return scalar.isEmoji
            })
        }
    }
    
    func parseByWords() -> [String]? {
        guard self.count > 0 else { return nil }
        var result: [String] = []
        var emojiCount = 0
        self.enumerateSubstrings(in: ..<self.endIndex, options: NSString.EnumerationOptions.byWords) { (subString, substringRange, enclosingRange, stop) in
            guard let subString = subString, !subString.isAllSpace else {
                return
            }
            if substringRange.location > enclosingRange.location, let specialArray = String(self[enclosingRange.lowerBound..<substringRange.lowerBound]).handleSpecialWord() {
                result.append(contentsOf: specialArray)
            }
            result.append(subString)
            let str1 = NSString(string: self).substring(with: NSMakeRange(substringRange.sumOfLocationAndLength - emojiCount, (enclosingRange.sumOfLocationAndLength - substringRange.sumOfLocationAndLength)))
            if substringRange.location > enclosingRange.location, substringRange.sumOfLocationAndLength < enclosingRange.sumOfLocationAndLength, let specialArray = str1.handleSpecialWord() {
                result.append(contentsOf: specialArray)
            }
            let str2 = NSString(string: self).substring(with: NSMakeRange(substringRange.sumOfLocationAndLength - emojiCount,enclosingRange.length - substringRange.length))
            if substringRange.length < enclosingRange.length, substringRange.location == enclosingRange.location, let specialArray = str2.handleSpecialWord() {
                specialArray.forEach { str in
                    if str.containEmoji {
                        emojiCount = emojiCount + 1
                    }
                }
                result.append(contentsOf: specialArray)
            }
        }
        return result.count > 0 ? result : nil
    }
    
    fileprivate func handleSpecialWord() -> [String]? {
        guard self.count > 0 else { return nil }
        var result: [String] = []
        self.enumerateSubstrings(in: ..<self.endIndex, options: NSString.EnumerationOptions.byComposedCharacterSequences) { (subString, substringRange, enclosingRange, stop) in
            guard let subString = subString else {
                return
            }
            if subString.containSpecial {
                result.append(subString)
            }
        }
        return result.count > 0 ? result : nil
    }
}
