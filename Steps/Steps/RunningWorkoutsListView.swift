//
//  RunningWorkoutsListView.swift
//  Steps
//
//  Created by Ciaran Murphy on 5/4/24.
//

import SwiftUI
import HealthKit

struct RunningWorkoutsListView: View {
    var runningWorkouts: [HKWorkout]

    var body: some View {
        List(runningWorkouts.reversed(), id: \.self) { workout in
            NavigationLink(destination: RunView(workout: workout)) {
                HStack {
                    Text("\(workout.startDate.formatted(date: .numeric, time: .omitted)) ")
                    Spacer()
                    Text("\(String(format: "%.2f", workout.totalDistance?.doubleValue(for: .mile()) ?? 0)) miles")
                    Spacer()
                }
            }
        }
    }
}


//#Preview {
//    RunningWorkoutsListView(runningWorkouts: )
//}
