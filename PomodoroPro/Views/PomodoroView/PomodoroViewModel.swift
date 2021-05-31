//
//  PomodoroViewModel.swift
//  PomodoroPro
//
//  Created by Ostap on 31.05.2021.
//

import AVKit
import SwiftUI
import Combine

struct Stack<Item> {
    var items = [Item]()
    
    var currentItem: Item? {
        get {
            guard items.count > 0 else {
                return nil
            }
            return items[items.count - 1]
        }
        set {
            guard items.count > 0 else {
                return
            }
            items[items.count - 1] = newValue!
        }
    }
    
    mutating func push(_ item: Item) {
        items.append(item)
    }
    
    @discardableResult
    mutating func pop() -> Item? {
        items.popLast()
    }
    
    mutating func popAll() {
        items = []
    }
}

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
            if state is State.Running {
                push(state: .paused)
            }
            else {
                if state == .dinging {
                    state = previousState!.next()!
                }
                else if state == .paused {
                    state = previousState!
                }
            }
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
        var player: AVAudioPlayer = .beep
        var previousState: State?
        
        func push(state: State) {
            previousState = self.state
            self.state = state
        }
        
        init(pomodoroTime: TimeInterval, breakTime: TimeInterval, showing: Binding<Bool>) {
            timer = PomodoroTimer(fireAfter: pomodoroTime)
            self.pomodoroTime = pomodoroTime
            self.breakTime = breakTime
            _showing = showing
            
            timer.objectWillChange
                .sink {
                    self.objectWillChange.send()
                }
                .store(in: &cancellables)
            
            timer.timePassed
                .sink {
                    self.push(state: .dinging)
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
        func next() -> State? { return nil }
        
        static let running = Running()
        static let pomodoro = Pomodoro()
        static let `break` = Break()
        static let paused = Paused()
        static let dinging = Dinging()
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
        }
        
        class Pomodoro: Running {
            override func enter(_ viewModel: PomodoroView.ViewModel) {
                viewModel.textPrefix = "Break"
                viewModel.timer.totalTime = viewModel.pomodoroTime
                super.enter(viewModel)
            }
            
            override func next() -> PomodoroView.ViewModel.State? {
                .break
            }
        }
        
        class Break: Running {
            override func enter(_ viewModel: PomodoroView.ViewModel) {
                viewModel.textPrefix = "Pomodoro"
                viewModel.timer.totalTime = viewModel.breakTime
                super.enter(viewModel)
            }
            
            override func next() -> PomodoroView.ViewModel.State? {
                .pomodoro
            }
        }
        
        class Paused: State {
            override func enter(_ viewModel: PomodoroView.ViewModel) {
                viewModel.rightButtonColor = .green
                viewModel.rightButtonText = "Resume"
            }
        }
        
        class Dinging: State {
            override func enter(_ viewModel: PomodoroView.ViewModel) {
                viewModel.rightButtonColor = .green
                viewModel.rightButtonText = "Continue"
                viewModel.player.play()
            }
            
            override func exit(_ viewModel: PomodoroView.ViewModel) {
                viewModel.player.stop()
            }
        }
        
        class Hidden: State {
            override func enter(_ viewModel: PomodoroView.ViewModel) {
                viewModel.showing = false
            }
            
            override func exit(_ viewModel: PomodoroView.ViewModel) {
                viewModel.showing = true
            }
        }
    }
}

extension PomodoroView.ViewModel.State: Equatable {
    static func == (lhs: PomodoroView.ViewModel.State, rhs: PomodoroView.ViewModel.State) -> Bool {
        type(of: lhs) == type(of: rhs)
    }
}
