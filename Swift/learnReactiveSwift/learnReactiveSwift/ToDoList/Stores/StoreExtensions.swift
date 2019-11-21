//
//  StoreExtensions.swift
//  learnReactiveSwift
//
//  Created by 王智刚 on 2017/9/19.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import ReactiveSwift
import enum Result.NoError



//MARK: Properties
extension Store {
    var todos: MutableProperty<[Todo]> {
        return state.value.todos
    }
    
    var activeFilter: MutableProperty<TodoFilter> {
        return state.value.filter
    }
    
    var selectedTodoItem: MutableProperty<TodoFilter> {
        return state.value.selectedTodoItem
    }
}

//MRAK: SignalProducers
extension Store {
    var incompleteTodos: SignalProducer<[Todo], NoError> {
        return todos.producer.map { todos in
            return todos.filter { !$0.completed }
        }
    }
    
    var completeTodos: SignalProducer<[Todo], NoError> {
        return todos.producer.map { todos in
            return todos.filter { $0.completed }
        }
    }
    
    var incompleteTodosCount: SignalProducer<Int, NoError> {
        return incompleteTodos.map { $0.count }
    }
    
    var completeTodosCount: SignalProducer<Int, NoError> {
        return completeTodos.map { $0.count }
    }
    
    var notSyncedWithBackendTodos: SignalProducer<[Todo], NoError> {
        return todos.producer.map { todos in
            return todos.filter { !$0.synced}
        }
    }
    
    var selectedTodos: SignalProducer<[Todo], NoError> {
        return todos.producer.map { todos in
            return todos.filter {
                if let selected = $0.selected {
                    return selected
                } else {
                    return false
                }
            }
        }
    }
    
    var allTodosCount: SignalProducer<Int, NoError> {
        return todos.producer.map { return $0.count }
    }
    
    var todoStats: SignalProducer<(Int, Int), NoError> {
        return allTodosCount.zip(with: incompleteTodosCount)
    }
    
    var activeTodos: SignalProducer<[Todo], NoError> {
        return activeFilter.producer.flatMap(.latest, { filter -> SignalProducer<[Todo], NoError> in
            switch filter {
            case .all: return self.todos.producer
            case .active: return self.incompleteTodos
            case .completed: return self.completeTodos
            case .notSyncedWithBackend: return  self.notSyncedWithBackendTodos
            case .selected: return self.selectedTodos
            }
        })
    }
    
    var titleForTodos: SignalProducer<String, NoError> {
        return activeFilter.producer.skipRepeats().map { filter in
            switch filter {
            case .all: return "全部\(self.allTodosCount.single()?.value ?? 0)"
            case .active: return "进行中\(self.incompleteTodosCount.single()?.value ?? 0)"
            case .completed: return "完成\(self.completeTodosCount.single()?.value ?? 0)"
            default:  fatalError()
            }
        }
    }
    
    func producerForTodo(todo: Todo) -> SignalProducer<Todo, NoError> {
        return self.todos.producer.map { todos in
            return todos.filter {  $0 == todo }.first
        }.skipNil()
    }
}
