//
//  DetailsViewController.swift
//  learnReactiveSwift
//
//  Created by 王智刚 on 2017/9/19.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import UIKit
import ReactiveSwift

class DetailsViewController: UIViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var Description: UITextField!
    @IBOutlet weak var notes: UITextField!
    @IBOutlet weak var state: UILabel!
    @IBOutlet weak var stateSwitcher: UISwitch!
    
    var viewModel: TodoViewModel = TodoViewModel(todo: nil) {
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        store.selectedTodos.startWithValues { (todos) in
            if let model = todos.first {
                self.name.text = model.name
                self.viewModel = TodoViewModel(todo: model)
            }
        }
        
        self.state.reactive.text <~ store.selectedTodos.map {
            $0.first?.completed
            }.skipNil()
            .take(untilReplacement: self.stateSwitcher.reactive.isOnValues)
            .map {
            $0 ? "Complete" : "Active"
        }
        
        self.name.reactive.text <~ store.selectedTodos.map {
            $0.first?.name
        }.skipNil()
        self.Description.reactive.text <~ store.selectedTodos.map {
            $0.first?.description
            }.skipNil()
        self.notes.reactive.text <~ store.selectedTodos.map {
            $0.first?.notes
            }.skipNil()
 
        self.stateSwitcher.reactive.isOn <~ store.selectedTodos.map {
            $0.first?.completed
            }.skipNil()
        
        self.name.reactive.continuousTextValues.observeValues { newName in
            if let newName = newName {
                if let originalTodo = self.viewModel.todo {
                    let newTodo = todoNameLens.set(newName, originalTodo)
                    store.dispatch(action: UpdateTodoAciton(todo: newTodo))
                }
            }
        }
        
        self.Description.reactive.continuousTextValues.observeValues { newDescription in
            if let newDescription = newDescription {
                if let originalTodo = self.viewModel.todo {
                    let newTodo = todoDescriptionLens.set(newDescription, originalTodo)
                    store.dispatch(action: UpdateTodoAciton(todo: newTodo))
                }
            }
        }
        
        self.notes.reactive.continuousTextValues.observeValues { newNotes in
            if let newNotes = newNotes {
                if let originalTodo = self.viewModel.todo {
                    let newTodo = todoNotesLens.set(newNotes, originalTodo)
                    store.dispatch(action: UpdateTodoAciton(todo: newTodo))
                }
            }
        }
        
        self.stateSwitcher.reactive.isOnValues.observeValues { complete in
            if let originalTodo = self.viewModel.todo {
                let newTodo = todoCompletedLens.set(complete, originalTodo)
                store.dispatch(action: UpdateTodoAciton(todo: newTodo))
            }
        }
    }
    
    private func loadData() {
        
    }
    
    private func bindEvent() {
        
    }
}
