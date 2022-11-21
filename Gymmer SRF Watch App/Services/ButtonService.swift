//
//  ButtonConfig.swift
//  Gymmer SRF WatchKit Extension
//
//  Created by Mohammed Shereif on 23/10/22.
//

import Foundation
import SwiftUI

class ButtonService: ObservableObject {
    
    var config: ButtonListModel
    
    static let shared: ButtonService = {
        let mainValue = getUserDefaultValue(.main)
        let leftValue = getUserDefaultValue(.left)
        let rightValue = getUserDefaultValue(.right)
        
        var leftButtonModel = ButtonModel(type: .left, value: leftValue, icon: "stop", iconColor: .red, label: "stop", color: .gray, opacity: 0.6, corners: [.topLeft, .bottomLeft])
        var mainButtonModel = ButtonModel(type: .main, value: mainValue, icon: "\(MainIcon.play)", iconColor: .white, label: "start", color: .blue, opacity: 0.9, corners: [])
        var rightButtonModel = ButtonModel(type: .right, value: rightValue, icon: "xmark", iconColor: .red, label: "end", color: .gray, opacity: 0.6, corners: [.topRight, .bottomRight])
        
        let config = ButtonListModel(mainButton: mainButtonModel, leftButton: leftButtonModel, rightButton: rightButtonModel)
        
        let instance = ButtonService(config)
        
        return instance
    }()
    
    init(_ config: ButtonListModel) {
        self.config = config
    }
    
    private static func getUserDefaultValue(_ key: ButtonTypeEnum) -> Int {
        let constants = Constants.shared.ButtonValue
        var constantValue = 0
        
        switch key {
        case .main:
            constantValue = constants.mainButtonValue
        case .left:
            constantValue = constants.leftButtonValue
        case .right:
            constantValue = constants.rightButtonValue
        }
        
        return UserDefaults.standard.value(forKey: key.rawValue) as? Int ?? constantValue
    }
    
    func ChangeButtonValue(type: ButtonTypeEnum, value: Int) {
        switch type {
        case .main:
            self.config.mainButton.value = value
        case .left:
            self.config.leftButton.value = value
        case .right:
            self.config.rightButton.value = value
        }
        UserDefaults.standard.set(value, forKey: type.rawValue)
    }
}
