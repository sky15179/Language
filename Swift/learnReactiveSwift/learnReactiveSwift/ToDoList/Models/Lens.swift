//
//  Lens.swift
//  learnReactiveSwift
//
//  Created by 王智刚 on 2017/9/30.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import UIKit

public struct Lens<Whole, Part> {
    let get: (Whole) -> Part
    let set: (Part, Whole) -> Whole
    
    public init(get: @escaping (Whole) -> Part, set: @escaping (Part, Whole) -> Whole) {
        self.get = get
        self.set = set
    }
    
    func over(_ f: @escaping (Part) -> Part) -> ((Whole) -> Whole) {
        return { whole in
            let part = self.get(whole)
            return self.set(f(part),whole)
        }
    }
    
}
