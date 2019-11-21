//
//  Box.swift
//  data-Base-exercises
//
//  Created by 王智刚 on 2017/7/1.
//  Copyright © 2017年 王智刚. All rights reserved.
//  封箱泛型类型

import Foundation

class Box<T> {
    let value:T
    init(value:T) {
        self.value = value
    }
    
}
