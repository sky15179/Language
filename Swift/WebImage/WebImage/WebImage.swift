//
//  WebImage.swift
//  WebImage
//
//  Created by 王智刚 on 2020/7/7.
//  Copyright © 2020 王智刚. All rights reserved.
//

import UIKit

/*:
 
 */

//MARK: weak代理

final class WeakProxy: NSObject /* & NSProxy */ {

    // 只有继承NSObject类的子类才有消息转发机制，swift基类如果不继承基类，将是静态类，不存在消息动态转发
    private(set) weak var target: NSObject?
    
    static func proxyWithTarget(target: NSObject) -> WeakProxy {
        return WeakProxy.init(target: target)
    }

    convenience init(target: NSObject){
        self.init()
        self.target = target
    }
    
    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        return target
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        return target?.isEqual(object) ?? false
    }
    
    override var hash: Int{
        return target?.hash ?? -1
    }
    
    override var superclass: AnyClass?{
        return target?.superclass ?? nil
    }
    
    override func isProxy() -> Bool {
        return true
    }

    override func isKind(of aClass: AnyClass) -> Bool {
        return target?.isKind(of: aClass) ?? false
    }
    
    override func isMember(of aClass: AnyClass) -> Bool {
        return target?.isMember(of: aClass) ?? false
    }
    
    override func conforms(to aProtocol: Protocol) -> Bool {
        return  target?.conforms(to: aProtocol) ?? false
    }
    
    override func responds(to aSelector: Selector!) -> Bool {
        return target?.responds(to: aSelector) ?? false
    }
    
    override var description: String{
        return target?.description ?? "nil"
    }
    
    override var debugDescription: String{
        return target?.debugDescription ?? "nil"
    }
    
    deinit {
        print("Proxy释放了")
    }
}

//MARK: 集中化管理任务：下载，可处理类似的需要小粒度维护专项任务的情况, 这里是为了方便集中封装任务的取消

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

//MARK: 关联存储对象，作为中介者架起UIKit和图片下载的联系

private class ImageSetter {
    private(set) var sentinel: Int64 = 0
    private(set) var imageUrl: URL?
    private(set) var setterQueue: DispatchQueue

    init() {
        setterQueue = DispatchQueue(label: "image.setter.queue", qos: DispatchQoS.default)
    }
    
    func cancel() -> Int64 {
        return 0
    }
    
    func cancelWithNewUrl(url: URL) -> Int64 {
        self.imageUrl = url
        return 0
    }
}

//MARK: 集中化管理任务：下载，可处理类似的需要小粒度维护专项任务的情况, 这里是为了方便集中封装任务的取消

extension OperationQueue {
    convenience init(qualityOfService: QualityOfService = .default,
                     maxConcurrentOperationCount: Int = OperationQueue.defaultMaxConcurrentOperationCount,
                     underlyingQueue: DispatchQueue? = nil,
                     name: String? = nil,
                     startSuspended: Bool = false) {
        self.init()
        self.qualityOfService = qualityOfService
        self.maxConcurrentOperationCount = maxConcurrentOperationCount
        self.underlyingQueue = underlyingQueue
        self.name = name
        isSuspended = startSuspended
    }
}

final class ImageDownloadOperation: Operation, URLSessionDownloadDelegate {
    
    //MARK:Property - Private
    
    private var netWorkThread: Thread?
    private var session: URLSession?
    private var lock = NSRecursiveLock()
    
    //MARK:LifeStyle
    
    required init(request: URLRequest) {
        super.init()
        netWorkThread = Thread(target: self, selector: #selector(networkThreadMain), object: nil)
        netWorkThread?.qualityOfService = .background
        let config = URLSessionConfiguration.default
        let credentialStorage = URLCredentialStorage()
        config.urlCredentialStorage = credentialStorage
        let delegateQueue = OperationQueue(maxConcurrentOperationCount: 1, underlyingQueue: DispatchQueue(label: "rootQueue"), name: "sessionDelegateQueue")
        session = URLSession(configuration: config, delegate: WeakProxy(target: self) as? URLSessionDelegate, delegateQueue: delegateQueue)

    }
    
    //MARK:Method - Private
    
    @objc private func networkThreadMain() {
        autoreleasepool {
            Thread.current.name = "image.download"
            let runloop = RunLoop.current
            runloop.add(Port(), forMode: RunLoop.Mode.default)
            runloop.run()
        }
    }
    
    //MARK:SessionDelegate
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        try? FileManager.default.contents(atPath: location.absoluteString)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
    }
    
    //MARK:Override
    
    override func start() {
        autoreleasepool {
            lock.lock()
            defer { lock.unlock() }
            lock.unlock()
        }
    }
    
    override func cancel() {
        
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override var description: String {
        return " \(String(describing: self)) executing:\(self.isExecuting) finish: \(self.isFinished) cancelled:\(self.isCancelled)"
    }
    
    override var isConcurrent: Bool {
        return true
    }
    
    override var isCancelled: Bool {
        return false
    }
}


//MARK: 核心
/*
 */

final class Cache {
    
}

final class DownloadImage {
    func download(url: String) {
        let task = URLSessionDownloadTask()
    }
}

final class ImagePrefetch {
    
}

final class AImage {
    //加载优化
    func asyncLoadImage(block: @escaping ((UIImage?, Bool) -> Void)) {
        DispatchQueue.global().async {
            if let path = Bundle.main.path(forResource: "testImge", ofType: "png") {
                let image = UIImage(contentsOfFile: path)
                DispatchQueue.main.sync {
                    block(image, true)
                }
            } else {
                block(nil, false)
            }
        }
    }
    
    //解压优化：异步强制解压为位图，图片处理时注意有效性（宽，高）
    func unpack(image: CGImage, context: CGContext) {
//        CGBitmapContextCreate
//        CGContext(data: <#T##UnsafeMutableRawPointer?#>, width: <#T##Int#>, height: <#T##Int#>, bitsPerComponent: <#T##Int#>, bytesPerRow: <#T##Int#>, space: <#T##CGColorSpace#>, bitmapInfo: <#T##UInt32#>)
    }
}



//MARK: 业务支持

extension UIImageView {
    func set_image(url: String) {
    }
}
