//
//  CALayer+Extension.swift
//  Basiz
//
//  Created by 王智刚 on 2019/8/29.
//  Copyright © 2019 王智刚. All rights reserved.
//

import UIKit

extension CALayer {
    @objc func tintColor(_ color: UIColor) {
        recursiveSearch(in: self.sublayers ?? [], leafBlock: {
            backgroundColor = color.cgColor
        }) {
            $0.tintColor(color)
        }
    }
}
