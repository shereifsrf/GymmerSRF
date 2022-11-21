//
//  ButtonConfig.swift
//  Gymmer SRF WatchKit Extension
//
//  Created by Mohammed Shereif on 23/10/22.
//
import Foundation
import SwiftUI

enum ButtonTypeEnum: String {
    case main, left, right
}

class ButtonModel: ObservableObject {
    
    @Published var icon: String
    @Published var showIcon: Bool
    @Published var value: Int
    
    var type: ButtonTypeEnum
    var iconColor: Color
    var label: String
    var color: Color
    var opacity: Double
    var corners: UIRectCorner
    var showLabel: Bool
    
    init(type: ButtonTypeEnum, value: Int, icon: String, iconColor: Color, label: String, color: Color, opacity: Double, corners: UIRectCorner, showIcon: Bool = false, showLabel: Bool = false) {
        self.type = type
        self.value = value
        self.icon = icon
        self.iconColor = iconColor
        self.label = label
        self.color = color
        self.opacity = opacity
        self.corners = corners
        self.showIcon = showIcon
        self.showLabel = showLabel
    }
    
    // show icon and label
    func ShowIcon() {
        self.showIcon = true
        self.showLabel = true
    }
    
    // show value
    func HideIcon() {
        self.showIcon = false
        self.showLabel = false
    }
}
