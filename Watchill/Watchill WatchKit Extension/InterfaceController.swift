//
//  InterfaceController.swift
//  Watchill WatchKit Extension
//
//  Created by Danilo da Rocha Lira Araujo on 09/05/19.
//  Copyright © 2019 Danilo da Rocha Lira Araujo. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    @IBAction func clique() {
        sendRequest()
    }
    
    let wcSession = WCSession.default
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        enableConnection()
        sendRequest()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func enableConnection(){
        if(WCSession.isSupported()){
            self.wcSession.delegate = self
            wcSession.activate()
            print("ativando conexão")
        }
    }
    
    func sendRequest(){
        print("enviando pedido")
        let msg = ["get_contact": true]
        self.wcSession.sendMessage(msg
            , replyHandler: { (resposta) in print(resposta)}, errorHandler: { (error) in print(error)} )
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        if let received = message["contact"] as? [String] {
            print(received[0])
            
            let mensagemVolta = ["mensagem": "Chegou!!"]
            replyHandler(mensagemVolta)
        }
    }
}
