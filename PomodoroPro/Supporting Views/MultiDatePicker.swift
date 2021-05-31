//
//  MultiDatePicker.swift
//  PomodoroPro
//
//  Created by Ostap on 01.11.2020.
//

import SwiftUI

enum DateParts {
    case date
    case time
         
    case years
    case months
    case weeks
    case days
    
    case hours
    case minutes
    case seconds
}

struct TimePicker: View {
    let displayedComponents: [DateParts] = [.date, .time]
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct MultiDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        TimePicker()
    }
}
