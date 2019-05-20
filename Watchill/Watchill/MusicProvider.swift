//
//  MusicProvider.swift
//  Watchill
//
//  Created by Wilquer Torres de Lima on 20/05/19.
//  Copyright © 2019 Danilo da Rocha Lira Araujo. All rights reserved.
//

import Foundation

struct MusicProvider {
    func musicsList() -> [String] {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath! + "/Song"
        var musics:[String] = []
        
        do {
            let file = try fm.contentsOfDirectory(atPath: path)
            for music in file {
                musics.append(music)
            }
        } catch {
            print("Erro, nenhuma música encontrada")
        }
        return musics
    }
}
