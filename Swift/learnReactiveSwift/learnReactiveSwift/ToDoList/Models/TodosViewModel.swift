//
//  TodosViewModel.swift
//  learnReactiveSwift
//
//  Created by 王智刚 on 2017/9/19.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import UIKit

struct TodosViewModel {
    let todos: [Todo]
    func todoForIndexPath(indexPath: IndexPath) -> Todo {
        return todos[indexPath.row]
    }
}
