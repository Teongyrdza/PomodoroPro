//
//  Time.swift
//  PomodoroPro
//
//  Created by Ostap on 15.12.2020.
//

import Foundation
import SwiftUI

enum TimeComponent: CaseIterable, CustomStringConvertible {
    case hours, minutes, seconds
    
    var description: String {
        switch self {
            case .seconds:
                return "Seconds"
            case .minutes:
                return "Minutes"
            case .hours:
                return "Hours"
        }
    }
}

func timeComponent(at index: Int) -> TimeComponent {
    return TimeComponent.allCases[index]
}

struct Time: Hashable, Codable, CustomStringConvertible {
    // Max values
    static let maxHours: Int = 24
    static let maxMinutes: Int = 60
    static let maxSeconds: Int = 60
    
    static func maxValue(for component: TimeComponent) -> Int {
        switch component {
        case .seconds:
            return maxSeconds
        case .minutes:
            return maxMinutes
        case .hours:
            return maxHours
        }
    }
    
    var hours: Int
    var minutes: Int
    var seconds: Double
    
    // Initializer with hour, minute and seconds
    init(_ h: Int, _ m: Int, _ s: Double) {
        self.hours = h
        self.minutes = m
        self.seconds = s
    }
    
    // Initializer with total of seconds
    init(_ seconds: Double) {
        let h = Int(seconds) / 3600
        let m = (Int(seconds) - (h * 3600)) / 60
        let s = Int(seconds) - (h * 3600) - (m * 60)
        
        self.hours = h
        self.minutes = m
        self.seconds = Double(s)
    }
    
    // Subscript to set value of component
    subscript(component: TimeComponent) -> Int {
        get {
            switch component {
                case .hours:
                    return hours
                case .minutes:
                    return minutes
                case .seconds:
                    return Int(seconds)
            }
        }
        set {
            switch component {
                case .hours:
                    hours = newValue
                case .minutes:
                    minutes = newValue
                case .seconds:
                    seconds = Double(newValue)
            }
        }
    }
    
    // compute number of seconds
    var asSeconds: Double {
        return Double(hours) * 3600 + Double(minutes) * 60 + seconds
    }
    
    // show as string
    func asString() -> String {
        return String(format: "%2i", hours) + ":" + String(format: "%02i", minutes) + ":" + String(format: "%02i", seconds)
    }
    
    var description: String {
        asString()
    }
}

extension Time: Comparable {
    static func < (lhs: Time, rhs: Time) -> Bool {
        return lhs.asSeconds < rhs.asSeconds
    }
}

extension Time: VectorArithmetic {
    static var zero: Time {
        return Time(0, 0, 0)
    }

    var magnitudeSquared: Double { return asSeconds * asSeconds }
    
    static func -= (lhs: inout Time, rhs: Time) {
        lhs = lhs - rhs
    }
    
    static func - (lhs: Time, rhs: Time) -> Time {
        return Time(lhs.asSeconds - rhs.asSeconds)
    }
    
    static func += (lhs: inout Time, rhs: Time) {
        lhs = lhs + rhs
    }
    
    static func + (lhs: Time, rhs: Time) -> Time {
        return Time(lhs.asSeconds + rhs.asSeconds)
    }
    
    mutating func scale(by rhs: Double) {
        var s = self.asSeconds
        s.scale(by: rhs)
        
        let ct = Time(s)
        self.hours = ct.hours
        self.minutes = ct.minutes
        self.seconds = ct.seconds
    }
}
