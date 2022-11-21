//
//  CountDownTimeView.swift
//  Gymmer SRF WatchKit Extension
//
//  Created by Mohammed Shereif on 16/10/22.
//

import SwiftUI

struct CountDownTimeView: View {
    var remainingSeconds: TimeInterval = 0
    
    var body: some View {
        let seconds = Int(remainingSeconds.rounded(.down))
        
        HStack{
            Text("\(seconds)")
                .font(.system(size: 60))
                .fontWeight(.bold)
                .foregroundColor(.yellow)
        }
    }
}

struct CountDownTimeView_Previews: PreviewProvider {
    static var previews: some View {
        CountDownTimeView(remainingSeconds: 21)
    }
}
