//
//  SettingsView.swift
//  PomodoroPro
//
//  Created by Ostap on 01.11.2020.
//

import SwiftUI
import StarUI

struct SettingsView: View {
    @Binding var pomodoroTime: Time
    @Binding var breakTime: Time
    @Binding var showingTimer: Bool
    
    var range: ClosedRange<Time> {
        Time(0)...Time(3599)
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Divider()
                
                VStack(alignment: .leading) {
                    Text("Pomodoro:")
                        .font(.system(size: 30))
                    
                    TimePicker(selection: $pomodoroTime, in: range)
                }
                
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("Break:")
                        .font(.system(size: 30))
                    
                    TimePicker(selection: $breakTime, in: range)
                }
                
                Spacer()
                
                Button("Start") {
                    showingTimer = true
                }
                .buttonStyle(RoundedButtonStyle())
                .frame(width: 200, height: 50)
            }
            .padding(.horizontal)
        }
    }
}

#if DEBUG
struct TimerSettingsView_Previews: PreviewProvider {
    @State static var pomodoroTime = Time(0, 30, 0)
    @State static var breakTime = Time(0, 5, 0)
    
    static var previews: some View {
        NavigationView {
            SettingsView(pomodoroTime: $pomodoroTime, breakTime: $breakTime, showingTimer: .constant(false))
                .preferredColorScheme(.dark)
                .navigationTitle("Pomodoro Pro")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
#endif
