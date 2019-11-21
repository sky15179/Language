//
//  TodoDataSource1.swift
//  learnReactiveSwift
//
//  Created by 王智刚 on 2017/9/28.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import UIKit

class TodoDataSource1: NSObject, UITableViewDataSource {
    
    enum TodoSection: Int {
        case input = 0, todos, max
    }
    
    var todos: [Todo] = []
    weak var owner: (UIViewController & TodoInputTableViewCellDelegate)?
    
    init(todos: [Todo], owner: (UIViewController & TodoInputTableViewCellDelegate)?) {
        self.todos = todos
        self.owner = owner
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return TodoSection.max.rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let section = TodoSection(rawValue: section) else {
            assertionFailure("section错误:不存在")
            return 0
        }
        switch section {
        case .input: return 1
        case .todos: return todos.count
        case .max:
            assertionFailure("section超出错误")
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = TodoSection(rawValue: indexPath.section) else {
            assertionFailure("section错误:不存在")
            return UITableViewCell()
        }
        switch section {
        case .input:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TodoInputTableViewCell") as! TodoInputTableViewCell
            cell.delegate = owner
            return cell
        case .todos:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TodoTableViewCell") as! TodoTableViewCell
            cell.content.text = todos[indexPath.row].description
            return cell
        case .max:
            assertionFailure("section超出错误")
            return UITableViewCell()
        }
    }
}
