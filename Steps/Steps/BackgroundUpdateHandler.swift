//
//  BackgroundUpdateHandler.swift
//  Steps
//
//  Created by Ciaran Murphy on 5/7/24.
//

import Foundation
import HealthKit

class BackgroundUpdateHandler: NSObject, ObservableObject {
    let healthStore = HKHealthStore()

    override init() {
        super.init()
        enableBackgroundDelivery()
    }

    private func enableBackgroundDelivery() {
        let workoutType = HKObjectType.workoutType()
        let predicate = HKQuery.predicateForWorkouts(with: .running)

        let observerQuery = HKObserverQuery(sampleType: workoutType, predicate: predicate) { query, completionHandler, error in
            if let error = error {
                print("Background delivery query failed: \(error.localizedDescription)")
                return
            }

            // Handle the new data received in the completion handler

            completionHandler()
        }

        healthStore.execute(observerQuery)

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
