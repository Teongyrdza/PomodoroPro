//
//  AppView.swift
//  PomodoroPro
//
//  Created by Ostap on 30.05.2021.
//

import SwiftUI

struct AppView: View {
    @StateObject var timerSettings: TimerSettings = (try? .load()) ?? .init()
    @State var showingTimer = false
    @InertState var initialState: PomodoroView.ViewModel.State = .pomodoro
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        NavigationView {
            Group {
                if showingTimer {
                    PomodoroView(
                        viewModel: .init(
                            settings: timerSettings,
                            showing: $showingTimer,
                            initialState: initialState
                        )
                    )
                }
                else {
                    SettingsView(showingTimer: $showingTimer, timerState: $initialState)
                }
            }
            .navigationTitle("Pomodoro Pro")
            .environmentObject(timerSettings)
        }
        .navigationViewStyle(.stack)
        .onChange(of: scenePhase) { newPhase in
            if newPhase != .active {
                try? timerSettings.save()
            }
        }
    }
}

#if DEBUG
struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
#endif
