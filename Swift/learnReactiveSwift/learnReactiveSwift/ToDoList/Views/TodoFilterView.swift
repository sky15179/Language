//
//  TodoFilterView.swift
//  learnReactiveSwift
//
//  Created by 王智刚 on 2017/9/29.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import UIKit

class TodoFilterView: UIView {
    
    @IBOutlet weak var filterInfoLabel: UILabel!
     @IBOutlet weak var filterSwitch: UISwitch!
     @IBOutlet weak var filter: UITextField!
    
    @IBAction func switchChanged(_ sender: UISwitch) {
    }
    @IBAction func filterChanged(_ sender: UITextField) {
    }
}
