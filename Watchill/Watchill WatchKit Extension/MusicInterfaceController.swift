//
//  MusicInterfaceController.swift
//  Watchill WatchKit Extension
//
//  Created by Laricia Maria Mota Cavalcante on 30/05/19.
//  Copyright © 2019 Danilo da Rocha Lira Araujo. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class MusicInterfaceController: WKInterfaceController, WCSessionDelegate {
    
    let sessao = WCSession.default
    var watchCommand = 0
    var isPlaying = false

    @IBAction func goPrevious() {
        print("vai antes")

        self.watchCommand = 3
        sendCommand()
    }
    
    @IBAction func goNext() {
        print("vai prox")

        self.watchCommand = 2
        sendCommand()
    }
    
    @IBAction func playMusic() {
        print("da play")
        isPlaying = !isPlaying
        if isPlaying {
            self.watchCommand = 0
            sendCommand()
        } else {
            self.watchCommand = 1
            sendCommand()
        }
    }
    
    @IBAction func shuffleMusic() {
        print("shuffle")
        self.watchCommand = 4
        sendCommand()
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        ativarConexao()

        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    func ativarConexao(){
        if(WCSession.isSupported()){
            self.sessao.delegate = self
            sessao.activate()
        }
    }
    
    func sendCommand(){
        let command = ["command" : self.watchCommand]
        self.sessao.sendMessage(command
            , replyHandler: { (resposta) in print(resposta)}, errorHandler: { (error) in print(error)} )
    }
   
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
//    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
//        if let contadorRecebido = message["contador"] as? Int {
//            DispatchQueue.main.async {
//                self.contador = contadorRecebido
//                self.contadorLabel.setText(String(self.contador))
//            }
//            let mensagemVolta = ["mensagem": "Chegou!!"]
//            replyHandler(mensagemVolta)
//        }
//    }
    
}
