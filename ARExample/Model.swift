//
//  Model.swift
//  ARExample
//
//  Created by Den on 2020-10-26.
//

import Foundation

class Model {
    
    private let timeDuration: TimeInterval = 3
    private let periodTimes: Double = 90
    
    private(set) var value = 0.0
    private var maxValue = 1.0
    enum ValueChangingType {
        case raise, decline
    }
    var valueChanging: ValueChangingType = .raise
    
    
    init() {
    }
    
    
    func updateValue() {
        let step = maxValue / periodTimes
        if valueChanging == .raise {
            value += step
        } else {
            value -= step
        }
        if value >= maxValue {
            valueChanging = .decline
        }
        if value <= 0 {
            valueChanging = .raise
        }
    }
    
}
