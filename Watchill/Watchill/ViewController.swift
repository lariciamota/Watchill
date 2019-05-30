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

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var musicTableView: UITableView!

    let favorite = Defaults.shared
    lazy var healthKitStore = HKHealthStore()
    var connectivityHandler = WatchSessionManager.shared
    let contact = "contact"
    
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.music_player.setMusic(music_index: indexPath.row)

        if(self.music_player.isUnlocked(music_index: indexPath.row)){
            self.music_player.playMusic()
            self.playingButtonOutlet.setImage(UIImage(named: "icons8-pause-button-100"), for: .normal)
            
            musicPlayingLabel.text = self.music_player.playlist[self.music_player.actual_music].components(separatedBy: ".mp3")[0]
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "musicNameCell") as! MusicTableViewCell
        let music = self.music_provider.musicsList()[indexPath.row]
        cell.musicLabel.text = music.components(separatedBy: ".mp3")[0]
        cell.backgroundColor = UIColor.clear
        
        cell.lockedSymbol.isHidden = self.music_player.isUnlocked(music_index: indexPath.row)
        
        return cell
    }
    
    @IBOutlet weak var playingButtonOutlet: UIButton!
    @IBOutlet weak var musicPlayingLabel: UILabel!
    

    @IBAction func playButton(_ sender: Any) {
        
        if self.music_player.musicIsPlaying{
            self.music_player.stopMusic()
            self.playingButtonOutlet.setImage(UIImage(named: "icons8-play-button-circled-100"), for: .normal)
        } else {
            if (self.music_player.isUnlocked(music_index: self.music_player.actual_music)){
                self.music_player.playMusic()
                self.playingButtonOutlet.setImage(UIImage(named: "icons8-pause-button-100"), for: .normal)
                musicPlayingLabel.text = self.music_player.playlist[self.music_player.actual_music].components(separatedBy: ".mp3")[0]
            }
        }
    
    }
    
    
    @IBAction func nextMusicButton(_ sender: Any) {
        self.music_player.nextMusic()
        musicPlayingLabel.text = self.music_player.playlist[self.music_player.actual_music].components(separatedBy: ".mp3")[0]
    }
    
    @IBAction func lastMusicButton(_ sender: Any) {
        self.music_player.lastMusic()
        musicPlayingLabel.text = self.music_player.playlist[self.music_player.actual_music].components(separatedBy: ".mp3")[0]
    }
    
    
    let music_player = MusicPlayer()
    let music_provider = MusicProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.musicTableView.dataSource = self
        self.musicTableView.delegate = self
        
        self.musicTableView.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.87, alpha:1.0)
        self.musicTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        
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
    
}
