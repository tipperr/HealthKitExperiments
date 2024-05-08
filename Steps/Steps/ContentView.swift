//
//  ContentView.swift
//  Steps
//
//  Created by Ciaran Murphy on 4/21/24.
//

import SwiftUI
import HealthKit
import UserNotifications

struct ContentView: View {
    @State private var runningWorkouts: [HKWorkout] = []
    private let healthStore = HKHealthStore()
    @State private var showingShoeSheet = false
    private let runningWorkoutsDeliveryIdentifier = "com.steps.runningWorkoutsDelivery"
    @StateObject private var backgroundUpdateHandler = BackgroundUpdateHandler()
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
                        setupBackgroundDelivery()
                    }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing){
                        MySneakersButtonView(showingShoeSheet: $showingShoeSheet)
                    }
                }
                .refreshable {
                    fetchRunningWorkouts()
                }
//                Button(action: {
//                                        scheduleLocalNotification()
//                }) {
//                    Text("Schedule Local Notification")
//                        .padding()
//                        .foregroundColor(.white)
//                        .background(Color.blue)
//                        .cornerRadius(10)
//                }
//                                    .padding()
                
                VStack {

                    Button("Schedule Notification") {
                        let content = UNMutableNotificationContent()
                        let formattedPercentage = String(format: "%.1f", percentage)
                        content.title = "New workout!"
                        content.subtitle = "You're \(formattedPercentage)% through your \(sneaker.shoeName)'s life!"
                        content.sound = UNNotificationSound.default

                        // show this notification five seconds from now
                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

                        // choose a random identifier
                        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                        // add our notification request
                        UNUserNotificationCenter.current().add(request)
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
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        print("Notification permission granted.")
                    } else if let error = error {
                        print("Notification permission request failed: \(error.localizedDescription)")
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
    
    private func setupBackgroundDelivery() {
        let workoutType = HKObjectType.workoutType()
        let predicate = HKQuery.predicateForWorkouts(with: .running)
        
        let deliveryQuery = HKObserverQuery(sampleType: workoutType, predicate: predicate) { query, completionHandler, error in
            if let error = error {
                print("Background delivery query failed: \(error.localizedDescription)")
                return
            }
            
            // Handle the new data received in the completion handler
            
            completionHandler()
        }
        
        healthStore.execute(deliveryQuery)
        
        healthStore.enableBackgroundDelivery(for: workoutType, frequency: .immediate) { success, error in
            if let error = error {
                print("Failed to enable background delivery: \(error.localizedDescription)")
                return
            }
            
            if success {
                print("Background delivery enabled successfully.")
            } else {
                print("Failed to enable background delivery.")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
