//
//  ButtonTypeClass.swift
//  Gymmer SRF WatchKit Extension
//
//  Created by Mohammed Shereif on 12/11/22.
//

import Foundation

class ButtonValuesModel{
    let mainButtonValue: Int
    let leftButtonValue: Int
    let rightButtonValue: Int
    
    init(main :Int, left: Int, right: Int) {
        self.mainButtonValue = main
        self.leftButtonValue = left
        self.rightButtonValue = right
    }
}
