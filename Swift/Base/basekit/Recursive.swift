//
//  Recursive.swift
//  Basiz
//
//  Created by 王智刚 on 2019/8/28.
//  Copyright © 2019 王智刚. All rights reserved.
//

import UIKit

typealias VoidBlock = () -> Void
typealias RecuriseBlock<T> = (T) -> Void

protocol Recursive {
    associatedtype Element
    func recursiveSearch(in array: [Element], leafBlock: VoidBlock, recuriseBlock: RecuriseBlock<Element>)
}

extension Recursive {
    func recursiveSearch(in array: [Element], leafBlock: VoidBlock, recuriseBlock: RecuriseBlock<Element>) {
        guard array.count > 0 else {
            leafBlock()
            return
        }
        array.forEach { (ele) in
            recuriseBlock(ele)
        }
    }
}

extension CALayer: Recursive {
    typealias Element = CALayer
}

extension UIView: Recursive {
    typealias Element = UIView
}
