//
//  ButtonText.swift
//  Gymmer SRF WatchKit Extension
//
//  Created by Mohammed Shereif on 17/10/22.
//

import SwiftUI

struct ButtonText: View {
    var showIcon: Bool
    var value: Int
    var icon: String
    var iconColor: Color
    var textFont: Font
    var fontWeight: Font.Weight = .medium
    
    var body: some View {
        if showIcon {
            Image(systemName: icon)
                .font(textFont.bold())
                .foregroundColor(iconColor)
        } else {
            Text("\(value)")
                .font(textFont)
                .fontWeight(fontWeight)
        }
    }
}

struct ButtonText_Show_Text: PreviewProvider {
    static var previews: some View {
        return ButtonText(showIcon: false, value: 45, icon: "stop", iconColor: .red, textFont: .title3)
    }
}

struct ButtonText_Show_Icon: PreviewProvider {
    static var previews: some View {
        return ButtonText(showIcon: true, value: 45, icon: "stop", iconColor: .red, textFont: .title3)
    }
}
