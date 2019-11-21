//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

private let cellID = "cellID"

class GenericVc: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let table = UITableView()
    var reuseIDs = Set<String>()
    
    override func viewDidLoad() {
        table.delegate = self
        table.dataSource = self
        table.frame = view.bounds
        view.addSubview(table)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !reuseIDs.contains(cellID) {
            table.register(UITableViewCell.Type, forCellReuseIdentifier: cellID)
            reuseIDs.insert(cellID)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, indexPath: indexPath)
        cell.textLable.text = "测试"
        return cell
    }
}

let vc = GenericVc()

PlaygroundPage.current.liveView = vc