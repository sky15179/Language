//
//  Store.swift
//  learnReactiveSwift
//
//  Created by 王智刚 on 2017/9/19.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import ReactiveSwift
import enum Result.NoError
import Delta

protocol CommandType { }

struct Store: StoreType {
    var state: MutableProperty<State>
    
    init(state: State) {
        self.state = MutableProperty(state)
    }
}

var store = Store(state: State())

