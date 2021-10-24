//
//  AppView.swift
//  PomodoroPro
//
//  Created by Ostap on 30.05.2021.
//

import SwiftUI
import Combine

@propertyWrapper
struct InertState<Value>: DynamicProperty {
    @StateObject private var wrapper: Wrapper
    
    var wrappedValue: Value {
        get {
            wrapper.value
        }
        set {
            wrapper.value = newValue
        }
    }
    
    var projectedValue: Binding<Value> {
        .init(
            get: { wrappedValue },
            set: { wrapper.value = $0 }
        )
    }
    
    init(wrappedValue: Value) {
        _wrapper = .init(wrappedValue: Wrapper(value: wrappedValue))
    }
    
    class Wrapper: ObservableObject {
        var value: Value
        
        init(value: Value) {
            self.value = value
        }
    }
}

struct AppView: View {
    @StateObject var timerSettings = TimerSettings()
    @State var showingTimer = false
    @InertState var initialState: PomodoroView.ViewModel.State = .pomodoro
    
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
