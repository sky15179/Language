//
//  UIView+Extension.swift
//  learnReactiveSwift
//
//  Created by 王智刚 on 2017/9/28.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import UIKit

extension UIView {
    public static var defaultReusableId: String {
        let arr = self.description().components(separatedBy: ".")
        if arr.count > 1 {
            return arr.dropFirst().joined(separator: ".")
        } else if arr.count == 1 {
            return arr.first ?? ""
        } else {
            assertionFailure("类型转字符串失败")
            return ""
        }
    }
}
