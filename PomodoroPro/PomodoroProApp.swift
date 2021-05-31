//
//  PomodoroProApp.swift
//  PomodoroPro
//
//  Created by Ostap on 24.10.2020.
//

import SwiftUI

@main
struct PomodoroProApp: App {
    @State var time = Time(2, 35, 6)
    @State var selection = 0
    
    var body: some Scene {
        WindowGroup {
            switch 0 {
                case 0:
                    AppView()
                case 1:
                    TimePicker(selection: $time, in: Time(0, 0, 0)...Time(3, 59, 59))
                case 2:
                    VStack {
                        Text("Selection is \(selection)")
                        
                        FSPicker(selection: $selection) {
                            Text("first").tag(0)
                            Text("second").tag(1)
                            Text("third").tag(2)
                            Text("fourth").tag(3)
                            Text("fifth").tag(4)
                            Text("sixth").tag(5)
                            Text("seventh").tag(6)
                            Text("eighth").tag(7)
                        }
                        
                        WheelPicker(selection: $selection) {
                            Text("1").tag(0)
                            Text("2").tag(1)
                            Text("3").tag(2)
                            Text("4").tag(3)
                            Text("5").tag(4)
                            Text("6").tag(5)
                            Text("7").tag(6)
                            Text("8").tag(7)
                        }
                    }
                default:
                    EmptyView()
            }
        }
    }
}
