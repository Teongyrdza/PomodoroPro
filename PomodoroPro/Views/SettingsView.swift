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
                
                Button("Start") {
                    showingTimer = true
                }
                .buttonStyle(RoundedButtonStyle())
                .frame(width: 150, height: 50)
            }
            .padding(.horizontal)
        }
    }
}

#if DEBUG
struct TimerSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView(showingTimer: .constant(false))
                .preferredColorScheme(.dark)
                .navigationTitle("Pomodoro Pro")
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .environmentObject(TimerSettings())
    }
}
#endif
