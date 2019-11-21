//
//  ObserveForUI.swift
//  learnReactiveSwift
//
//  Created by 王智刚 on 2017/9/28.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import ReactiveSwift

public extension SignalProtocol {
    public func observeForUI() -> Signal<Value, Error> {
        return self.signal.observe(on: UIScheduler())
    }
}

public extension SignalProducerProtocol {
    public func observeForUI() -> SignalProducer<Value, Error> {
        return self.producer.observe(on: UIScheduler())
    }
}
