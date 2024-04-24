//
//  ContentView.swift
//  Steps
//
//  Created by Ciaran Murphy on 4/21/24.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    @State private var runningWorkouts: [HKWorkout] = []
    private let healthStore = HKHealthStore()
    
    @State private var showingShoeSheet = false
    @State private var sneaker = Sneaker.exampleSneaker
    
    var totalDistanceInMiles: Double {
            runningWorkouts.reduce(0.0) { total, workout in
                total + (workout.totalDistance?.doubleValue(for: .mile()) ?? 0)
            }
        }
    
    
    var body: some View {
        
        var percentage = (totalDistanceInMiles / sneaker.life) * 100
        
        NavigationStack{
            
            if sneaker.sneakerLoaded == true {
                VStack {
                    Text("Total Distance: \(totalDistanceInMiles, specifier: "%.2f") miles")
                        .font(.title)
                        .padding()
                    
                    Text("You are \(percentage, specifier: "%.1f")% through your shoe's life")
                    
                    List(runningWorkouts.reversed(), id: \.self) { workout in
                        Text("\(workout.startDate.formatted(date: .numeric, time: .omitted)) \(String(format: "%.2f", workout.totalDistance?.doubleValue(for: .mile()) ?? 0)) miles")
                        
                    }
                    .onAppear {
                        requestAuthorization()
                        fetchRunningWorkouts()
                    }
                }
                //.navigationTitle("Total Distance")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing){
                        Button("My Sneakers", systemImage: "shoe.fill"){
                            showingShoeSheet = true
                        }
                    }
                }
            } else {
                Button(action: { showingShoeSheet = true}) {
                ContentUnavailableView("No sneakers loaded", systemImage: "shoe.2.fill", description: Text("Tap to add your sneakers!"))
            }

            }
            
            
            
        }
        .sheet(isPresented: $showingShoeSheet){
            MySneakers()
        }
        
    }
    
    private func requestAuthorization() {
        let typesToRead: Set<HKSampleType> = [
            HKObjectType.workoutType()
        ]
        
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, error in
            if let error = error {
                print("Authorization request failed: \(error.localizedDescription)")
            }
        }
    }
    
    /*private func fetchRunningWorkouts() {
        let workoutType = HKObjectType.workoutType()
        let predicate = HKQuery.predicateForWorkouts(with: .running)
        let query = HKSampleQuery(sampleType: workoutType,
                                  predicate: predicate,
                                  limit: HKObjectQueryNoLimit,
                                  sortDescriptors: nil) { query, samples, error in
            if let error = error {
                print("Failed to fetch running workouts: \(error.localizedDescription)")
                return
            }
            
            guard let samples = samples as? [HKWorkout] else {
                return
            }
            
            DispatchQueue.main.async {
                self.runningWorkouts = samples
            }
        }
        
        healthStore.execute(query)
    }*/
    
    private func fetchRunningWorkouts() {
        let workoutType = HKObjectType.workoutType()
        let predicate = HKQuery.predicateForWorkouts(with: .running)
        
        // Create a predicate to filter workouts that started on or after the purchase date of the sneakers
        let sneakerPurchaseDatePredicate = HKQuery.predicateForSamples(withStart: sneaker.purchaseDate, end: nil, options: .strictStartDate)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, sneakerPurchaseDatePredicate])
        
        let query = HKSampleQuery(sampleType: workoutType,
                                  predicate: compoundPredicate,
                                  limit: HKObjectQueryNoLimit,
                                  sortDescriptors: nil) { query, samples, error in
            if let error = error {
                print("Failed to fetch running workouts: \(error.localizedDescription)")
                return
            }
            
            guard let samples = samples as? [HKWorkout] else {
                return
            }
            
            DispatchQueue.main.async {
                self.runningWorkouts = samples
            }
        }
        
        healthStore.execute(query)
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
