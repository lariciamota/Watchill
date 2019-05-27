import Foundation
import AVFoundation


public class MusicPlayer {
    
    var playlist:[String] = []
    var musics_to_play:[String] = []
    var actual_music = 0
    var audioPlayer = AVAudioPlayer()
    var shuffle_on = false
    var played_musics:[Int] = []
    
    func lastMusic() {
        print(self.played_musics)
        print(self.played_musics.removeLast())
        if (self.played_musics.isEmpty){
            self.setMusic(music_index: 0)
        } else {
            self.setMusic(music_index: self.played_musics.removeLast())
        }
        
    }
    
    func setPlaylist(playlist:[String]) {
        self.playlist = playlist
        self.musics_to_play = playlist
    }
    
    func nextMusic(){
        if (self.shuffle_on){
            self.resetShuffle()
            self.actual_music = Int.random(in: 0 ..< self.musics_to_play.count)
            
        } else {
            if (self.actual_music == self.playlist.count - 1){
                self.actual_music = 0
            }
            else {
                self.actual_music += 1
            }
        }
        
        if (self.played_musics.count > 10){
            self.played_musics.removeFirst()
        }
        
        self.setMusic(music_index: self.actual_music)
    }
    
    func setMusic(music_index:Int) {
        let path = Bundle.main.path(forResource: "Song/" + self.playlist[music_index], ofType:"")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path!))
            self.played_musics.append(self.actual_music)
        } catch {
            print("Não foi possível encontrar nenhuma música")
        }
    }
    
    func playMusic(){
        self.audioPlayer.play()
    }
    
    func stopMusic(){
        self.audioPlayer.stop()
    }
    
    func shuffle(){
        if self.shuffle_on{
            self.shuffle_on = false
        } else {
            self.shuffle_on = true
        }
    }
    
    func resetShuffle(){
        if self.musics_to_play.count == 1 {
            self.musics_to_play = self.playlist
        } else {
            self.musics_to_play.remove(at: self.actual_music)
        }
    }
    
}
