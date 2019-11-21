//
//  Todo.swift
//  learnReactiveSwift
//
//  Created by 王智刚 on 2017/9/19.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import Curry
import Argo

enum TodoFilter: Int {
    case all
    case active
    case completed
    case notSyncedWithBackend
    case selected
}

struct Todo: Equatable {
    let id: Int
    let name: String
    let description: String
    let notes: String?
    let completed: Bool
    let synced: Bool
    let selected: Bool?
}

func == (lhs: Todo, rhs: Todo) -> Bool {
    return lhs.id == rhs.id
}

func != (lhs: Todo, rhs: Todo) -> Bool {
    return lhs.id != rhs.id
}
