//
//  StatisticsView.swift
//  Steps
//
//  Created by Ciaran Murphy on 5/4/24.
//

import SwiftUI

struct StatisticsView: View {
    let totalDistanceInMiles: Double
        let percentage: Double
        let sneaker: Sneaker
    
    var body: some View {
        VStack {
            Text("Total Distance: \(totalDistanceInMiles, specifier: "%.2f") miles")
                .font(.title)
                .padding()
            
            Text("You are \(percentage, specifier: "%.1f")% through your shoe's life")
            //Spacer()
            Text("You purchased your \(sneaker.shoeName)s on \(sneaker.purchaseDate.formatted(date: .numeric, time:    .omitted))")
        }
    }
}

//#Preview {
//    StatisticsView()
//}
