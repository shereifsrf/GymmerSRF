//
//  MainView.swift
//  Gymmer SRF WatchKit Extension
//
//  Created by Mohammed Shereif on 15/10/22.
//

import SwiftUI

struct ButtonsView: View {
    @ObservedObject var config: ButtonListModel
    
    var mainButtonAction: () -> () = {}
    var leftButtonAction: () -> () = {}
    var rightButtonAction: () -> () = {}
    var selectedButton: ButtonTypeEnum? = nil
    var isConfigureView: Bool = false
    
    var body: some View {
        HStack(alignment: .bottom){
            SideButton(vm: SideButtonVM (
                config: config.leftButton,
                action: leftButtonAction,
                enableConfigure: selectedButton == .left,
                isConfigureView: isConfigureView
            ))
            .padding(.bottom, 5)
            
            SideButton(vm: SideButtonVM (
                config: config.mainButton,
                action: mainButtonAction,
                enableConfigure: selectedButton == .main,
                isConfigureView: isConfigureView
            ))
            
            SideButton(vm: SideButtonVM (
                config: config.rightButton,
                action: rightButtonAction,
                enableConfigure: selectedButton == .right,
                isConfigureView: isConfigureView
            ))
            .padding(.bottom, 5)
        }
    }
}

struct ButtonsView_ShowValue: PreviewProvider {
    static var previews: some View {
        let config = ButtonService.shared.config
        config.HideIcon()
        
        return ButtonsView(config: config)
    }
}

struct ButtonsView_ShowIcon: PreviewProvider {
    static var previews: some View {
        let config = ButtonService.shared.config
        config.ShowIcon()
        
        return ButtonsView(config: config)
    }
}

struct ButtonsView_Main_Configure: PreviewProvider {
    static var previews: some View {
        Group {
            ButtonsView(config: ButtonService.shared.config, selectedButton: .main, isConfigureView: true).previewLayout(.sizeThatFits)
            ButtonsView(config: ButtonService.shared.config, selectedButton: .left, isConfigureView: true).previewLayout(.sizeThatFits)
            ButtonsView(config: ButtonService.shared.config, selectedButton: .right, isConfigureView: true).previewLayout(.sizeThatFits)
        }
    }
}
