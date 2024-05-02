//
//  RunView.swift
//  Steps
//
//  Created by Ciaran Murphy on 4/25/24.
//

import SwiftUI
import HealthKit

struct RunView: View {
    let workout: HKWorkout
    @State private var runCounted = true

    var body: some View {
        VStack {
            Text("Run Details")
                .font(.title)
                .padding()
            
            Text("Date: \(workout.startDate.formatted(date: .long, time: .omitted))")
                .padding()
            
            Text("Time: \(workout.startDate.formatted(date: .omitted, time: .shortened))")
                .padding()
            
            Text("Distance: \(String(format: "%.2f", workout.totalDistance?.doubleValue(for: .mile()) ?? 0)) miles")
                .padding()
            
            Toggle("Count workout", isOn: $runCounted)
                .frame(width: 200)
            
            Spacer()
            
        }
    }
}

struct RunView_Previews: PreviewProvider {
    static var previews: some View {
        let mockWorkout = HKWorkout(activityType: .running, start: Date(), end: Date(), duration: 3600, totalEnergyBurned: nil, totalDistance: HKQuantity(unit: .mile(), doubleValue: 5.0), metadata: nil)
        
        return RunView(workout: mockWorkout)
    }
}


//#Preview {
//    RunView(workout: )
//}
