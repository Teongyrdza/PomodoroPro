//
//  PomodoroTimer.swift
//  PomodoroPro
//
//  Created by Ostap on 04.04.2021.
//

import Foundation
import Combine

final class PomodoroTimer: ObservableObject {
    @Published var timeRemaining: TimeInterval
    @Published var totalTime: TimeInterval {
        didSet {
            if totalTime != oldValue {
                timeRemaining = totalTime
            }
        }
    }
    let timePassed = PassthroughSubject<Void, Never>()
    var frequency: TimeInterval {
        1 / 60
    }
    
    private var timer: Timer?
    
    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: frequency, repeats: true) { [unowned self] _ in
            if timeRemaining - frequency >= 0 {
                timeRemaining -= frequency
            }
            else {
                timePassed.send()
                stop()
            }
        }
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    init(fireAfter time: TimeInterval) {
        timeRemaining = time
        totalTime = time
    }
    
    deinit {
        stop()
    }
}
