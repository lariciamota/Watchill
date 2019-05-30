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

class MusicInterfaceController: WKInterfaceController, WatchOSDelegate {
    
    var connectivityHandler = WatchSessionManager.shared
    var session : WCSession?
    var watchCommand = 0
    var isPlaying = false

    @IBAction func goPrevious() {
        self.watchCommand = 3
        sendCommand(command: self.watchCommand)
    }
    
    @IBAction func goNext() {
        self.watchCommand = 2
        sendCommand(command: self.watchCommand)
    }
    
    @IBAction func playMusic() {
        isPlaying = !isPlaying
        if isPlaying {
            self.watchCommand = 0
            sendCommand(command: self.watchCommand)
        } else {
            self.watchCommand = 1
            sendCommand(command: self.watchCommand)
        }
    }
    
    @IBAction func shuffleMusic() {
        self.watchCommand = 4
        sendCommand(command: self.watchCommand)
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        connectivityHandler.watchOSDelegate = self
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func sendCommand(command: Int){
        print("enviando comando: " + String(watchCommand))
        let command = ["command" : watchCommand]
        connectivityHandler.sendMessage(message: command)
    }
    
    func messageReceived(tuple: MessageReceived) {
        
    }
}
