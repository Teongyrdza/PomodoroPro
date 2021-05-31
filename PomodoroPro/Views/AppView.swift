//
//  AppView.swift
//  PomodoroPro
//
//  Created by Ostap on 30.05.2021.
//

import SwiftUI

struct AppView: View {
    @StateObject var timerSettings = TimerSettings()
    @State var showingTimer = false
    
    var body: some View {
        NavigationView {
            Group {
                if showingTimer {
                    PomodoroView(viewModel: .init(settings: timerSettings, showing: $showingTimer))
                }
                else {
                    SettingsView(showingTimer: $showingTimer)
                }
            }
            .navigationTitle("Pomodoro Pro")
            .environmentObject(timerSettings)
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
