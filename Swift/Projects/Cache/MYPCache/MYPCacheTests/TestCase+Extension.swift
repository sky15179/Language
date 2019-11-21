//
//  TestCase+Extension.swift
//  MYPCacheTests
//
//  Created by 王智刚 on 2017/11/1.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import XCTest

extension XCTest {
    func when(_ desc: String, closure: () throws -> Void) rethrows {
        try closure()
    }
    
    func given(_ desc: String, closure: () throws -> Void) rethrows {
        try closure()
    }
    
    func then(_ desc: String, closure: () throws -> Void) rethrows {
        try closure()
    }
}
