//
//  Constants.swift
//  Gymmer SRF WatchKit Extension
//
//  Created by Mohammed Shereif on 12/11/22.
//

import Foundation

class Constants {
    static let shared = Constants()
    private init(){}
    
    let ButtonValue = ButtonValuesModel(main: 60, left: 45, right: 90)
    let secondNotifyAfter = TimeInterval(5)
    let noOfAlarmsAfter = 5
}
