//
//  Sort.swift
//  data-Base-exercises
//
//  Created by 王智刚 on 2017/6/22.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import Foundation

//基本排序
func bubbleSort(arr:inout [Int]) {
    for i in 0..<arr.count {
        for j in stride(from: arr.count - 1 - i, to: 0, by: -1) {
            if j == 0 {
                break
            }
            if arr[j] > arr[j - 1] {
                swap(&arr[j], &arr[j-1])
            }
        }
    }
}
