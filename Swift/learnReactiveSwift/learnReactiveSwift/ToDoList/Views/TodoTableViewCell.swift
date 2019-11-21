//
//  TodoTableViewCell.swift
//  learnReactiveSwift
//
//  Created by 王智刚 on 2017/9/19.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import UIKit
import ReactiveSwift

class TodoTableViewCell: UITableViewCell, BaseCell  {    
    @IBOutlet weak var content: UILabel!
    private var todo: Todo?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureWith(value: Todo) {
        self.content.text = todo?.description
    }
}
