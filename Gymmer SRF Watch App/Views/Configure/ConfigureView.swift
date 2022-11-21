//
//  ConfigureView.swift
//  Gymmer SRF WatchKit Extension
//
//  Created by Mohammed Shereif on 15/10/22.
//

import SwiftUI
//import Combine

class ConfigureViewVM: ObservableObject {
    @Published private(set) var toggler = false
    @Published var duration: Int
    @Published var showAlert: Bool
    @Published var configuration: ButtonListModel
    
//    private var subscriptions = Set<AnyCancellable>()
    
    private(set) var selectedButton: ButtonTypeEnum?
    let previousButtonsValue: ButtonValuesModel
    
    init() {
        let configuration = ButtonService.shared.config
        
        self.configuration = configuration
        showAlert = false
        duration = 60
        previousButtonsValue = ButtonValuesModel(main: configuration.GetDuration(buttonType: .main), left: configuration.GetDuration(buttonType: .left), right: configuration.GetDuration(buttonType: .right))
    }
    
    
    func ChangeDuration(_ duration: Int) {
        guard let type = selectedButton else { return }
        
        ButtonService.shared.ChangeButtonValue(type: type, value: duration)
        
        toggler.toggle()
    }
    
    func ButtonAction(_ type: ButtonTypeEnum) {
        if selectedButton != type {
            duration = configuration.GetDuration(buttonType: type)
            selectedButton = type
        }
        else {
            selectedButton = nil
        }
        
        toggler.toggle()
    }
    
    func ResetAction() {
        let changeValue = ButtonService.shared.ChangeButtonValue
        
        changeValue(.main, previousButtonsValue.mainButtonValue)
        changeValue(.left, previousButtonsValue.leftButtonValue)
        changeValue(.right, previousButtonsValue.rightButtonValue)
        
        duration = configuration.GetDuration(buttonType: selectedButton ?? .main)
        selectedButton = nil
        toggler.toggle()
    }
    
    func DefaultAction() {
        let constants = Constants.shared.ButtonValue
        let changeValue = ButtonService.shared.ChangeButtonValue
        
        changeValue(.main, constants.mainButtonValue)
        changeValue(.left, constants.leftButtonValue)
        changeValue(.right, constants.rightButtonValue)
        
        duration = configuration.GetDuration(buttonType: selectedButton ?? .main)
        selectedButton = nil
        toggler.toggle()
    }
}

struct ConfigureView: View {
    @StateObject var vm = ConfigureViewVM()
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: 20)
            
            topContent
            
            ButtonsView(config: vm.configuration,
                        mainButtonAction: {vm.ButtonAction(.main)},
                        leftButtonAction: {vm.ButtonAction(.left)},
                        rightButtonAction: {vm.ButtonAction(.right)},
                        selectedButton: vm.selectedButton,
                        isConfigureView: true
            )
            .padding(.bottom, 5)
        }
        .onChange(of: vm.duration, perform: vm.ChangeDuration)
        .alert(isPresented: $vm.showAlert) {
            alertContent
        }
        .ignoresSafeArea()
    }
}

extension ConfigureView {
    private var topContent: some View {
        HStack(alignment: .bottom) {
            sideButtonView(icon: "gobackward", text: "reset", action: vm.ResetAction)
            
            Picker("", selection: $vm.duration){
                ForEach(0...300, id: \.self) {
                    i in Text("\(i)").tag(i)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(maxWidth: .infinity)
            
            sideButtonView(icon: "folder", text: "default", action: {vm.showAlert.toggle()})
        }
    }
    
    private var alertContent: Alert {
        Alert(
            title: Text("Reset to default?"),
            message: Text(""),
            primaryButton: .destructive(Text("Yes"), action: vm.DefaultAction),
            secondaryButton: .cancel()
        )
    }
}

private struct sideButtonView: View {
    var icon = ""
    var text = ""
    var action: () -> () = {}
    
    var body: some View {
        VStack{
            Button(action: action) {
                Image(systemName: icon)
                    .font(.body.bold())
            }
            .tint(.red)
            
            
            Text(text)
                .font(.system(size: 10))
        }
        .frame(width: 40)
    }
}

struct ConfigureView_Previews: PreviewProvider {
    static var previews: some View {
        return ConfigureView()
    }
}
