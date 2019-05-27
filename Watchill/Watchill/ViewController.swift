//
//  ViewController.swift
//  Watchill
//
//  Created by Danilo da Rocha Lira Araujo on 09/05/19.
//  Copyright © 2019 Danilo da Rocha Lira Araujo. All rights reserved.
//

import UIKit
import WatchConnectivity
import HealthKit

class ViewController: UIViewController {
    let favorite = Defaults.shared
    lazy var healthKitStore = HKHealthStore()

    var connectivityHandler = WatchSessionManager.shared
    let contact = "contact"
    
    override func viewDidAppear(_ animated: Bool) {
        if HKHealthStore.isHealthDataAvailable(){
            authorizeHealthKit()
        }
    }
    
    @IBOutlet weak var playingMusicLabel: UIView!
    
    @IBAction func playButton(_ sender: Any) {
        self.music_player.playMusic()
    }
    
    
    @IBAction func nextMusicButton(_ sender: Any) {
        self.music_player.nextMusic()
    }
    
    @IBAction func lastMusicButton(_ sender: Any) {
        
        self.music_player.lastMusic()
    }
    
    
    let music_player = MusicPlayer()
    let music_provider = MusicProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.music_player.setPlaylist(playlist: self.music_provider.musicsList())
        self.music_player.setMusic(music_index: 0)
        connectivityHandler.iOSDelegate = self
    }

    func sendContact(){
        print("enviando contato")
        let msg = [contact: [self.favorite.contacts[0].name, self.favorite.contacts[0].phone]]
        connectivityHandler.sendMessage(message: msg, replyHandler: { (resposta) in print(resposta)}, errorHandler: { (error) in print(error)} )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    func authorizeHealthKit() {
        
        let healthKitTypes: Set = [
            HKObjectType.quantityType(forIdentifier: .heartRate)!
        ]
        
        healthKitStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { (success, error) in
            if success {
                print("success")
            } else {
                print("failure")
            }
            
            if let error = error { print(error) }
        }
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
