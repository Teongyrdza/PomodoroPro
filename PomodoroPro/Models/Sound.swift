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
}

struct Sound: Hashable, Codable, Identifiable, CustomStringConvertible {
    var id = UUID()
    let name: String
    let description: String
    let player: AVAudioPlayer
    
    func playerCopy() -> AVAudioPlayer {
        .init(named: name)
    }
    
    static func == (lhs: Sound, rhs: Sound) -> Bool {
        lhs.name == rhs.name && lhs.description == rhs.description
    }
    
    enum CodingKeys: CodingKey {
        case id, name, description
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        player = AVAudioPlayer(named: name)
    }
    
    init(name: String, description: String) {
        self.name = name
        self.description = description
        self.player = AVAudioPlayer(named: name)
    }
    
    init(named name: String) {
        self.init(name: name, description: name)
    }
}
