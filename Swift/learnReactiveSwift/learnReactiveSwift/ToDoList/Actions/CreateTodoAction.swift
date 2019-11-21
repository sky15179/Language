//
//  CreateTodoAction.swift
//  learnReactiveSwift
//
//  Created by 王智刚 on 2017/9/21.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import Delta

struct CreateTodoAction: ActionType {
    let id: Int
    let name: String
    let description: String
    let notes: String
    
    var todo: Todo {
        return Todo(id: id, name: name, description: description, notes: notes, completed: false, synced: false, selected: false)
    }
    
    
    func reduce(state: State) -> State {
        state.todos.value = state.todos.value + [todo]
        return state
    }
}
