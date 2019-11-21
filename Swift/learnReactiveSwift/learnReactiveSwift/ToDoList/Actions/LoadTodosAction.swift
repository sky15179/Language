//
//  LoadTodosAction.swift
//  learnReactiveSwift
//
//  Created by 王智刚 on 2017/9/21.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import Delta

struct LoadTodosAction: ActionType {
    let todos: [Todo]
    
    func reduce(state: State) -> State {
        state.todos.value = state.todos.value + todos
        return state
    }
}
