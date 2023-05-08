//
//  HealthKitManager.swift
//  MeditationWatch Watch App
//
//  Created by Bartosz Wojtkowiak on 08/05/2023.
//

//import Foundation
import HealthKit
import SwiftUI

class HealthKitManager: ObservableObject {
    
    private var healthStore = HKHealthStore()
    @Published var value = 0
    let heartRateQuantity = HKUnit(from: "count/min")
    @Published  var backgroundColor: Color = .black
    @Published var message = ""
    @Published var description = ""
    @Published var durationValue = 0.0
    
    func start() {
        autorizeHealthKit()
        startHeartRateQuery(quantityTypeIdentifier: .heartRate)
        calculateMessageAndColor(value: value)
    }
    
    func autorizeHealthKit() {
        let healthKitTypes: Set = [
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!]
        
        healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { _, _ in }
    }
    
    private func startHeartRateQuery(quantityTypeIdentifier: HKQuantityTypeIdentifier) {
        let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])

        let updateHandler: (HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, Error?) -> Void = {
            query, samples, deletedObjects, queryAnchor, error in
            
            guard let samples = samples as? [HKQuantitySample] else {
                return
            }
            
            self.process(samples, type: quantityTypeIdentifier)
        }
        
        let query = HKAnchoredObjectQuery(type: HKObjectType.quantityType(forIdentifier: quantityTypeIdentifier)!, predicate: devicePredicate, anchor: nil, limit: HKObjectQueryNoLimit, resultsHandler: updateHandler)
        
        query.updateHandler = updateHandler
        
        healthStore.execute(query)
    }
    
    private func process(_ samples: [HKQuantitySample], type: HKQuantityTypeIdentifier) {
        var lastHeartRate = 0.0
        
        for sample in samples {
            if type == .heartRate {
                lastHeartRate = sample.quantity.doubleValue(for: heartRateQuantity)
            }
            
            self.value = Int(lastHeartRate)
            calculateMessageAndColor(value: Int(lastHeartRate))
        }
    }
    
    private func calculateMessageAndColor(value: Int) {
        switch value {
        case 101...200:
            backgroundColor = .red
            message = "Enormous stress"
            description = "Get medical help"
            durationValue = 0.1
        case 0...60:
            backgroundColor = .red
            message = "Bradycardia"
            description = "Get medical help"
            durationValue = 1.0
        case 83...89:
            backgroundColor = .yellow
            message = "Increased stress"
            description = "Breathing exercises"
            durationValue = 0.4
        case 90...100:
            backgroundColor = .orange
            message = "High stress"
            description = "Time to meditate"
            durationValue = 0.3
        default:
            backgroundColor = .green
            message = "Normal BPM"
            durationValue = 0.5
        }
    }
}
