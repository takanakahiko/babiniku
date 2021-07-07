//
//  UDPSender.swift
//  BabinikuiOS
//
//  Created by takanakahiko on 2021/05/27.
//

import Foundation
import Network

class UDPSender {
    
    private var connection: NWConnection
    
    init(address: String, portNum: UInt16) {
        connection = NWConnection(
            host: NWEndpoint.Host(address),
            port: NWEndpoint.Port(rawValue: portNum)!,
            using: NWParameters.udp
        )
        connection.stateUpdateHandler = { (state: NWConnection.State) in
            switch state {
            case .ready:
                break
            case .waiting(let error):
                print(error)
            case .failed(let error):
                print(error)
            default:
                break
            }
        }
        connection.start(queue: DispatchQueue(label: "UDPSender"))
    }
    
    func send(message: String) {
        let data = message.data(using: .utf8)
        let completion = NWConnection.SendCompletion.contentProcessed { (error: NWError?) in
            if let error = error {
                print(error)
            }
        }
        connection.send(content: data, completion: completion)
    }
}
