//
//  Date+Extension.swift
//  MYPCache
//
//  Created by 王智刚 on 2017/10/22.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import Foundation

extension Date {
    var inThePast: Bool {
        return timeIntervalSinceNow < 0
    }
}
