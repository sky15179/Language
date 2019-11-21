//
//  TodoLens.swift
//  learnReactiveSwift
//
//  Created by 王智刚 on 2017/9/19.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import UIKit

let todoNameLens: Lens<Todo, String> = Lens(
    get: { $0.name },
    set: {
        Todo(id: $1.id, name: $0, description: $1.description, notes: $1.notes, completed: $1.completed, synced: $1.synced, selected: $1.selected)}
)

let todoDescriptionLens: Lens<Todo, String> = Lens(
    get: { $0.description },
    set: {
        Todo(id: $1.id, name: $1.name, description: $0, notes: $1.notes, completed: $1.completed, synced: $1.synced, selected: $1.selected)
}
)

let todoNotesLens: Lens<Todo, String> = Lens(
    get: { $0.notes ?? "" },
    set: {
        Todo(id: $1.id, name: $1.name, description: $1.description, notes: $0, completed: $1.completed, synced: $1.synced, selected: $1.selected)
}
)

let todoCompletedLens: Lens<Todo, Bool> = Lens(
    get: { $0.completed },
    set: {
        Todo(id: $1.id, name: $1.name, description: $1.description, notes: $1.notes, completed: $0, synced: $1.synced, selected: $1.selected)
}
)

let todoSyncedLens: Lens<Todo, Bool> = Lens(
    get: { $0.synced },
    set: {
        Todo(id: $1.id, name: $1.name, description: $1.description, notes: $1.notes, completed: $1.completed, synced: $0, selected: $1.selected)
}
)
		
