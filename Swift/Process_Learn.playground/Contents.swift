import Foundation

//let userName = ProcessInfo.processInfo.userName
//print("username: \(userName)")
//
//let fullUserName = ProcessInfo.processInfo.fullUserName
//print("full username: \(fullUserName)")

//let hostName = ProcessInfo.processInfo.hostName
//print("hostname: \(hostName)")
//
//let processorCount = ProcessInfo.processInfo.processorCount
//print("cores: \(processorCount)")
//
//let activeProcessorCount = ProcessInfo.processInfo.activeProcessorCount
//print("active cores: \(activeProcessorCount)")
//
//let physicalMemory = ProcessInfo.processInfo.physicalMemory
//print("memory: \(physicalMemory)")
//
//let systemUptime = ProcessInfo.processInfo.systemUptime
//print("uptime: \(systemUptime)")
//
//let isMultiThreaded = Thread.isMultiThreaded()
//print("threaded: \(isMultiThreaded)")
//
//let operatingSystem = ProcessInfo.processInfo.operatingSystemVersionString
//print("operating system: \(operatingSystem)")

final class WeakProxy: NSObject {
    private(set) weak var target: AnyObject?
    
    init(target: AnyObject?) {
        self.target = target
    }
    
    override class func isProxy() -> Bool {
        return true
    }
    
    
}

final class WeakProxy: NSProxy {
}
