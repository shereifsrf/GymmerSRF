//
//  ElapsedTimeView.swift
//  Gymmer SRF WatchKit Extension
//
//  Created by Mohammed Shereif on 24/10/22.
//

import SwiftUI

enum ElapsedTimeFontEnum {
    case small, large
}

struct ElapsedTimeView: View {
    @EnvironmentObject var wms: WorkoutManagerService
    
    var elapsedTime: TimeInterval = 0
    var font: ElapsedTimeFontEnum = .small
    var timeFormatter = ElapsedTimeFormatter()
    
    var body: some View {
        mainContent
    }
    
    func getTimeFormatter(_ showSubSeconds: Bool) -> ElapsedTimeFormatter {
        timeFormatter.showSubSeconds = showSubSeconds
        return timeFormatter
    }
}

extension ElapsedTimeView {
    private var mainContent: some View {
        
        TimelineView(MetricsTimelineSchedule(from: wms.builder?.startDate ?? Date())) { context in
            let elapsedTime: TimeInterval = wms.running ? wms.builder?.elapsedTime ?? 0 : 0
            
            Text(NSNumber(value: elapsedTime), formatter: getTimeFormatter(context.cadence == .live))
                .font(font == .small ? .system(size: 12) : .largeTitle)
                .foregroundColor(.green)
        }
    }
}

private struct MetricsTimelineSchedule: TimelineSchedule {
    var startDate: Date
    
    init(from startDate: Date) {
        self.startDate = startDate
    }
    
    func entries(from startDate: Date, mode: TimelineScheduleMode) -> PeriodicTimelineSchedule.Entries {
        PeriodicTimelineSchedule(from: self.startDate, by: mode == .lowFrequency ? 1.0 : 1.0/30.0)
            .entries(from: startDate, mode: mode)
    }
}

class ElapsedTimeFormatter: Formatter {
    var showSubSeconds = true
    let componentFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        
        return formatter
    }()
    
    override func string(for value: Any?) -> String? {
        guard let time = value as? TimeInterval else { return nil }
        
        guard let formattedString = componentFormatter.string(from: time) else { return nil }
        
        if showSubSeconds {
            let hundredth = Int(time.truncatingRemainder(dividingBy: 1) * 100)
            return String(format: "%@.%0.2d", formattedString, hundredth)
        }
        
        return formattedString
    }
    
}

struct ElapsedTimeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ElapsedTimeView().environmentObject(WorkoutManagerService())
            ElapsedTimeView(elapsedTime: 125, font: .large).environmentObject(WorkoutManagerService())
        }
    }
}
