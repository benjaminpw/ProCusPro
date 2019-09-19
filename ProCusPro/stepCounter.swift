//
//  stepCounter.swift
//  ProCusPro
//
//  Created by Benjamin Purbowasito on 19/09/19.
//  Copyright © 2019 iosda. All rights reserved.
//

import UIKit
import HealthKit

class StepCunter: UIViewController {
    let healthStore = HKHealthStore()
    let sampleData = [String]()
    
    @IBOutlet weak var stepCountLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkAvailability()
        getStepCountData()
    }
    
    
    func checkAvailability() {
        if HKHealthStore.isHealthDataAvailable() {
            let allTypes = Set([HKObjectType.workoutType(),
                                HKObjectType.quantityType(forIdentifier: .stepCount)!,
                                HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!])
            
            healthStore.requestAuthorization(toShare: allTypes, read: allTypes) {
                (success, error) in
                if !success {
                    print("error")
                }
            }
        }
    }
    
    func getStepCountData() {
        let stepCountUnit: HKUnit = HKUnit.count()
        let limit = HKObjectQueryNoLimit
        let calendar = Calendar.current
        let thisMorning = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: Date())
        let today = Date()
        let predicate = HKQuery.predicateForSamples(withStart: thisMorning, end: today, options: .strictEndDate)
        let sortDescriptors = [NSSortDescriptor(key: HKSampleSortIdentifierEndDate,ascending: true)]
        
        guard let sampleType = HKSampleType.quantityType(forIdentifier: .stepCount) else {
            fatalError("***This Method Should Never Fail***")
        }
        print(sampleType)
        
        let sampleQuery = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: limit, sortDescriptors: sortDescriptors) {
            query, results, error in
            
            guard let samples = results as? [HKQuantitySample] else {
                fatalError("An error occured fetching the user's tracked food. In your app, try to handle this error gracefully. The error was:\(error?.localizedDescription)");
            }
            
            DispatchQueue.main.async {
                for sample in samples {
                    let step = sample.quantity.doubleValue(for: stepCountUnit)
                    print("\(step)")
                    self.stepCountLbl.text = "\(step)"
                }
            }
        }
        
        self.healthStore.execute(sampleQuery)
    }
    
    
}
