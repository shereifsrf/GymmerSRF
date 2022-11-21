//
//  WorkoutManager.swift
//  Gymmer SRF WatchKit Extension
//
//  Created by Mohammed Shereif on 16/10/22.
//

import Foundation
import HealthKit

class WorkoutManagerService: NSObject, ObservableObject {
    // MARK: published or binded
    @Published var running = false
    var gym: Gym = Gym()
    
    
    // MARK: non-published
    var activeEnergy: Double = 0
    var heartRate: Double = 0
    var averageHeartRate: Double = 0
    let healthStore = HKHealthStore()
    var session: HKWorkoutSession?
    var builder: HKLiveWorkoutBuilder?
    
    
    // MARK: public functions
    func EndWorkout() {
        self.running = false
        session?.end()
        resetWorkout()
    }
    
    func StartWorkout() {
        self.running = true
        
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .traditionalStrengthTraining
        configuration.locationType = .indoor
        
        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            builder = session?.associatedWorkoutBuilder()
        } catch {
            return
        }
        
        builder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: configuration)
        session?.delegate = self
        builder?.delegate = self
        
        let startDate = Date()
        session?.startActivity(with: startDate)
        builder?.beginCollection(withStart: startDate) { (success, error) in
            // the workout has started
        }
    }
    
    // request authorization to access healthKit
    func RequestAuthorization() {
        let typesToShare: Set = [HKQuantityType.workoutType()]
        let typesToRead: Set = [
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
            // TODO: add these quantities by learning how to add
//            HKQuantityType.quantityType(forIdentifier: .bodyTemperature)!,
//            HKQuantityType.quantityType(forIdentifier: .respiratoryRate)!,
            HKObjectType.activitySummaryType()
        ]
        
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
            // handle error
            if error != nil {
                print("request authorization failed", error.debugDescription)
            }
        }
    }
    
    
    // MARK: private functions
    func updateForStatistics(_ statistics: HKStatistics?) {
        guard let statistics = statistics else { return }
        
        DispatchQueue.main.async {
            switch statistics.quantityType {
            case HKQuantityType.quantityType(forIdentifier: .heartRate):
                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                self.heartRate = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0
                self.averageHeartRate = statistics.averageQuantity()?.doubleValue(for: heartRateUnit) ?? 0
            case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
                let energyUnit = HKUnit.kilocalorie()
                self.activeEnergy = statistics.sumQuantity()?.doubleValue(for: energyUnit) ?? 0
            default:
                return
            }
        }
    }
    
    func resetWorkout() {
        builder = nil
        session = nil
        activeEnergy = 0
        averageHeartRate = 0
        heartRate = 0
    }
}

extension WorkoutManagerService: HKWorkoutSessionDelegate {
    func workoutSession(
        _ workoutSession: HKWorkoutSession,
        didChangeTo toState: HKWorkoutSessionState,
        from fromState: HKWorkoutSessionState,
        date: Date
    ) {
        //        DispatchQueue.main.async {
        //            self.running = toState == .running
        //        }
        
        if toState == .ended {
            builder?.endCollection(withEnd: date) { (success, Error) in
                self.builder?.finishWorkout { (workout, error) in
                    DispatchQueue.main.async {
                        
                    }
                }
            }
        }
    }
    
    func workoutSession(_ workout: HKWorkoutSession, didFailWithError error: Error) {
        
    }
}

extension WorkoutManagerService: HKLiveWorkoutBuilderDelegate {
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        
    }
    
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else {return}
            let statistics = workoutBuilder.statistics(for: quantityType)
            updateForStatistics(statistics)
        }
    }
}
