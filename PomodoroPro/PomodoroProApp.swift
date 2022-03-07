//
//  PomodoroProApp.swift
//  PomodoroPro
//
//  Created by Ostap on 24.10.2020.
//

import SwiftUI
import AVKit

extension AVAudioSession {
    static let shared = sharedInstance()
}

extension FileManager {
    var documentsFolder: URL {
        try! url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    }
}

@main
struct PomodoroProApp: App {
    @State var time = Time(2, 35, 6)
    @State var selection = 0
    
    var body: some Scene {
        WindowGroup {
            AppView()
        }
    }
    
    init() {
        do {
            try AVAudioSession.shared.setCategory(.playback)
            try AVAudioSession.shared.setActive(true)
        } catch {
            print("Error configuring audio session")
        }
    }
}
