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

class ViewController: UIViewController{
    let favorite = Defaults.shared
    lazy var healthKitStore = HKHealthStore()
    var connectivityHandler = WatchSessionManager.shared
    let contact = "contact"
    var watchCommand = 0
    
    override func viewDidAppear(_ animated: Bool) {
        if HKHealthStore.isHealthDataAvailable(){
            authorizeHealthKit()
        }
    }
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.music_provider.musicsList().count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "musicNameCell", for: indexPath)
        
        cell.textLabel?.text = self.music_provider.musicsList()[indexPath.row]
        
        return cell
    }

    func receiveCommand(){
        switch self.watchCommand{
            case 0:
                self.music_player.playMusic()
            case 1:
                self.music_player.stopMusic()
            case 2:
                self.music_player.nextMusic()
            case 3:
                self.music_player.lastMusic()
            case 4:
                self.music_player.shuffle()
            }
    }
    
    @IBOutlet weak var tableViewCell: UITableViewCell!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var musicNameCell: UILabel!
    @IBOutlet weak var playingButtonOutlet: UIButton!
    @IBOutlet weak var musicPlayingLabel: UILabel!
    

    
    
    @IBAction func playButton(_ sender: Any) {
        
        if self.music_player.musicIsPlaying{
            self.music_player.stopMusic()
            self.playingButtonOutlet.setImage(UIImage(named: "icons8-play-button-circled-100"), for: .normal)
        } else {
            self.music_player.playMusic()
            self.playingButtonOutlet.setImage(UIImage(named: "icons8-pause-button-100"), for: .normal)
        }
        
        musicPlayingLabel.text = self.music_player.playlist[self.music_player.actual_music]
    }
    
    
    @IBAction func nextMusicButton(_ sender: Any) {
        self.music_player.nextMusic()
        musicPlayingLabel.text = self.music_player.playlist[self.music_player.actual_music]
    }
    
    @IBAction func lastMusicButton(_ sender: Any) {
        self.music_player.lastMusic()
        musicPlayingLabel.text = self.music_player.playlist[self.music_player.actual_music]
    }
    
    
    let music_player = MusicPlayer()
    let music_provider = MusicProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.music_player.setPlaylist(playlist: self.music_provider.musicsList())
        self.music_player.setMusic(music_index: 0)
        connectivityHandler.iOSDelegate = self
        
        for music in self.music_provider.musicsList(){
            print(music)
        }
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

    // FUNÇÃO PARA RECEBER COMANDO DO WATCH COMO NUMBERO INTEIRO E CHAMAR A FUNÇÃO CORRESPONDENTE DO MUSIC PLAYER
    func commandReceived(tuple: commandReceived) {
        guard let reply = tuple.replyHandler else {
            return
        }
        
        if let command = tuple.message["command"] as? Int {
            print("comando recebido")
            self.watchCommand = command[1]
            self.receiveCommand()
        }
    }

    
}
