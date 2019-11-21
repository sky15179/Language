//
//  ViewController.swift
//  TextParse
//
//  Created by 王智刚 on 2018/10/25.
//  Copyright © 2018年 王智刚. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let text = """
讯😂日前   ，某招聘网站发布《2017年秋季中国雇主需求与白领人才供给报告》  ，报告显示，2017年第三季度，全国37个主要城市的平均薪酬为7599元，环比上升。互联网/电子商务行业依然是对人才需求量最多的行业。随着网络游戏的大火，网络游戏行业的人才竞争也变得异常
"""
        let arr = text.parseByWords()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

