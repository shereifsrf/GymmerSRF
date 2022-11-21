//
//  ContentView.swift
//  Gymmer SRF WatchKit Extension
//
//  Created by Mohammed Shereif on 15/10/22.
//

import SwiftUI

enum MainViewsEnum {
    case gymmer, configure
}

struct ContentView: View {
    
    var body: some View {
        VStack {
            navigationLinkView(text: "Gymmer", icon: "clock", destination: GymmerView(), height: 150, color: .yellow, font: .title2, imgSize: .largeTitle)
            navigationLinkView(text: "Configure", icon: "gearshape", destination: ConfigureView(), height: 30, color: .green, font: .body, imgSize: .title2)
        }
    }
}

private struct navigationLinkView<T: View>: View {
    var text: String
    var icon: String
    var destination: T
    var height: Int
    var color: Color
    var font: Font
    var imgSize: Font
    
    var body: some View {
        NavigationLink(destination: destination) {
            HStack(alignment: .center) {
                Image(systemName: icon)
                    .foregroundColor(Color.blue)
                    .font(imgSize.bold())
                Text(text)
                    .foregroundColor(Color.blue)
                    .font(font)
                    .fontWeight(.semibold)
            }
            .frame(height: CGFloat(height))
        }
        .background(color)
        .cornerRadius(20)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
