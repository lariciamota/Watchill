//
//  ViewController.swift
//  Watchill
//
//  Created by Danilo da Rocha Lira Araujo on 09/05/19.
//  Copyright © 2019 Danilo da Rocha Lira Araujo. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate {
    let favorite = Defaults.shared
    
    let wcSession = WCSession.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        enableConnection()
    }
    
    func enableConnection(){
        if(WCSession.isSupported()){
            self.wcSession.delegate = self
            wcSession.activate()
            print("ativando conexão")
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
    }
    
    func sendContact(){
        print("enviando contato")
        
        let msg = ["contact": [self.favorite.contacts[0].name, self.favorite.contacts[0].phone]]
        self.wcSession.sendMessage(msg
            , replyHandler: { (resposta) in print(resposta)}, errorHandler: { (error) in print(error)} )
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        
        if let _ = message["get_contact"] as? Bool {
            print("recebendo pedido")
            
            let msg = ["contact": [self.favorite.contacts[0].name, self.favorite.contacts[0].phone]]
            replyHandler(msg)
        }
    }
    
}

