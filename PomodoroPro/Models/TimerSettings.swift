//
//  TimerSettings.swift
//  PomodoroPro
//
//  Created by Ostap on 31.05.2021.
//

import Foundation
import Combine
import ItDepends

class TimerSettings: JSONModel, ObservableObject, Codable {
    static let url = FileManager.default.documentsFolder.appendingPathComponent("settings.json")
    
    @Published var pomodoroTime = Time(0, 30, 0)
    @Published var breakTime = Time(0, 5, 0)
    @Published var sound = Sound(named: "Beep")
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(State(pomodoroTime: pomodoroTime, breakTime: breakTime, sound: sound))
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let state = try container.decode(State.self)
        pomodoroTime = state.pomodoroTime
        breakTime = state.breakTime
        sound = state.sound
    }
    
    required init() {}
    
    struct State: Codable {
        let pomodoroTime: Time
        let breakTime: Time
        let sound: Sound
    }
}
