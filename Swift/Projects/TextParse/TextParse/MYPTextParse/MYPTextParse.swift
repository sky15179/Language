//
//  MYPTextParse.swift
//  moviePro
//
//  Created by 王智刚 on 2018/10/24.
//  Copyright © 2018年 sankuai. All rights reserved.
//

import Foundation

protocol MYPUnicodeRanges {
    static var ranges: Array<CountableClosedRange<Int>> { get }
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
}

extension Range where Bound == Int {
    struct Emoji: MYPUnicodeRanges {
        //emoji Unicode range: https://apps.timwhitlock.info/emoji/tables/unicode
        static var ranges: Array<CountableClosedRange<Int>> {
            get {
                return [0x1F600...0x1F64F, 0x2702...0x27B0, 0x1F680...0x1F6C0, 0x24C2...0x1F251, 0x00A9...0x1F5FF, 0x1F681...0x1F6C5, 0x1F30D...0x1F567]
            }
        }
    }
    
    struct Symbol: MYPUnicodeRanges {
        static var ranges: Array<CountableClosedRange<Int>> {
            get {
                return [0x1F300...0x1F5FF, 0x2600...0x26FF]
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

final class MYPTextBox {
    let text: String
    init(text: String) {
        self.text = text
    }
}

extension String {
    var isAllSpace: Bool {
        get {
            return !(self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count > 0)
        }
    }
    
    private func contain(closure: (Unicode.Scalar) -> Bool) -> Bool {
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
    
    func parseByWords() -> Array<String>? {
        var result: [String] = []
        self.enumerateSubstrings(in: ..<self.endIndex, options: NSString.EnumerationOptions.byWords) { (subString, substringRange, enclosingRange, stop) in
            guard let subString = subString else {
                return
            }
//            substringRange.location >
            result.append(subString)
        }
        return result.count > 0 ? result : nil
    }
    
    private func handleSpecialWord(string: String) {
        
    }
}

final class MYPTextParser {
    
}
