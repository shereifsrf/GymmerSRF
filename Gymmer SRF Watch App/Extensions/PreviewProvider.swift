//
//  PreviewProvider.swift
//  Gymmer SRF Watch App
//
//  Created by Mohammed Shereif on 20/11/22.
//

import Foundation
import SwiftUI

extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.shared
    }
}

class DeveloperPreview {
    static let shared = DeveloperPreview()
    private init(){}
}
