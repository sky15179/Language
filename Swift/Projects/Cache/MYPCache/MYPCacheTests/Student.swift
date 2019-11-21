//
//  Student.swift
//  MYPCacheTests
//
//  Created by 王智刚 on 2017/11/1.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import Foundation

struct Student: Codable, Equatable {
    let name: String
    let age: Int
    
    enum CodingKeys: String, CodingKey {
        case name = "myp_name"
        case age
    }
}

func == (lhs: Student, rhs: Student) -> Bool {
    return lhs.name == rhs.name && rhs.age == lhs.age
}
