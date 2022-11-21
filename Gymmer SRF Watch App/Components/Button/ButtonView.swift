//
//  SideButton.swift
//  Gymmer SRF WatchKit Extension
//
//  Created by Mohammed Shereif on 15/10/22.
//

import SwiftUI

class SideButtonVM: ObservableObject {
    var config: ButtonModel
    var action: () -> ()
    var enableConfigure: Bool
    var isConfigureView: Bool
    
    let radius: CGFloat = 100
    var showIcon: Bool
    
    init(config: ButtonModel, action: @escaping () -> (), enableConfigure: Bool, isConfigureView: Bool) {
        self.config = config
        self.action = action
        self.enableConfigure = enableConfigure
        self.isConfigureView = isConfigureView
        
        showIcon = isConfigureView ? false : config.showIcon
    }
    
    func getButtonBGColor() -> Color {
        var bgColor: Color = config.color.opacity(config.opacity)
        
        if isConfigureView {
            if enableConfigure {
                bgColor = .green
            } else if config.type == .main {
                bgColor = .gray.opacity(0.6)
            }            
        } else if config.showIcon && config.type != .main {
            bgColor = config.iconColor.opacity(0.2)
        }
        return bgColor
    }
}

struct SideButton: View {
    @ObservedObject var vm: SideButtonVM
    
    var body: some View {
        
        VStack{
            if vm.config.type != .main {
                hintText
            }
            
            buttonContent
        }
    }
}

extension SideButton {
    private var hintText: some View {
        Text("\(vm.config.label)")
            .font(.footnote)
            .opacity(vm.showIcon ? 1 : 0)
    }
    
    private var buttonContent: some View {
        Button(action: {
            vm.action()
        }, label: {
            if (vm.config.type != .main) {
                textContent
            } else {
                circleContent
            }
        })
        .buttonStyle(PlainButtonStyle())
    }
    
    private var circleContent: some View {
        Circle()
            .fill(vm.getButtonBGColor())
            .frame(width: 70, height: 70, alignment: .center)
            .overlay(
                textContent
                    .clipShape(Circle())
            )
    }
    
    private var textContent: some View {
        ButtonText(
            showIcon: vm.showIcon,
            value: vm.config.value,
            icon: vm.config.icon,
            iconColor: vm.config.iconColor,
            textFont: .title3
        )
        .frame(width: 56, height: 55)
        .background(vm.getButtonBGColor().opacity(vm.config.type != .main ? 1 : 0))
        .cornerRadius(vm.radius, corners: vm.config.corners)
    }
}

struct SideButton_Timer: PreviewProvider {
    static var previews: some View {
        let config = ButtonService.shared.config.leftButton
        config.HideIcon()
        return SideButton(vm: SideButtonVM(config: config, action: {}, enableConfigure: false, isConfigureView: false))
    }
}

struct SideButton_Timer_ShowIcon: PreviewProvider {
    static var previews: some View {
        let config = ButtonService.shared.config.rightButton
        config.ShowIcon()
        return SideButton(vm: SideButtonVM(config: config, action: {}, enableConfigure: false, isConfigureView: false))
    }
}

struct SideButton_Timer_MainButton: PreviewProvider {
    static var previews: some View {
        let config = ButtonService.shared.config.mainButton
        config.HideIcon()
        return SideButton(vm: SideButtonVM(config: config, action: {}, enableConfigure: false, isConfigureView: false))
    }
}

struct SideButton_Timer_MainButton_Icon: PreviewProvider {
    static var previews: some View {
        let config = ButtonService.shared.config.mainButton
        config.ShowIcon()
        return SideButton(vm: SideButtonVM(config: config, action: {}, enableConfigure: false, isConfigureView: false))
    }
}

struct SideButton_Configure: PreviewProvider {
    static var previews: some View {
        let config = ButtonService.shared.config.leftButton
        return SideButton(vm: SideButtonVM(config: config, action: {}, enableConfigure: true, isConfigureView: true))
    }
}

struct SideButton_MainButton_Configure_NotSelected: PreviewProvider {
    static var previews: some View {
        let config = ButtonService.shared.config.mainButton
        config.ShowIcon()
        return SideButton(vm: SideButtonVM(config: config, action: {}, enableConfigure: false, isConfigureView: true))
    }
}
