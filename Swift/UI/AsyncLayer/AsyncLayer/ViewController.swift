//
//  ViewController.swift
//  AsyncLayer
//
//  Created by 王智刚 on 2020/7/3.
//  Copyright © 2020 王智刚. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CALayerDelegate, AsyncLayerDelegateProtocol {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let layer = AsyncLayer()
        layer.delegate = self
    }

    func createLayerDisplayTask() -> AsyncDisplayTask {
        let task = AsyncDisplayTask()
        task.willDisplay = { _ in
            print("开始绘图")
        }
        
        task.display = { context, size, cancel in
            if cancel() { return }
            context.saveGState()
            //coregraphic画图
//            context.draw(<#T##image: CGImage##CGImage#>, in: <#T##CGRect#>)
            context.restoreGState()
        }
        
        task.didDisplay = { (_, finish) in
            print("结束绘图")
        }
        return task
    }
}
