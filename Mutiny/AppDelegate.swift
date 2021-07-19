//
//  AppDelegate.swift
//  Muda
//
//  Created by Matthew Weldon on 2021-07-18.
//
//

import AppKit
import KeyboardShortcuts

//@NSApplicationMain

class AppDelegate: NSObject, NSApplicationDelegate{
    
    var statusBarController: StatusBarController?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusBarController = StatusBarController.init()

        KeyboardShortcuts.onKeyUp(for: .toggleInputMute) { [self] in
            // The user pressed the keyboard shortcut for “unicorn mode”!
            self.statusBarController?.toggleInputMute()
        }
        if let window = NSApplication.shared.windows.first {
            window.close()
        }
    }
}
