//
//  ContentView.swift
//  counter Watch App
//
//  Created by Valine, Lukas on 11/17/22.
//

import SwiftUI


struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
   

    @State var count: Int = (UserDefaults(suiteName: "Count")?.integer(forKey: "Count"))!
    @State var countNew = 0

    func incCount(count: Int) {
        self.count += count;
        self.countNew += count;
        UserDefaults(suiteName: "Count")?.set(self.count, forKey: "Count")
    }
    
    
    func decCount(count: Int) {
        self.count -= count;
        self.countNew -= count;
        UserDefaults(suiteName: "Count")?.set(self.count, forKey: "Count")
    }
    
    func resetCount() {
        count = 0
        countNew = 0
        
        UserDefaults(suiteName: "Count")?.set(self.count, forKey: "Count")
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
            VStack {
                Button("+100") {
                    incCount(count:100)
                }.buttonStyle(.borderedProminent)
                Button("+25") {
                    incCount(count:25)
                }.buttonStyle(.borderedProminent)
                Button("+10") {
                    incCount(count:10)
                }.buttonStyle(.borderedProminent)
                Button("+5") {
                    incCount(count:5)
                }.buttonStyle(.borderedProminent)
                
                Button("-100") {
                    decCount(count:100)
                }.buttonStyle(.borderedProminent)
                Button("-25") {
                    decCount(count:25)
                }.buttonStyle(.borderedProminent)
                Button("-10") {
                    decCount(count:10)
                }.buttonStyle(.borderedProminent)
                Button("-5") {
                    decCount(count:5)
                }.buttonStyle(.borderedProminent)
                
                Button("Reset") {
                    resetCount()
                }.buttonStyle(.bordered)
                .foregroundColor(Color.red)
            }.frame(maxWidth: .infinity,
                    minHeight: 100,
                    maxHeight: .infinity,
                    alignment: .top)
               

        }.onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                resetNewCount()
            } else if newPhase == .inactive {
                print("Inactive")
            } else if newPhase == .background {
                print("Background")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
