//
//  StatusBarController.swift
//  Muda
//
//  Created by Matthew Weldon on 2021-07-18.
//

import Foundation
import AppKit
import SwiftUI
import Cocoa

class StatusBarController {
    private let statusBar = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private let imgIconUnmuted = NSImage(named:NSImage.Name("mic-fill-white"))
    private let imgIconMuted = NSImage(named:NSImage.Name("mic-mute-fill-red"))
    private var isMuted = false
    private var lastKnownNonZeroInputVolume:Float32 = 0.0 //start at zero before measuring
   
    init() {
        if let button = statusBar.button {
            button.image = self.imgIconUnmuted
            button.target = self
            button.action = #selector(handleIconClicked(_:))
            button.sendAction(on: [.leftMouseDown, .rightMouseDown])
        }
//        NSUserNotificationCenter.default.addObserver(self,
//                                                     forKeyPath: <#T##String#>,
//                                                     options: <#T##NSKeyValueObservingOptions#>,
//                                                     context: T##UnsafeMutableRawPointer?)
        lastKnownNonZeroInputVolume = NSSound.systemInputVolume
        
        if(lastKnownNonZeroInputVolume == 0.0){
            self.isMuted = true
            lastKnownNonZeroInputVolume = 1.0
            statusBar.button?.image = imgIconMuted
        }
    }
    
    
    func getContextMenu()->NSMenu{
        let menu = NSMenu()
        
        let prefItem = NSMenuItem(title: "Preferences...".localized, action: #selector(showPreferencesView), keyEquivalent: "P")
        prefItem.target = self
        menu.addItem(prefItem)
    
        
        
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit".localized, action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        return menu
    }

    
    
    @objc func handleIconClicked(_ sender: AnyObject?) {
       
        guard let currentEvent = NSApp.currentEvent else {
            return
        }

        switch currentEvent.type {
        case .leftMouseDown:
            toggleInputMute()
        case .rightMouseDown:
            statusBar.popUpMenu(self.getContextMenu())
        default:
            break
        }

    }
    
    func syncronizeInputVolumeState(){
        let currentInputVolume = NSSound.systemInputVolume
        if(currentInputVolume != 0.0 ){
            self.isMuted = false
            statusBar.button?.image = imgIconUnmuted
            lastKnownNonZeroInputVolume = currentInputVolume
        }else{
            self.isMuted = true
            statusBar.button?.image = imgIconMuted
        }
    }
    
    @objc func showPreferencesView(){
//        var windowRef:NSWindow
//        windowRef = NSWindow(
//            contentRect: NSRect(x: 100, y: 100, width: 100, height: 600),
//            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
//            backing: .buffered, defer: false)
//        windowRef.contentView = NSHostingView(rootView: PreferencesView())
//        windowRef.makeKeyAndOrderFront(nil)
//
        NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)

    }
    
    func toggleInputMute() {
        var targetVolume:Float32 = 0.0
        let bezel = BezelNotification.init(text: "", visibleTime: 1.0)
        if(isMuted){
            NSSound.systemInputVolume = lastKnownNonZeroInputVolume
            statusBar.button?.image = imgIconUnmuted
            bezel.text = "Mic Unmuted!"
            bezel.show()

        }else{
            NSSound.systemInputVolume = 0.0
            statusBar.button?.image = imgIconMuted
            bezel.text = "Mic Muted!"
            bezel.show()
        }
        isMuted.toggle()
    }
}
