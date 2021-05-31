//
//  String.swift
//  PomodoroPro
//
//  Created by Ostap on 31.05.2021.
//

import Foundation

extension String.StringInterpolation {
    mutating func appendInterpolation(_ value: CVarArg, specifier: String) {
        appendInterpolation(String(format: specifier, value))
    }
}
