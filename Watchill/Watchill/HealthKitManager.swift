//
//  HealthKitManager.swift
//  Watchill
//
//  Created by Wilquer Torres de Lima on 28/05/19.
//  Copyright © 2019 Danilo da Rocha Lira Araujo. All rights reserved.
//

import Foundation
import HealthKit

class HealthKitManager {
    
    static let healthKitStore = HKHealthStore()
    static var heartRateQuery:HKObserverQuery? = nil
    
    static func authorizeHealthKit(){
        let healthKitTypes: Set = [
            HKObjectType.quantityType(forIdentifier: .heartRate)!
        ]
        
        healthKitStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { (success, error) in
            if success {
                print("success")
                self.subscribeToHeartBeatChanges()
            } else {
                print("failure")
            }
            
            if let error = error { print(error) }
        }
    }
    
    //gerar dados mocados, testado
    /*static func saveMockHeartData(){
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        let hearRateQuantity = HKQuantity(unit: HKUnit(from: "count/min"), doubleValue: Double(arc4random_uniform(80) + 100))
        let heartSample = HKQuantitySample(type: heartRateType, quantity: hearRateQuantity, start: NSDate() as Date, end: NSDate() as Date)
        
        healthKitStore.save(heartSample) { (success, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    
    
    static func observerHeartRate(){
        let hearRateSampleType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        
        let observerQuery = HKObserverQuery(sampleType: hearRateSampleType, predicate: nil, updateHandler: { (query: HKObserverQuery, completionHandler: HKObserverQueryCompletionHandler, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            completionHandler()
        })
        healthKitStore.execute(observerQuery)
        healthKitStore.enableBackgroundDelivery(for: hearRateSampleType, frequency: .immediate) { (success, error) in
            if success {
                print("success")
            } else {
                print("failure")
            }
            
            if let error = error { print(error) }
        }
        
    }*/
    
    static func subscribeToHeartBeatChanges() {
        
        // Creating the sample for the heart rate
        let sampleType: HKSampleType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        
        /// Creating an observer, so updates are received whenever HealthKit’s
        // heart rate data changes.
        self.heartRateQuery = HKObserverQuery.init( sampleType: sampleType, predicate: nil) {_, _, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
        }
        
        self.fetchLatestHeartRateSample { (sample) in
            guard let sample = sample else {
                return
            }
            /// The completion in called on a background thread, but we
            /// need to update the UI on the main.
            DispatchQueue.main.async {
                /// Converting the heart rate to bpm
                let heartRateUnit = HKUnit(from: "count/min")
                let heartRate = sample.quantity.doubleValue(for: heartRateUnit)
                
                let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
                let hearRateQuantity = HKQuantity(unit: HKUnit(from: "count/min"), doubleValue: heartRate)
                let heartSample = HKQuantitySample(type: heartRateType, quantity: hearRateQuantity, start: Date.distantPast, end: Date.distantFuture)
                
                //healthKitStore.save(heartSample)
                
                self.saveHeartData(heartValue: heartRate)
                /// Updating the UI with the retrieved value
                //self?.heartRateLabel.setText("\(Int(heartRate))")
                print("Double: \(heartRate) \n Int: \(Int(heartRate))")
                
            }
        }
        
    }
    //salvar os dados verdadeiros
    static func saveHeartData(heartValue: Double){
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        let hearRateQuantity = HKQuantity(unit: HKUnit(from: "count/min"), doubleValue: heartValue)
        let heartSample = HKQuantitySample(type: heartRateType, quantity: hearRateQuantity, start: Date.distantPast, end: Date.distantFuture)
        
        healthKitStore.save(heartSample) { (success, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    
    static func fetchLatestHeartRateSample(completion: @escaping (_ sample: HKQuantitySample?) -> Void){
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
                completion(nil)
                return
        }
        let predicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: Int(HKObjectQueryNoLimit),
            sortDescriptors: [sortDescriptor]) { (_, results, error) in
                
                guard error == nil else {
                    print("Error: \(error!.localizedDescription)")
                    return
                }
                
                completion(results?[0] as? HKQuantitySample)
        }
        
        healthKitStore.execute(query)
    }
}
