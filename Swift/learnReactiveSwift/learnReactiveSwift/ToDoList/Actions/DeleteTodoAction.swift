//
//  DeleteTodoAction.swift
//  learnReactiveSwift
//
//  Created by 王智刚 on 2017/9/21.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import Delta

struct DeleteTodoAction: ActionType {
    let todo: Todo
    
    func reduce(state: State) -> State {
        state.todos.value = state.todos.value.filter {
            $0 != self.todo
        }
        return state
    }
}
