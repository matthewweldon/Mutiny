//
//  SettingsViewModel.swift
//  Mutiny
//
//  Created by Matthew Weldon on 2021-07-19.
//

import Foundation

class SettingsViewModel: ObservableObject {
    @Published var enableSounds: Bool = Preferences.enableSounds{
        didSet {
            Preferences.enableSounds = enableSounds
        }
    }

    @Published var enableToast: Bool = Preferences.enableToast{
        didSet {
            Preferences.enableToast = enableToast
        }
    }
    
    @Published var redMuteIcon: Bool = Preferences.redMuteIcon{
        didSet {
            Preferences.redMuteIcon = redMuteIcon
        }
    }

}
