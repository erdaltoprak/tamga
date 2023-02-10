//
//  NostrRelay.swift
//  NostrID
//
//  Created by Erdal Toprak on 31/01/2023.
//

import Foundation
import Dispatch
import Starscream

class Relay: WebSocketDelegate, Identifiable, ObservableObject{
    var socket: WebSocket!
    @Published var id = UUID()
    @Published var url: URL
    //  0 false / 2 reconnecting / 3 true
    @Published var connectionState = 0
    let timer = DispatchSource.makeTimerSource(queue: .global())
    
    init(url: URL) {
        self.url = url
        connect()
        continousReconnect()
    }

    func didReceive(event: WebSocketEvent, client: WebSocketClient) {
        switch event {
        case .connected:
            print("WebSocket connected to \(url)")
            connectionState = 3
        case .disconnected:
            print("WebSocket disconnected from \(url)")
            connectionState = 0
        case .text(let text):
            print("========================")
            print("Received text message from \(url)")
            print("\(text)")
            NostrEvent.shared.nostrResponseParse(response: text)
            print("========================")
        case .pong(_):
            print("Received PONG from \(url)")
        default:
            break
        }
    }
    
    func connect() {
        let request = URLRequest(url: self.url)
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
//        print("WebSocket is connecting to \(url)")
    }
    
    func disconnect() {
//        print("WebSocket disconnected to \(url)")
        DispatchQueue.main.async {
            self.connectionState = 0
        }
        socket?.disconnect()
        socket = nil
    }
    
    func continousReconnect() {
        timer.schedule(deadline: .now() + 5, repeating: .seconds(10))
        timer.setEventHandler { [weak self] in
            guard let self = self else { return }
            if self.connectionState == 0 || self.connectionState == 2{
                self.disconnect()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.connectionState = 2
                    self.connect()
                }
            }
        }
        timer.resume()
    }
    
    func ping(){
        socket.write(ping: NSData() as Data)
    }
    
    func sendMessage(_ message: String){
        socket?.write(string: message)
        print(message)
    }
    
}
