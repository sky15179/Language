//
//  ViewController.swift
//  Download
//
//  Created by 王智刚 on 2020/7/14.
//  Copyright © 2020 王智刚. All rights reserved.
//

import UIKit

//简化请求流程：关注核心，各自请求及回调流程，加密，优化，不涉及复杂对象化

class ViewController: UIViewController, URLSessionWebSocketDelegate {
    
    private let session = URLSession(configuration: URLSessionConfiguration.default)
    private var task: URLSessionWebSocketTask?
    private var price = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        //配置超时值、缓存策略、连接要求及自定义对象
//    var config = URLSessionConfiguration()
//        config.
//    let session = URLSession(configuration: <#T##URLSessionConfiguration#>, delegate: <#T##URLSessionDelegate?#>, delegateQueue: <#T##OperationQueue?#>)
//    }
        //需要心跳校验
        //没有加密，SSL,TSL,是底层做了吗，NetWork有TSL(比SSL更新的加密协议): 核心都是
        //1.服务端使用非对称加密向发送客户端公钥和CA证书
        //2.客户端从CA验证证书，根据对称加密生成密匙，使用服务端公钥发送信息加密密钥
        //3.服务端私钥解密获得通信加密密匙，之后的通信都使用这个密匙
        
        //注意：
        //1.这是单项认证
        //2.通信中，服务端开启加密认证，先给客户端返回401码，客户端再从代理中执行加密认证流程，方法是: Authentication Challenges
//        func urlSession(URLSession, didReceive: URLAuthenticationChallenge, completionHandler: (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) 这里还需处理的是URLCredential,这个类可以自定义来实现一系列的证书认证工作包括域名验证，系统默认会有处理也可使用默认
    
    }
    
    func connect() {
        stop()
        //websocket
        task = session.webSocketTask(with: URL(string: "wss://ws.finnhub.io?token=XYZ")!)
        task?.resume()
        sendMessage()
        receiveMsg()
    }
    
    func sendMessage() {
        let string = "{\"type\":\"subscribe\",\"symbol\":\"BINANCE:BTCUSDT\"}"
        task?.send(.string(string), completionHandler: { (error) in
            
        })
    }
    
    func checkAlive() {
        task?.sendPing(pongReceiveHandler: { [weak self] (error) in
            if let error = error {
                self?.stop()
            }
        })
    }
    
    func receiveMsg() {
        task?.receive(completionHandler: { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(.string(let str)):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(APIResponse.self, from: Data(str.utf8))
                    DispatchQueue.main.async{
                        self.price = "\(result.data[0].p)"
                    }
                } catch {
                      print("error is \(error.localizedDescription)")
                }
                self.receiveMsg()
            case .failure(let error): print(error)
            default:
                print("default")
            }
        })
    }
    
    func stop() {
        task?.cancel(with: .goingAway, reason: nil)
    }
}

struct APIResponse: Codable {
    var data: [PriceData]
    var type : String
    
    private enum CodingKeys: String, CodingKey {
        case data, type
    }
}

struct PriceData : Codable{
    
    public var p: Float
    
    private enum CodingKeys: String, CodingKey {
        case p
    }
}
