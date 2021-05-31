//
//  Beep.swift
//  PomodoroPro
//
//  Created by Ostap on 04.04.2021.
//

import AVKit

extension AVAudioPlayer {
    static let beep: AVAudioPlayer = {
        guard let url = Bundle.main.url(forResource: "Beep", withExtension: "mp3") else { fatalError("Failed to find sound file.") }
        let player = try! AVAudioPlayer(contentsOf: url)
        player.numberOfLoops = -1
        return player
    }()
}
