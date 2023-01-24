//
//  WebSocketManager.swift
//  NostrID
//
//  Created by Erdal Toprak on 21/01/2023.
//

import Foundation
import Starscream
import SwiftUI

class WebSocketManager: WebSocketDelegate, ObservableObject {
    
    static let shared = WebSocketManager()
    var socket: WebSocket!
    @Published var isConnected = false
    @AppStorage(UserDefaultKeys.relay) var relay: String!
    
    func connect() {
        print("RELAY = \(relay ?? "wss://relay.damus.io")")
        let request = URLRequest(url: URL(string: relay)!)
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
    }
    
    func disconnect() {
        print("DISCONNECTED")
        isConnected = false
        socket?.disconnect()
        socket = nil
    }
    
    func sendMessage(_ message: String) {
        socket?.write(string: message)
        print(message)
    }
    
    func didReceive(event: Starscream.WebSocketEvent, client: Starscream.WebSocketClient) {
        switch event {
        case .connected(let headers):
            print("Websocket is connected: \(headers)")
            WebSocketManager.shared.sendMessage(NostrReq.shared.createReq())
            isConnected = true
        case .disconnected(let reason, let code):
            print("Websocket is disconnected: \(reason) with code: \(code)")
            isConnected = false
        case .text(let string):
            print("============RECEIVED EVENT============")
            NostrEvent.shared.nostrResponseParse(response: string)

        case .binary(let data):
            print("Received data: \(data.count)")
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            break
        case .error(let error):
            isConnected = false
            print("Error: \(String(describing: error?.localizedDescription))")
        }
    }
}

