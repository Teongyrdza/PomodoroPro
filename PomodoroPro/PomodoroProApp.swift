//
//  PomodoroProApp.swift
//  PomodoroPro
//
//  Created by Ostap on 24.10.2020.
//

import SwiftUI

@main
struct PomodoroProApp: App {
    @State var time = Time(2, 35, 6)
    @State var selection = 0
    
    var body: some Scene {
        WindowGroup {
            AppView()
        }
    }
}
