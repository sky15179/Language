//
//  ViewController.swift
//  WebImage
//
//  Created by 王智刚 on 2020/7/7.
//  Copyright © 2020 王智刚. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        let weak = WeakProxy(target: NSString(string: "测试123"))
//        let op = ImageDownloadOperation(request: URLRequest(url: URL(string: "http://www.baidu.com")!))
        print("\(String(describing: self))")
        print("个数:\(OperationQueue.defaultMaxConcurrentOperationCount)")
        print(ProcessInfo.processInfo.activeProcessorCount)
    }
    
    func textRequest() {
        
    }
}

