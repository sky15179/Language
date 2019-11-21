//
//  KitExtension.swift
//  testSwift
//
//  Created by user on 16/3/14.
//  Copyright © 2016年 testSwift. All rights reserved.
//

import Foundation
import UIKit

extension Int{
    var f:CGFloat {return CGFloat(self)}
}

extension Float{
    var f:CGFloat {return CGFloat(self)}
}

extension Double{
    var f:CGFloat {return CGFloat(self)}
}

extension CGFloat{
    var swf:Float {return Float(self)}
}

extension String{
    var toInt:Int {return Int(self)!}
    var toFloat:Float {return Float(self)!}
}

extension Int{
    static func randomInRange(_ range: Range<Int>) -> Int {
        let count = UInt32(range.upperBound - range.lowerBound)
        return  Int(arc4random_uniform(count)) + range.lowerBound
    }
}

extension UIColor{
    static func randomColor()->UIColor{
        return UIColor(red: CGFloat(Int.randomInRange(0..<255))/255.0, green:CGFloat(Int.randomInRange(0..<255))/255.0, blue:CGFloat(Int.randomInRange(0..<255))/255.0, alpha: 0.0)
    }
}

