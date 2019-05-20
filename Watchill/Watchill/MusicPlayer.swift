//
//  MusicPlayer.swift
//  Watchill
//
//  Created by Wilquer Torres de Lima on 20/05/19.
//  Copyright © 2019 Danilo da Rocha Lira Araujo. All rights reserved.
//

import Foundation
import AVFoundation

class MusicPlayer {
    
    var playList: [String] = []
    var musics_to_play: [String] = []
    var actual_music = 0
    var audioPlayer = AVAudioPlayer()
    var shuffle_on = false
    
    func setPlayList(playList: [String]) {
        self.playList = playList
        self.musics_to_play = playList
    }
    
    func nextMusic() {
        if self.shuffle_on {
            self.resetShuffle()
            self.actual_music = Int.random(in: 0 ..< self.musics_to_play.count)
        } else {
            if self.actual_music == self.playList.count - 1 {
                self.actual_music = 0
            } else {
                self.actual_music += 1
            }
        }
        self.setMusic()
    }
    
    func setMusic() {
        let forResouce = "/Song" + self.playList[self.actual_music]
        let path = Bundle.main.path(forResource: forResouce, ofType: "")
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path!))
        } catch {
            print("Erro, não foi possível encontrar uma música")
        }
    }
    
    func playMusic() {
        self.audioPlayer.play()
    }
    
    func stopMusic() {
        self.audioPlayer.stop()
    }
    
    func shuffle() {
        if self.musics_to_play.count == 1 {
            self.musics_to_play = self.playList
        } else {
            self.musics_to_play.remove(at: self.actual_music)
        }
    }
    
    func resetShuffle() {
        if self.musics_to_play.count == 1 {
            self.musics_to_play = self.playList
        } else {
            self.musics_to_play.remove(at: self.actual_music)
        }
    }
    
}
