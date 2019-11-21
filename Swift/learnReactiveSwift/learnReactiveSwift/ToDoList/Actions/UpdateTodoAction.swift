//
//  UpdateTodoAction.swift
//  learnReactiveSwift
//
//  Created by 王智刚 on 2017/9/21.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import Delta

struct UpdateTodoAciton: ActionType {
    let todo: Todo
    
    func reduce(state: State) -> State {
        state.todos.value = state.todos.value.map { todo in
            guard todo == self.todo else { return todo }
            return Todo(id: todo.id, name: self.todo.name, description: self.todo.description, notes: self.todo.notes, completed: self.todo.completed, synced: !todo.synced, selected: todo.selected)
        }
        return state
    }
    
}
