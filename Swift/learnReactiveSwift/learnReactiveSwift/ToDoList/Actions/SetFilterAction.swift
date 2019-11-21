//
//  SetFilterAction.swift
//  learnReactiveSwift
//
//  Created by 王智刚 on 2017/9/21.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import Delta

struct SetFilterAction: ActionType {
    let filter: TodoFilter
    
    func reduce(state: State) -> State {
        state.filter.value = filter
        return state
    }
}



