//
//  PreferencesView.swift
//  Muda
//
//  Created by Matthew Weldon on 2021-07-19.
//

import SwiftUI
import KeyboardShortcuts

struct SettingsView: View {
    @ObservedObject var viewModel = SettingsViewModel()

    

    var body: some View {
        VStack(alignment: .leading){
            HStack(alignment: .firstTextBaseline) {
                Text("Toggle Mute Shortcut")
                KeyboardShortcuts.Recorder(for: .toggleInputMute)
            }.padding()
            HStack(alignment: .firstTextBaseline){
                Toggle("Enable Sound", isOn: $viewModel.enableSounds)
                    .toggleStyle(SwitchToggleStyle())

            }.padding()
            HStack(alignment: .firstTextBaseline){
                Toggle("Enable Overlay Notification", isOn: $viewModel.enableToast)
                    .toggleStyle(SwitchToggleStyle())
            }.padding()
            HStack(alignment: .firstTextBaseline){
                Toggle("Red Mute Icon", isOn: $viewModel.redMuteIcon)
                    .toggleStyle(SwitchToggleStyle())

            }.padding()


        }.padding()
        
        

    }
}
