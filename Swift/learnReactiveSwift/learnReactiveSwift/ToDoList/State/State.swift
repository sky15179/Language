//
//  State.swift
//  learnReactiveSwift
//
//  Created by 王智刚 on 2017/9/19.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import ReactiveSwift
import Result
import Delta
import AwesomeCache

private let initialTodos: [Todo] = []

struct State {
    let todos = MutableProperty(initialTodos)
    let filter = MutableProperty(TodoFilter.all)
    let notSynced = MutableProperty(TodoFilter.notSyncedWithBackend)
    let selectedTodoItem = MutableProperty(TodoFilter.selected)
    
    //TODO: Cache
//    init() {
//        todos.signal.observeValues { (todos) in
//            do {
//                let cache = try Cache<NSString>(name: "toDoList")
//                cache["id"] = NSString()
//            } catch {
//
//            }
//        }
//    }
}

//MARK: Extension
extension MutableProperty: Delta.ObservablePropertyType {
    public typealias ValueType = Value
}

