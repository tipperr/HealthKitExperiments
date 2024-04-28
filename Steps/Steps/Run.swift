//
//  Run.swift
//  Steps
//
//  Created by Ciaran Murphy on 4/25/24.
//

import HealthKit
import SwiftUI


struct Run {
    var distance: Double
    var workoutDate: Date
    var workoutCounted: Bool
    
    static let exampleRun: Run = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = dateFormatter.date(from: "2023-04-16") else {
            fatalError("Failed to create a Date object from the string")
        }
        
        return Run(distance: 1.0, workoutDate: date, workoutCounted: true)
    }()
}
