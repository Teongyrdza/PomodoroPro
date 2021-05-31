//
//  AppView.swift
//  PomodoroPro
//
//  Created by Ostap on 30.05.2021.
//

import SwiftUI

struct AppView: View {
    @State var pomodoroTime = Time(0, 30, 0)
    @State var breakTime = Time(0, 5, 0)
    @State var showingTimer = false
    
    var body: some View {
        NavigationView {
            Group {
                if showingTimer {
                    PomodoroView(viewModel: .init(pomodoroTime: pomodoroTime.asSeconds, breakTime: breakTime.asSeconds, showing: $showingTimer))
                }
                else {
                    SettingsView(pomodoroTime: $pomodoroTime, breakTime: $breakTime, showingTimer: $showingTimer)
                }
            }
            .navigationTitle("Pomodoro Pro")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#if DEBUG
struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
#endif
