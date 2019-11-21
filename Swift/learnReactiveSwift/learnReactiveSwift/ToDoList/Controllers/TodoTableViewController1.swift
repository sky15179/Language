//
//  TodoTableViewController1.swift
//  learnReactiveSwift
//
//  Created by 王智刚 on 2017/9/28.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import UIKit

protocol TodoActionType {}
protocol TodoStateType {}
protocol TodoCommandType {}



enum TodoAction: TodoActionType {
    case addTodo(Todo)
    case deleteTodo(Int)
    case changeText(String)
}

struct TodoState: TodoStateType {
    var dataSource: TodoDataSource1
    var text: String //决定textfield enable,toTodo
}

struct  TodoCommand: TodoCommandType {
}

var dummy: [Todo] = {
    var arr: [Todo] = []
    for index in 1...5 {
        let todo = Todo(id: index, name: "name\(index)", description: "description\(index)", notes: "notes\(index)", completed: false, synced: false, selected: false)
        arr.append(todo)
    }
    return arr
}()



class TodoStore<S: TodoStateType, A: TodoActionType, C: TodoCommandType> {
    let reducer: (_ state: S, _ aciton: A) -> S
    var state: S
    
    init(reducer: @escaping(S,A) -> S, initialState: S) {
        self.state = initialState
        self.reducer = reducer
    }
    
    func dispatch(action: A) {
        state = self.reducer(state, action)
    }
}

class TodoTableViewController1: UIViewController, UITableViewDelegate, TodoInputTableViewCellDelegate {
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var addBarItem: UIBarButtonItem!
    var todoState = TodoState(dataSource: [], text: "") {
        //现在的viewmodel也是这样的
        didSet {
            if oldValue.todos != todoState.todos {
                self.tableView.reloadData()
                title = "TODO - \(todoState.todos.count)"
            }
            
            if oldValue.text != todoState.text {
                let inputIndexPath = IndexPath(row: 0, section: TodoDataSource1.TodoSection.input.rawValue)
                if let inputCell = tableView.cellForRow(at: inputIndexPath) as? TodoInputTableViewCell {
                    inputCell.input.text =  todoState.text
                    addBarItem.isEnabled = todoState.text.count >= 3
                }
            }
        }
    }
    
    var todoStore: TodoStore<TodoState, TodoAction, TodoCommand>!
    lazy var reducer: (TodoState, TodoAction) -> TodoState = {
        [weak self] (previousState: TodoState, aciton: TodoAction) in
        var newState = previousState
        switch aciton {
        case let .addTodo(todo):
            let newDataSource = TodoDataSource1(todos: todoState.dataSource.todos + [todo], owner: todoState.dataSource.owner)
            newState = TodoState(dataSource: todoState.dataSource.todos + [todo], text: todoState.text)
        case let .deleteTodo(index):
            newState = TodoState(dataSource: Array(todoState.dataSource.todos[..<index]) + Array(todoState.dataSource.todos[index...]), text: todoState.text)
        case let .changeText(text):
            newState = TodoState(dataSource: todoState.dataSource, text: text)
        }
        return newState
    }
    
    var currentText: String = ""
    
    func stateChange(state: TodoState, previousState: TodoState) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dataSource = TodoDataSource1(todos: [], owner: nil)
        let state = TodoState(dataSource: dataSource, text: "")
        todoStore = TodoStore(reducer: reducer, initialState: state)
        
    }
    
    @IBAction func addActino(_ sender: UIBarButtonItem) {
        let lastId = todoState.todos.last?.id ?? 0
        let new = Todo(id: lastId + 1, name: "name\(lastId)", description: "description\(todoState.text)", notes: "notes\(lastId)", completed: false, synced: false, selected: false)
        todoState = TodoState(todos: [new] + todoState.todos, text: "")
        store.dispatch(action: TodoAction.addTodo(new))
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newArray = Array(todoState.todos[..<indexPath.row] + todoState.todos[(indexPath.row + 1)...])
        todoStore.dispatch(action: TodoAction.deleteTodo(indexPath.row))
    }
    
    func inputTextChange(cell: TodoInputTableViewCell, text: String) {
        todoStore.dispatch(action: TodoAction.changeText(text))
    }
    
}
