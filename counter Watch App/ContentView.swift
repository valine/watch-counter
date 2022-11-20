//
//  ContentView.swift
//  counter Watch App
//
//  Created by Valine, Lukas on 11/17/22.
//

import ClockKit
import SwiftUI
import WidgetKit
import HealthKit

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
   
    @State var count: Int = (UserDefaults.standard.integer(forKey: "Count"))
    @State var countNew = 0
    
    let store = HKHealthStore()
    
    func requestPermission () async -> Bool {
        print("requesting permission")
        var write: Set<HKSampleType> = [.workoutType()]
        write.insert(HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed)!)

        var read: Set<HKSampleType> = [.workoutType()]
        read.insert(HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed)!)


        let res: ()? = try? await store.requestAuthorization(toShare: write, read: read)
        guard res != nil else {
            return false
        }

        return true
    }
    
    func readDietaryEnergy() {
        guard let energyType = HKSampleType.quantityType(forIdentifier: .dietaryEnergyConsumed) else {
            print("Sample type not available")
            return
        }

        let end = Date()
        let start = end.startOfDay
       
        let Predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)

        let dietaryEnergyQuery = HKSampleQuery(sampleType: energyType,
                                        predicate: Predicate,
                                        limit: HKObjectQueryNoLimit,
                                        sortDescriptors: nil) {
                                            (query, sample, error) in

                                            guard
                                                error == nil,
                                                let quantitySamples = sample as? [HKQuantitySample] else {
                                                    print("Something went wrong: \(String(describing: error))")
                                                    return
                                            }

                                            let total = quantitySamples.reduce(0.0) { $0 + $1.quantity.doubleValue(for: HKUnit.kilocalorie()) }
                                            DispatchQueue.main.async {
                                                print("reading from healthkit")
                                                print(total)
                                            }
        }
        HKHealthStore().execute(dietaryEnergyQuery)
    }
    
    func incCount(count: Int) {
        self.count += count;
        self.countNew += count;
        UserDefaults.standard.set(self.count, forKey: "Count")
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    
    func decCount(count: Int) {
        self.count -= count;
        self.countNew -= count;
        UserDefaults.standard.set(self.count, forKey: "Count")
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func resetCount() {
        count = 0
        countNew = 0
        UserDefaults.standard.set(self.count, forKey: "Count")
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    
    func resetNewCount() {
        countNew = 0
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .bottom) {
                Text(String(count)).font(.system(size: 36))
                    .fixedSize()
                    .frame(width: 75, alignment: .bottomLeading)
                Text(String(countNew))
                    .fixedSize()
                    .frame(width: 70, alignment: .bottom)
                    .foregroundColor(Color.green)
                    .onTapGesture {
                        decCount(count: countNew)
                        resetNewCount()
                    }
                Spacer()
            }.padding(20)
            ScrollView {
                Button("+100") {
                    incCount(count:100)
                }
                Button("+25") {
                    incCount(count:25)
                }
                Button("+10") {
                    incCount(count:10)
                }
                Button("+5") {
                    incCount(count:5)
                }
                
                Button("-100") {
                    decCount(count:100)
                }
                Button("-25") {
                    decCount(count:25)
                }
                Button("-10") {
                    decCount(count:10)
                }
                Button("-5") {
                    decCount(count:5)
                }
                
                Button("Reset") {
                    resetCount()
                }
                .foregroundColor(Color.red)
            }.frame(maxWidth: .infinity, minHeight: 100, maxHeight: .infinity, alignment: .topTrailing)
                .edgesIgnoringSafeArea(.all)

        }.edgesIgnoringSafeArea(.all).onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                resetNewCount()
            } else if newPhase == .inactive {
                print("Inactive")
            } else if newPhase == .background {
                print("Background")
            }
        }.task {
            if !HKHealthStore.isHealthDataAvailable() {
                print("no health data")
                return
            } else {
                readDietaryEnergy()
            }

            guard await requestPermission() == true else {
                return
            }
        }
    }
}

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
