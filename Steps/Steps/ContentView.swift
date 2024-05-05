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
    #if targetEnvironment(simulator)
    @ObservedObject private var sneaker: Sneaker = Sneaker.exampleSneaker
    #else
    @ObservedObject private var sneaker = Sneaker(purchaseDate: Date(), shoeName: "Default Shoe", life: 300.0, sneakerLoaded: Bool())
    #endif
    
    let sneakersKey = "Sneakers"
    
    // Initialize with saved sneaker data if available
    init() {
            if let savedSneakerData = UserDefaults.standard.data(forKey: sneakersKey),
               let decodedSneaker = try? JSONDecoder().decode(Sneaker.self, from: savedSneakerData) {
                self.sneaker = decodedSneaker
            }
        }
    
    var totalDistanceInMiles: Double {
            runningWorkouts.reduce(0.0) { total, workout in
                total + (workout.totalDistance?.doubleValue(for: .mile()) ?? 0)
            }
        }
    
    
    var body: some View {
        
        var percentage = (totalDistanceInMiles / sneaker.life) * 100
        
        NavigationStack{
            
            if sneaker.sneakerLoaded == true {
                StatisticsView(totalDistanceInMiles: totalDistanceInMiles, percentage: percentage, sneaker: sneaker)
                
                RunningWorkoutsListView(runningWorkouts: runningWorkouts)
                    
                    .onAppear {
                        requestAuthorization()
                        fetchRunningWorkouts()
                    }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing){
                        MySneakersButtonView(showingShoeSheet: $showingShoeSheet)
                    }
                }
            } else {
                EmptySneakerView(showingShoeSheet: $showingShoeSheet)
            }
            
            
            
        }
        .sheet(isPresented: $showingShoeSheet){
            MySneakers(sneaker: sneaker/*, onRemoveSneaker: removeSneaker*/)
        }
        .onReceive(sneaker.$purchaseDate) { _ in
                    fetchRunningWorkouts()
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
    
    private func removeSneaker() {
            sneaker.sneakerLoaded = false
        }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
