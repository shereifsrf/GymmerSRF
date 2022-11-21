//
//  ViewConfig.swift
//  Gymmer SRF WatchKit Extension
//
//  Created by Mohammed Shereif on 23/10/22.
//
import SwiftUI

enum MainIcon {
    case pause, play
}

class ButtonListModel: ObservableObject {
    
    @Published var mainButton: ButtonModel
    
    var leftButton: ButtonModel
    var rightButton: ButtonModel
    
    init(mainButton: ButtonModel, leftButton: ButtonModel, rightButton: ButtonModel) {
        self.mainButton = mainButton
        self.leftButton = leftButton
        self.rightButton = rightButton
    }
    
    func ShowIcon() {
        self.mainButton.ShowIcon()
        self.leftButton.ShowIcon()
        self.rightButton.ShowIcon()
    }
    
    func HideIcon() {
        self.mainButton.HideIcon()
        self.leftButton.HideIcon()
        self.rightButton.HideIcon()
    }
    
    func GetDuration(buttonType: ButtonTypeEnum) -> Int {
        switch buttonType {
        case .main:
            return mainButton.value
        case .left:
            return leftButton.value
        case .right:
            return rightButton.value
        }
    }
    
    func MainPauseIcon() {
        mainButton.icon = "\(MainIcon.pause)"
    }
    
    func MainPlayIcon() {
        mainButton.icon = "\(MainIcon.play)"
    }
}
