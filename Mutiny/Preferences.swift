//
//  Preferences.swift
//  Mutiny
//
//  Created by Matthew Weldon on 2021-07-19.
//

import Foundation
enum Preferences {

    static var enableSounds: Bool {
        get {
            return UserDefaults.standard.bool(forKey: UserDefaults.Key.enableSounds)
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.Key.enableSounds)
//            NotificationCenter.default.post(Notification(name: .prefsChanged))
        }
    }
    static var enableToast: Bool {
        get {
            return UserDefaults.standard.bool(forKey: UserDefaults.Key.enableToast)
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.Key.enableToast)
//            NotificationCenter.default.post(Notification(name: .prefsChanged))
        }
    }
    
    static var redMuteIcon: Bool {
        get {
            return UserDefaults.standard.bool(forKey: UserDefaults.Key.redMuteIcon)
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.Key.redMuteIcon)
            NotificationCenter.default.post(Notification(name: .prefsChanged))
        }
    }

}
