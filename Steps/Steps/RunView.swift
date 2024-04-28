//
//  RunView.swift
//  Steps
//
//  Created by Ciaran Murphy on 4/25/24.
//

import SwiftUI

struct RunView: View {
    let run: Run
    
    var body: some View {
        Text("Your run for \(run.workoutDate.formatted(date: .abbreviated, time: .omitted)): ")
            .font(.title2)
        HStack{
            Text(String(run.distance))
                .padding()
                .font(.title2)
            Text("Miles")
                .font(.title2)
        }
        
        //Toggle("Count this workout", isOn: run.workoutCounted)
    }
}

#Preview {
    RunView(run: .exampleRun)
}
