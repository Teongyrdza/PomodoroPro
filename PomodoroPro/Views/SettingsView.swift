//
//  SettingsView.swift
//  PomodoroPro
//
//  Created by Ostap on 01.11.2020.
//

import SwiftUI
import StarUI

struct SettingsView: View {
    @EnvironmentObject var settings: TimerSettings
    @Binding var showingTimer: Bool
    @Binding var timerState: PomodoroView.ViewModel.State
    
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
                    
                    TimePicker(selection: $settings.pomodoroTime, in: range)
                }
                
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("Break:")
                        .font(.system(size: 30))
                    
                    TimePicker(selection: $settings.breakTime, in: range)
                }
                
                Spacer()
                
                GroupBox {
                    HStack {
                        Text("When timer ends")
                        
                        Spacer()
                        
                        NavigationLink(destination: SoundPicker(selection: $settings.sound)) {
                            Text(settings.sound.description)
                                .opacity(0.5)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.bottom, 50)
                
                HStack {
                    Button("Pomodoro") {
                        timerState = .pomodoro
                        showingTimer = true
                    }
                    
                    .frame(width: 100)
                    
                    Spacer()
                    
                    Button("Break") {
                        timerState = .break
                        showingTimer = true
                    }
                    .frame(width: 100)
                }
                .buttonStyle(.roundedCorners)
                .frame(height: 50)
            }
            .padding(.horizontal)
        }
    }
}

#if DEBUG
struct TimerSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView(showingTimer: .constant(false), timerState: .constant(.pomodoro))
                .preferredColorScheme(.dark)
                .navigationTitle("Pomodoro Pro")
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .environmentObject(TimerSettings())
    }
}
#endif
