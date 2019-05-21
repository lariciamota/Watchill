//
//  ViewController.swift
//  Watchill
//
//  Created by Danilo da Rocha Lira Araujo on 09/05/19.
//  Copyright © 2019 Danilo da Rocha Lira Araujo. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController {
    let favorite = Defaults.shared

    var connectivityHandler = WatchSessionManager.shared
    let contact = "contact"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        connectivityHandler.iOSDelegate = self
    }
    
    func sendContact(){
        print("enviando contato")
        let msg = [contact: [self.favorite.contacts[0].name, self.favorite.contacts[0].phone]]
        connectivityHandler.sendMessage(message: msg, replyHandler: { (resposta) in print(resposta)}, errorHandler: { (error) in print(error)} )
    }
    
}

extension ViewController: iOSDelegate {
    
    func messageReceived(tuple: MessageReceived) {
        guard let reply = tuple.replyHandler else {
            return
        }
        
        if let _ = tuple.message["get_contact"] as? Bool {
            print("pedido recebido")
            let msg = [contact: [self.favorite.contacts[0].name, self.favorite.contacts[0].phone]]
            reply(msg)
        }
    }
    
}
