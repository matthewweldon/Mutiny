//
//  PreferencesView.swift
//  Muda
//
//  Created by Matthew Weldon on 2021-07-19.
//

import SwiftUI
import KeyboardShortcuts

struct SettingsView: View {
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text("Toggle Mute")
            KeyboardShortcuts.Recorder(for: .toggleInputMute)
        }.padding()

    }
}
