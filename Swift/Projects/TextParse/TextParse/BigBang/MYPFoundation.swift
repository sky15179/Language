//
//  MYPFoundation.swift
//  MeituanMovie
//
//  Created by 王智刚 on 2018/10/31.
//  Copyright © 2018年 sankuai. All rights reserved.
//

import Foundation

let isIPhoneX = (CGFloat.screenWidth == 375 && CGFloat.screenHeight == 812) || (CGFloat.screenWidth == 812 && CGFloat.screenHeight == 375)

extension CGFloat {
    // General Constants
    static var screenScale: CGFloat { return UIScreen.main.scale }
    static var screenWidth: CGFloat { return UIScreen.main.bounds.width }
    static var screenHeight: CGFloat { return UIScreen.main.bounds.height }
    static var statusBarHeight: CGFloat { return isIPhoneX ? 44 : 20 }
    static var safeBottom: CGFloat { return isIPhoneX ? 34 : 0 }
    static var navBarHeight: CGFloat { return isIPhoneX ? (44 + statusBarHeight) : 64.0 }
    static var tabBarHeight: CGFloat { return isIPhoneX ? (49 + safeBottom) : 49 }
    static var singleLineHeight: CGFloat { return UIScreen.main.scale == 3 ? 0.67 : 1.0 / UIScreen.main.scale }
    static var segmentHeight: CGFloat { return 44 }
    
    // Special Constants
    static var cinemaSegmentTabTop: CGFloat { return 78 }
    static var chartViewHeight: CGFloat { return 215 }
}

extension Array where Element: Equatable {
    @discardableResult
    mutating func remove(_ object: Element) -> Element? {
        if let index = index(of: object) {
            return remove(at: index)
        } else {
            return nil   
        }
    }
}

@objc extension UIColor {
    static var mainThemeBackground: UIColor { return .xF2F2F2 }
    static var x26282E: UIColor { return UIColor.HEXCOLOR(0x26282e) }
    static var xF2F2F2: UIColor { return UIColor.HEXCOLOR(0xf2f2f2) }
    
    func alpha(_ alpha: Double) -> UIColor {
        return withAlphaComponent(CGFloat(alpha))
    }
}

extension NSString {
    func size(_ font: UIFont, width: CGFloat = CGFloat(MAXFLOAT), lineBreakMode: NSLineBreakMode = .byWordWrapping) -> CGSize {
        let expectedFrame = self.boundingRect(with: CGSize(width: width, height: font.lineHeight), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        return CGSize(width: expectedFrame.width.ceil, height: expectedFrame.height.ceil)
    }
    
    func size(_ font: UIFont, size: CGSize, lineBreadMode: NSLineBreakMode = .byCharWrapping) -> CGSize {
        let expectedFrame = self.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        return CGSize(width: min(expectedFrame.width.ceil, size.width), height: min(expectedFrame.height.ceil, size.height))
    }
}

extension CGFloat {
    var ceil: CGFloat {
        return CGFloat(ceilf(Float(self)))
    }
    var round: CGFloat {
        return CGFloat(roundf(Float(self)))
    }
    var floor: CGFloat {
        return CGFloat(floorf(Float(self)))
    }
}

extension Bool {
    mutating func negate() {
        self = !self
    }
}
