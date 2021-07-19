//
//  UserDefaults+Extension.swift
//  Muda
//
//  Created by Matthew Weldon on 2021-07-18.
//

import Foundation
extension UserDefaults {
    enum Key {
        static let enableSounds = "enableSounds"
        static let enableToast = "enableToast"
        static let redMuteIcon = "redMuteIcon"


    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print("hi!")
    }
}
