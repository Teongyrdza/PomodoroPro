//
//  InertState.swift
//  PomodoroPro
//
//  Created by Ostap on 24.10.2021.
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
