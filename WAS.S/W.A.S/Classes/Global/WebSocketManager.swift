//
//  WebSocketManager.swift
//  Weather Accommodation
//
//  Created by macmini-1 on 04/09/19.
//  Copyright © 2019 JBSoluions - Renish Dadhaniya. All rights reserved.
//

import UIKit
import Starscream

protocol SocketConnectionDelegate {
    func onDisconnect(socket: WebSocketClient, error: Error?)
    func onMessage(socket: WebSocketClient, text: String)
    func onConnect(socket: WebSocketClient)
}


//PROVIDER
let ACTIVATEPROVIDER = "ProviderAPI/ActivateProvider?"
//BOTH
let CLIENTPROVIDERCONNECTION = "ProviderAPI/ClientProviderConnection?"
//CLIENT
let GETONLINEPROVIDERSTATUS = "ProviderAPI/CommonProviderData"



class WebSocketManager: NSObject {
    
    var clientCommonDataSocket : WebSocket!
    var providerConnectionSocket : WebSocket!
    var clientproviderRequestSocket : WebSocket!
    
  //  var socket: WebSocket!
    var delegate: SocketConnectionDelegate?
   
    class var sharedInstance: WebSocketManager {
        
        struct Static {
            static let instance = WebSocketManager()
        }
        return Static.instance
    }
    
//    override init() {
//        super.init()
//
//    }
    
    func connectToGettingStatusUpdatesFromClient(with requestURL:String) {
        let request = URLRequest(url: URL(string:"\(RDDataEngineClass.ApplicationWebSocketURL)\(requestURL)")!)
        clientCommonDataSocket = WebSocket(request: request)
        if clientCommonDataSocket.delegate == nil {
            clientCommonDataSocket.delegate = self
        }
        self.connectSocket(socket: clientCommonDataSocket)
    }
    
    func connectProviderSocket(with requestURL:String) {
        let request = URLRequest(url: URL(string:"\(RDDataEngineClass.ApplicationWebSocketURL)\(requestURL)")!)
        providerConnectionSocket = WebSocket(request: request)
        
        if providerConnectionSocket.delegate == nil {
            providerConnectionSocket.delegate = self
        }
        self.connectSocket(socket: providerConnectionSocket)
    }
    
    func connectClientProviderRequestSocket(with requestURL:String) {
        let request = URLRequest(url: URL(string:"\(RDDataEngineClass.ApplicationWebSocketURL)\(requestURL)")!)
        clientproviderRequestSocket = WebSocket(request: request)
        if clientproviderRequestSocket.delegate == nil {
            clientproviderRequestSocket.delegate = self
        }
        self.connectSocket(socket: clientproviderRequestSocket)
    }
    
//    func setSocketRequest(with requestURL:String)  {
//
//        let request = URLRequest(url: URL(string:"\(RDDataEngineClass.ApplicationWebSocketURL)\(requestURL)")!)
//        socket = WebSocket(request: request)
//        if socket.delegate == nil {
//            socket.delegate = self
//        }
//
//        self.connectSocket()
//    }
    
    func disconnectSocket(socket : WebSocket) {
        if socket.isConnected {
            socket.disconnect()
        }
    }
    
    func connectSocket(socket : WebSocket) {
        if !socket.isConnected {
            socket.connect()
        }
    }
}

extension WebSocketManager : WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        print("websocket is connected")
        delegate?.onConnect(socket: socket)
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        if let e = error as? WSError {
            print("websocket is disconnected: \(e.message)")
        } else if let e = error {
            print("websocket is disconnected: \(e.localizedDescription)")
        } else {
            print("websocket disconnected")
        }
        delegate?.onDisconnect(socket: socket, error: error)
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("Received text: \(text)")
      //  NotificationCenter.default.post(name: NSNotification.Name(rawValue: RDDataEngineClass.ReceivedClientPing), object: nil, userInfo: ["text":text])
        delegate?.onMessage(socket: socket, text: text)
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        
    }
}
