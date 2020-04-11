//
//  ThreadHelper.swift
//  data-Base-exercises
//
//  Created by 王智刚 on 2017/7/1.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import Foundation

extension DispatchQueue{
    /// 防止主线程异步死锁
    public func safe_Async(_ block: @escaping()->()) {
        if self === DispatchQueue.main && Thread.isMainThread {
            block()
        }else{
            async {
                block()
            }
        }
    }
}


//线程池
