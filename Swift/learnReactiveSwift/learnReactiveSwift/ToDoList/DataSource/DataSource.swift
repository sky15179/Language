//
//  DataSource.swift
//  learnReactiveSwift
//
//  Created by 王智刚 on 2017/9/26.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import UIKit
import ReactiveSwift
import enum Result.NoError

class DataSource<T>: NSObject, UITableViewDataSource {
    
    enum Section: Int {
        case input = 0, todos, max
    }
    
    var todos: [T]
    weak var owner: UIViewController?
    
    init(todos: [T], owner: UIViewController?) {
        self.todos = todos
        self.owner = owner
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.max.rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let secion = Section(rawValue: section) else {
            fatalError()
        }
        switch secion {
        case .input: return 1
        case .todos: return todos.count
        case .max: fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell") ?? TodoTableViewCell(style: .default, reuseIdentifier: "todoCell")
        if let cell = cell as? TodoTableViewCell {
            if let todo = todos[indexPath.row] as? Todo {
                cell.configureWith(value: todo)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    

}
