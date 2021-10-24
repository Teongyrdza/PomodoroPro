//
//  PomodoroViewModel.swift
//  PomodoroPro
//
//  Created by Ostap on 31.05.2021.
//

import AVKit
import SwiftUI
import Combine

extension PomodoroView {
    class ViewModel: ObservableObject {
        // MARK: - View Properties
        @Published var rightButtonText = ""
        @Published var rightButtonColor: Color = .red
        @Published var state: State = .hidden {
            willSet {
                if state != newValue {
                    state.exit(self)
                }
            }
            didSet {
                if state != oldValue {
                    state.enter(self)
                }
            }
        }
        
        var progressText: String {
            var result = "\(textPrefix) in "
            
            let timeRemaining = Int(timer.timeRemaining)
            
            switch timer.timeRemaining {
                case 0..<60:
                    result += label(forSeconds: timeRemaining)
                case 60:
                    result += "1 minute"
                default:
                    result += "\(label(forMinutes: timeRemaining / 60)) \(label(forSeconds: timeRemaining % 60))"
            }
            
            return result
        }
        
        var progresssValue: Double {
            timer.timeRemaining / timer.totalTime
        }
        
        // MARK: - Event Handlers
        func leftButtonTapped() {
            state = .hidden
        }
        
        func rightButtonTapped() {
            state.rightButtonTapped(viewModel: self)
        }
        
        func onAppear() {
            state = .pomodoro
        }
        
        // MARK: - Private
        private func label(forMinutes minutes: Int) -> String {
            if minutes == 1 {
                return "1 minute"
            }
            else {
                return  "\(minutes) minutes"
            }
        }
        
        private func label(forSeconds seconds: Int) -> String {
            if seconds == 1 {
                return "1 second"
            }
            else {
                return  "\(seconds) seconds"
            }
        }
        
        private var cancellables = Set<AnyCancellable>()
        
        @Binding var showing: Bool
        let timer: PomodoroTimer
        let pomodoroTime: TimeInterval
        let breakTime: TimeInterval
        var textPrefix = "Break"
        
        let player: AVAudioPlayer
        let backgroundTask = BackgroundTask()
        
        init(settings: TimerSettings, showing: Binding<Bool>) {
            _showing = showing
            timer = PomodoroTimer(fireAfter: settings.pomodoroTime.asSeconds)
            pomodoroTime = settings.pomodoroTime.asSeconds
            breakTime = settings.breakTime.asSeconds
            player = settings.sound.playerCopy()
            player.numberOfLoops = -1
            
            timer.objectWillChange
                .sink(receiveValue: objectWillChange.send)
                .store(in: &cancellables)
            
            timer.timePassed
                .sink { [unowned self] in
                    state.timePassed(viewModel: self)
                }
                .store(in: &cancellables)
        }
    }
}

// MARK: - State
extension PomodoroView.ViewModel {
    class State {
        func enter(_ viewModel: PomodoroView.ViewModel) {}
        func exit(_ viewModel: PomodoroView.ViewModel) {}
        func rightButtonTapped(viewModel: PomodoroView.ViewModel) {}
        func timePassed(viewModel: PomodoroView.ViewModel) {}
        
        static let pomodoro = Pomodoro()
        static let `break` = Break()
        static let hidden = Hidden()
        
        class Running: State {
            override func enter(_ viewModel: PomodoroView.ViewModel) {
                viewModel.rightButtonColor = .red
                viewModel.rightButtonText = "Pause"
                viewModel.timer.start()
            }
            
            override func exit(_ viewModel: PomodoroView.ViewModel) {
                viewModel.timer.stop()
            }
            
            override func rightButtonTapped(viewModel: PomodoroView.ViewModel) {
                viewModel.state = Paused(pausing: self)
            }
        }
        
        class Pomodoro: Running {
            override func enter(_ viewModel: PomodoroView.ViewModel) {
                viewModel.textPrefix = "Break"
                viewModel.timer.totalTime = viewModel.pomodoroTime
                super.enter(viewModel)
            }
            
            override func timePassed(viewModel: PomodoroView.ViewModel) {
                viewModel.state = Dinging(next: .break)
            }
        }
        
        class Break: Running {
            override func enter(_ viewModel: PomodoroView.ViewModel) {
                viewModel.textPrefix = "Pomodoro"
                viewModel.timer.totalTime = viewModel.breakTime
                super.enter(viewModel)
            }
            
            override func timePassed(viewModel: PomodoroView.ViewModel) {
                viewModel.state = Dinging(next: .pomodoro)
            }
        }
        
        class Dinging: State {
            let next: State
            
            override func enter(_ viewModel: PomodoroView.ViewModel) {
                viewModel.rightButtonColor = .green
                viewModel.rightButtonText = "Continue"
                viewModel.player.play()
            }
            
            override func exit(_ viewModel: PomodoroView.ViewModel) {
                viewModel.player.pause()
            }
            
            override func rightButtonTapped(viewModel: PomodoroView.ViewModel) {
                viewModel.state = next
            }
            
            init(next: State) {
                self.next = next
            }
        }
        
        class Stopped: State {
            override func enter(_ viewModel: PomodoroView.ViewModel) {
                viewModel.backgroundTask.stop()
            }
            
            override func exit(_ viewModel: PomodoroView.ViewModel) {
                viewModel.backgroundTask.start()
            }
        }
        
        class Paused: Stopped {
            let state: State
            
            override func enter(_ viewModel: PomodoroView.ViewModel) {
                super.enter(viewModel)
                viewModel.rightButtonColor = .green
                viewModel.rightButtonText = "Resume"
            }
            
            override func rightButtonTapped(viewModel: PomodoroView.ViewModel) {
                viewModel.state = state
            }
            
            init(pausing state: State) {
                self.state = state
            }
        }
        
        class Hidden: Stopped {
            override func enter(_ viewModel: PomodoroView.ViewModel) {
                super.enter(viewModel)
                viewModel.showing = false
            }
            
            override func exit(_ viewModel: PomodoroView.ViewModel) {
                viewModel.showing = true
                super.exit(viewModel)
            }
        }
    }
}

extension PomodoroView.ViewModel.State: Equatable {
    static func == (lhs: PomodoroView.ViewModel.State, rhs: PomodoroView.ViewModel.State) -> Bool {
        type(of: lhs) == type(of: rhs)
    }
}
