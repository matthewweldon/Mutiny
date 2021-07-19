//
//  MutinyApp.swift
//  Mutiny
//
//  Created by Matthew Weldon on 2021-07-19.
//

import SwiftUI

@main
struct MutinyApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            SettingsView()
        }
        Settings {
            SettingsView()
        }
    }
}
