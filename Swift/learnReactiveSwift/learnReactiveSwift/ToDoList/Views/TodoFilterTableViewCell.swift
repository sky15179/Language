//
//  TodoFilterTableViewCell.swift
//  learnReactiveSwift
//
//  Created by 王智刚 on 2017/9/29.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import UIKit

protocol TodoFilterTableViewCellDelegate: class {
    func filter(with text: String?)
}

class TodoFilterTableViewCell: UITableViewCell {
    weak var delegate: TodoFilterTableViewCellDelegate?
    @IBOutlet weak var filter: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func textChanged(_ sender: UITextField) {
        self.delegate?.filter(with: sender.text)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
