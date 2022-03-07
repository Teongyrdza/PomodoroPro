//
//  TimerSettings.swift
//  PomodoroPro
//
//  Created by Ostap on 31.05.2021.
//

import Combine

class TimerSettings: ObservableObject {
    @Published var pomodoroTime = Time(0, 30, 0)
    @Published var breakTime = Time(0, 5, 0)
    @Published var sound = Sound(named: "Beep")
}
