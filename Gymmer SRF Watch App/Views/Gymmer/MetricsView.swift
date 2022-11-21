//
//  MetricsView.swift
//  Gymmer SRF WatchKit Extension
//
//  Created by Mohammed Shereif on 24/10/22.
//

import SwiftUI

struct MetricsView: View {
    @Binding var showEndConfirmation: Bool
    @EnvironmentObject var wms: WorkoutManagerService
    @State var toggler = false
    
    var body: some View {
        
        VStack(alignment: .leading) {
            ElapsedTimeView(font: .large)
            
            dataContent
            
            Spacer()
            
            buttonContent
        }
        .padding(.bottom, 10)
        .ignoresSafeArea(edges: .bottom)
    }
}

extension MetricsView {
    
    private var buttonContent: some View {
        Button(wms.running ? "Stop" : "Start") {
            if wms.running {
                showEndConfirmation = true
            } else {
                wms.StartWorkout()
            }
        }
        .tint(wms.running ? Color.red : Color.yellow)
    }
    
    private var dataContent: some View {
        TimelineView(.periodic(from: wms.builder?.startDate ?? Date(), by: 1))
        { _ in
            VStack(alignment: .leading) {
                HStack {
                    Text("🫀" )
                        .font(.largeTitle)
                    
                    VStack {
                        Text(wms.heartRate.formatted(.number.precision(.fractionLength(0)))
                        )
                        
                        Text(wms.averageHeartRate.formatted(.number.precision(.fractionLength(0)))
                        )
                    }
                    .padding(.trailing, 5)
                    
                    Text("bpm")
                        .font(.title3)
                }
                
                HStack {
                    Text("⚡️" )
                        .font(.largeTitle)
                    
                    Text(wms.activeEnergy.formatted(.number.precision(.fractionLength(0))))
                        .padding(.trailing, 5)
                    
                    Text("cal")
                        .font(.title3)
                }
            }
        }
    }
}


struct MetricsView_Previews: PreviewProvider {
    static var previews: some View {
        @State var showEndConfirmation = false
        return MetricsView(showEndConfirmation: $showEndConfirmation).environmentObject(WorkoutManagerService())
    }
}
