//
//  TodoViewController.swift
//  learnReactiveSwift
//
//  Created by 王智刚 on 2017/9/19.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

class TodoViewController: UIViewController {
    @IBOutlet weak var todoTable: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    let dataSource = DataSource(todos: [], owner: nil)
    var viewModel: TodosViewModel = TodosViewModel(todos: []) {
        didSet {
            todoTable.reloadData()
        }
    }
    
    enum Command: CommandType {
        case loadTodos(completion: ([Todo]) -> Void)
        case someOtherCommand
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //UI设置
        setupUI()
        dataSource.todos = dummy
        dataSource.owner = self
        todoTable.dataSource = dataSource
        store.activeFilter.producer.startWithValues { (filter) in
            self.segment.selectedSegmentIndex = filter.rawValue
        }
        store.activeTodos.startWithValues { [weak self] (todos) in
            self?.viewModel = TodosViewModel(todos: todos)
        }
        
        //初始化UI
        store.state.signal.observe(on: UIScheduler())
            .skipRepeats { state, previousState in
                state.todos.value == previousState.todos.value
            }.map{ (state: State) -> [Todo] in
                state.todos.value
            }.observeValues { todos in
        }
        //加载数据
        store.dispatch(action: LoadTodosAction(todos: []))
        bindEvent()
    }
    
    //MARK: Private
    
    private func setupUI() {
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .automatic
            navigationItem.hidesSearchBarWhenScrolling = true
        } else {
            
        }
    }
    
    private func bindEvent() {
        segment.reactive.selectedSegmentIndexes.skipRepeats().observeValues { (index) in
            guard let newFilter = TodoFilter(rawValue: index) else { return }
            store.dispatch(action: SetFilterAction(filter: newFilter))
        }
//        store.titleForTodos.startWithValues { title in
//            self.title = title
//        }
    }
}

extension TodoViewController {
    @IBAction func addTapped(sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "create", message: "create a new todo", preferredStyle: .alert)
        alertController.addTextField { (TextField) in
            TextField.placeholder = "id"
        }
        alertController.addTextField { (TextField) in
            TextField.placeholder = "name"
        }
        alertController.addTextField { (TextField) in
            TextField.placeholder = "description"
        }
        alertController.addTextField { (TextField) in
            TextField.placeholder = "notes"
        }
        alertController.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { _ in }))
        alertController.addAction(UIAlertAction(title: "create", style: .default, handler: { _ in
            guard let id = alertController.textFields?[0].text, let name = alertController.textFields?[1].text, let description = alertController.textFields?[2].text, let notes = alertController.textFields?[3].text else {
                return
            }
            store.dispatch(action: CreateTodoAction(id: Int(id) ?? 0, name: name, description: description, notes: notes))
        }))
        self.present(alertController, animated: true, completion: nil)
    }
}

extension TodoViewController: UITableViewDelegate {
    
    //MARK: UITableViewDataSource & UITableViewDelegate
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { (action, _) in
            let todo = self.viewModel.todoForIndexPath(indexPath: indexPath)
            store.dispatch(action: DeleteTodoAction(todo: todo))
        }
        delete.backgroundColor = .red
        
        let details = UITableViewRowAction(style: .normal, title: "Detail") { (action, _) in
            let todo = self.viewModel.todoForIndexPath(indexPath: indexPath)
            store.dispatch(action: DetailsTodoAction(todo: todo))
            let detailVc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailVc")
            self.navigationController?.pushViewController(detailVc, animated: true)
        }
        return [delete, details]
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let todo = viewModel.todoForIndexPath(indexPath: indexPath)
        store.dispatch(action: ToggleCompletedAction(todo: todo))
    }
}

