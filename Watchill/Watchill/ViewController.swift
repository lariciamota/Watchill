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

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, WCSessionDelegate{
    
    @IBOutlet weak var musicTableView: UITableView!

    var watchCommand = 0
    let favorite = Defaults.shared
    lazy var healthKitStore = HKHealthStore()
//    var connectivityHandler = WatchSessionManager.shared
    let contact = "contact"
    let sessao = WCSession.default

    override func viewDidAppear(_ animated: Bool) {
        if HKHealthStore.isHealthDataAvailable(){
            HealthKitManager.authorizeHealthKit()
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
    
    func receiveCommand(){
        switch self.watchCommand{
        case 0:
            self.music_player.playMusic()
            if (!self.music_player.musicIsPlaying){
                self.playingButtonOutlet.setImage(UIImage(named: "icons8-play-button-circled-100"), for: .normal)
            } else {
                self.playingButtonOutlet.setImage(UIImage(named: "icons8-pause-button-100"), for: .normal)
            }
            musicPlayingLabel.text = self.music_player.playlist[self.music_player.actual_music].components(separatedBy: ".mp3")[0]
        case 1:
            self.music_player.stopMusic()
            if (!self.music_player.musicIsPlaying){
                self.playingButtonOutlet.setImage(UIImage(named: "icons8-play-button-circled-100"), for: .normal)
            } else {
                self.playingButtonOutlet.setImage(UIImage(named: "icons8-pause-button-100"), for: .normal)
            }
        case 2:
            self.music_player.nextMusic()
            if (!self.music_player.musicIsPlaying){
                self.playingButtonOutlet.setImage(UIImage(named: "icons8-play-button-circled-100"), for: .normal)
            } else {
                self.playingButtonOutlet.setImage(UIImage(named: "icons8-pause-button-100"), for: .normal)
            }
            musicPlayingLabel.text = self.music_player.playlist[self.music_player.actual_music].components(separatedBy: ".mp3")[0]
        case 3:
            self.music_player.lastMusic()
            if (!self.music_player.musicIsPlaying){
                self.playingButtonOutlet.setImage(UIImage(named: "icons8-play-button-circled-100"), for: .normal)
            } else {
                self.playingButtonOutlet.setImage(UIImage(named: "icons8-pause-button-100"), for: .normal)
            }
            musicPlayingLabel.text = self.music_player.playlist[self.music_player.actual_music].components(separatedBy: ".mp3")[0]
        case 4:
            self.music_player.shuffle()
        default: break
            
        }
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
        
        if (!self.music_player.musicIsPlaying){
            self.playingButtonOutlet.setImage(UIImage(named: "icons8-play-button-circled-100"), for: .normal)
        } else {
            self.playingButtonOutlet.setImage(UIImage(named: "icons8-pause-button-100"), for: .normal)
        }
    }
    
    @IBAction func lastMusicButton(_ sender: Any) {
        self.music_player.lastMusic()
        musicPlayingLabel.text = self.music_player.playlist[self.music_player.actual_music].components(separatedBy: ".mp3")[0]
        
        if (!self.music_player.musicIsPlaying){
            self.playingButtonOutlet.setImage(UIImage(named: "icons8-play-button-circled-100"), for: .normal)
        } else {
            self.playingButtonOutlet.setImage(UIImage(named: "icons8-pause-button-100"), for: .normal)
        }
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
//        connectivityHandler.iOSDelegate = self
        
        for music in self.music_provider.musicsList(){
            print(music)
        }
        
        ativarConexao()

    }
    
    func ativarConexao(){
        if(WCSession.isSupported()){
            self.sessao.delegate = self
            sessao.activate()
        }
    }

    func sendContact(){
        print("enviando contato")
        let msg = [contact: [self.favorite.contacts[0].name, self.favorite.contacts[0].phone]]
        self.sessao.sendMessage(msg, replyHandler: { (resposta) in print(resposta)}, errorHandler: { (error) in print(error)} )
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationState")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("sessionDidBecomeInactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("sessionDidDeactivate")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        if let commandRecebido = message["command"] as? Int {
            DispatchQueue.main.async {
                self.watchCommand = commandRecebido
                self.receiveCommand()
            }
            let mensagemVolta = ["mensagem": "Chegou!!"]
            replyHandler(mensagemVolta)
        } else if let _ = message["get_contact"] as? Bool {
            print("pedido recebido")
            let msg = [contact: [self.favorite.contacts[0].name, self.favorite.contacts[0].phone]]
            replyHandler(msg)
        }
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
        } else if let command = tuple.message["command"] as? Int {
            print("comando recebido")
            self.watchCommand = command
            self.receiveCommand()
        }
    }
    
}
