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

class InterfaceController: WKInterfaceController {
    var connectivityHandler = WatchSessionManager.shared
    var session : WCSession?
    let contact = "contact"
    var name = ""
    var phone = ""
    var watchCommand = 0
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
            connectivityHandler.watchOSDelegate = self
        sendRequest()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func sendRequest(){
        print("enviando pedido")
        let msg = ["get_contact": true]
        connectivityHandler.sendMessage(message: msg, replyHandler: { (resposta) in
            let data = resposta[self.contact] as! [String]
            self.name = data[0]
            self.phone = data[1]
            print(self.name)}, errorHandler: { (error) in print(error)} )
    }
    // FUNÇÃO PARA ENVIAR O COMANDO DO WATCH. FALTA ASSOCIAR OS BOTÕES DO STORYBOARD À INTERFACECONTROLLER
    // E PRA CADA BOTÃO MUDAR A VARIÁVEL self.watchCommand PARA O VALOR CORRESPONDENTE 
    func sendCommand(command: Int){
        print("enviando comando")
        connectivityHandler.sendMessage(message: command)
    }

    
    override func contextForSegue(withIdentifier segueIdentifier: String) -> Any? {
        if segueIdentifier == "ChoiceController" {
            return ["name": self.name,
                    "phone":self.phone]
        }
        return nil
    }

    
}

extension InterfaceController: WatchOSDelegate {
    
    func messageReceived(tuple: MessageReceived) {
//        DispatchQueue.main.async() {
//            WKInterfaceDevice.current().play(.notification)
//            if let msg = tuple.message[self.contact] as? [String] {
//                print("teste")
//                
//            }
//        }
    }
    
}
