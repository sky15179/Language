//
//  AsyncLayer.swift
//  AsyncLayer
//
//  Created by 王智刚 on 2020/7/3.
//  Copyright © 2020 王智刚. All rights reserved.
//

import UIKit

private func getReleaseQueue () -> DispatchQueue {
    var maxCount: Int64 = 16
    var queues: [DispatchQueue] = []
    var counter: Int64 = 0
    DispatchQueue.once(token: "create queues") {
        maxCount = Int64(ProcessInfo.processInfo.activeProcessorCount)
        for _ in 0..<maxCount {
            let queue = DispatchQueue(label: "AsyncDispalyQueue")
            queues.append(queue)
        }
    }
    let cur = OSAtomicIncrement64(&counter)
    return queues[Int(cur % maxCount)]
}

private func getDisplayQueue () -> DispatchQueue {
    
    return DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
}

protocol AsyncLayerDelegateProtocol {
    func createLayerDisplayTask() -> AsyncDisplayTask
}

final class AsyncLayer: CALayer {
    
    //MARK: Property - Public
    
    var displayAsync = true
    
    //MARK: Property - Private
    
    private var sentinel = Sentinel()
    
    //MARK: Init
    
    override init() {
        super.init()
        self.contentsScale = UIScreen.main.scale
    }
    
    deinit {
        sentinel.increase()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Override
    
    override class func defaultValue(forKey key: String) -> Any? {
        if key == "displayAsync" {
            return true
        } else {
            return super.defaultValue(forKey: key)
        }
    }
    
    override func setNeedsLayout() {
        cancelDisplay()
        super.setNeedsLayout()
    }
    
    override func display() {
        super.contents = super.contents
        self._displayAsync(async: displayAsync)
    }
    
    //MARK: Method - Private
    
    private func cancelDisplay() {
        self.sentinel.increase()
    }
    
    private func _displayAsync(async: Bool) {
        guard let delegate = self.delegate as? AsyncLayerDelegateProtocol else { return }
        let task = delegate.createLayerDisplayTask()
        guard let context = UIGraphicsGetCurrentContext(), task.display != nil else {
            task.willDisplay?(self)
            self.contents = nil
            task.didDisplay?(self, true)
            return
        }
        
        let value = sentinel.value
        let size = self.bounds.size
        let opaque = self.isOpaque
        let scale = self.contentsScale
        let backgroundColor = opaque && (self.backgroundColor != nil) ? self.backgroundColor : nil
        
        @inline(__always)
        func setupBackgroundColor(context: CGContext) {
            if opaque {
                context.saveGState()
                if backgroundColor == nil || backgroundColor?.alpha ?? 0 < 1 {
                    context.setFillColor(UIColor.white.cgColor)
                    context.addRect(CGRect(x: 0, y: 0, width: size.width * scale, height: size.height * scale))
                    context.fillPath()
                }
                if let backgroundColor = backgroundColor {
                    context.setFillColor(backgroundColor)
                    context.addRect(CGRect(x: 0, y: 0, width: size.width * scale, height: size.height * scale))
                    context.fillPath()
                }
                context.restoreGState()
            }
        }
        
        if async {
            if size.width < 1 || size.height < 1 {
                self.contents = nil
                task.didDisplay?(self, true)
                return
            }
            let isCancelled: () -> Bool = {
                return value != self.sentinel.value
            }
            task.willDisplay?(self)
            getDisplayQueue().async {
                if isCancelled() {
                    return
                }
                UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
                defer {
                    UIGraphicsEndImageContext()
                }
                setupBackgroundColor(context: context)
                task.display?(context, size, isCancelled)
                var image = UIGraphicsGetImageFromCurrentImageContext()
                if isCancelled() {
                    DispatchQueue.main.async {
                        task.didDisplay?(self, false)
                    }
                    return
                }
                DispatchQueue.main.async {
                    if isCancelled() {
                        task.didDisplay?(self, false)
                    } else {
                        self.contents = image?.cgImage
                        task.didDisplay?(self, true)
                    }
                    image = nil
                }
            }
        } else {
            sentinel.increase()
            task.willDisplay?(self)
            UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
            defer {
                UIGraphicsEndImageContext()
            }
            setupBackgroundColor(context: context)
            let cancel: () -> Bool = { return false }
            task.display?(context, size, cancel)
            var image = UIGraphicsGetImageFromCurrentImageContext()
            self.contents = image?.cgImage
            image = nil
            task.didDisplay?(self, true)
        }
    }
}

private final class Sentinel {
    private(set) var value: Int64 = 0
    
    func increase() {
        OSAtomicIncrement64(&value)
    }
}

final class AsyncDisplayTask {
    var willDisplay: ((CALayer) -> Void)?
    var display: ((_ context: CGContext, _ size: CGSize, _ cancel: () -> Bool) -> Void)?
    var didDisplay: ((_ layer: CALayer, _ finish: Bool) -> Void)?
}

extension DispatchQueue {
    fileprivate static var _onceToken: [String] = []
    static func once(token: String, block: () -> Void) {
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        if _onceToken.contains(token) {
            return
        }
        _onceToken.append(token)
        block()
    }
}
