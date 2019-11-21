//
//  ViewController.swift
//  faceToProtocol
//
//  Created by 王智刚 on 16/6/4.
//  Copyright © 2016年 w.z.g. All rights reserved.
//

import UIKit

protocol SnakeAble {

}

extension SnakeAble where Self : UIView{
    func snake() {
        let animation = CABasicAnimation(keyPath:"position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = NSValue()
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

