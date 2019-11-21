//
//  TodoInputTableViewCell.swift
//  learnReactiveSwift
//
//  Created by 王智刚 on 2017/9/28.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import UIKit

protocol TodoInputTableViewCellDelegate: class {
    func inputTextChange(cell: TodoInputTableViewCell, text: String)
}

class TodoInputTableViewCell: UITableViewCell, BaseCell {

    @IBOutlet weak var input: UITextField!
    weak var delegate: TodoInputTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func valueChange(_ sender: UITextField, forEvent event: UIEvent) {
        delegate?.inputTextChange(cell: self, text: sender.text ?? "")
    }
    //MARK: Public
    func configureWith(value: Todo) {
        
    }

}
