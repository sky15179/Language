//
//  PrintLog.swift
//  testSwift
//
//  Created by user on 16/3/11.
//  Copyright © 2016年 testSwift. All rights reserved.
//

import Foundation

public func printLog<T>(_ messgae:T,
    file: String = #file,
    method: String = #function,
    line: Int = #line){
//        #if DEBUG
            print("log输出的文件:\((file as NSString).lastPathComponent),行号:\(line),方法:\(method)")
//        #endif
}


