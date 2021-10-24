//
//  Sound.swift
//  PomodoroPro
//
//  Created by Ostap on 31.05.2021.
//

import AVKit

extension AVAudioPlayer {
    convenience init(named name: String, withExtension `extension`: String = "mp3") {
        guard let url = Bundle.main.url(forResource: name, withExtension: `extension`) else { fatalError("Failed to find sound file.") }
        try! self.init(contentsOf: url)
    }
    
    static let beep: AVAudioPlayer = .init(named: "beep")
    
    static let ding: AVAudioPlayer = .init(named: "ding")
    
    static let meditationBell: AVAudioPlayer = .init(named: "meditationBell")
    
    static let silence: AVAudioPlayer = {
        let player = AVAudioPlayer(named: "silence")
        player.numberOfLoops = -1
        return player
    }()
}

struct Sound: Hashable, Identifiable, CustomStringConvertible {
    let id = UUID()
    let name: String
    let description: String
    let player: AVAudioPlayer
    
    func playerCopy() -> AVAudioPlayer {
        .init(named: name)
    }
    
    static func == (lhs: Sound, rhs: Sound) -> Bool {
        lhs.name == rhs.name && lhs.description == rhs.description
    }
    
    init(named name: String, description: String) {
        self.name = name
        self.description = description
        self.player = AVAudioPlayer(named: name)
    }
}
