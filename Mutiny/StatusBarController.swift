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
import AudioToolbox

class StatusBarController {
    private let statusBar = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private let imgIconUnmuted = NSImage(named:NSImage.Name("mic-fill-white"))
    private var imgIconMuted = Preferences.redMuteIcon ? NSImage(named:NSImage.Name("mic-mute-fill-red")) : NSImage(named:NSImage.Name("mic-mute-fill"))
    private var isMuted = false
    private var lastKnownNonZeroInputVolume:Float32 = 0.0 //start at zero before measuring
    private var defaultInputDeviceName:String { return NSSound.getDefaultInputDeviceName() }
    init() {
        if let button = statusBar.button {
            button.image = self.imgIconUnmuted
            button.target = self
            button.action = #selector(handleIconClicked(_:))
            button.sendAction(on: [.leftMouseDown, .rightMouseDown])
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateIcons), name: .prefsChanged, object: nil)

        
        lastKnownNonZeroInputVolume = NSSound.systemInputVolume
        
        if(lastKnownNonZeroInputVolume == 0.0){
            self.isMuted = true
            lastKnownNonZeroInputVolume = 1.0
            statusBar.button?.image = imgIconMuted
        }
    }
    
    @objc func updateIcons(){
        
        imgIconMuted = Preferences.redMuteIcon ? NSImage(named:NSImage.Name("mic-mute-fill-red")) : NSImage(named:NSImage.Name("mic-mute-fill"))
        syncronizeInputVolumeState()
        
    }
//    @objc func setInputVolume(val:Float32){
//        NSSound.systemInputVolume = val
//    }
//    @objc func setInputVolume1(){
//        NSSound.systemInputVolume = 1
//    }
    func getContextMenu()->NSMenu{
        let menu = NSMenu()
        
        let name = defaultInputDeviceName
        if (name != "" ){
            let nameItem = NSMenuItem.init(title: defaultInputDeviceName, action: nil, keyEquivalent: "")
            nameItem.isEnabled = false
            menu.addItem(nameItem)
            menu.addItem(NSMenuItem.separator())
        }
//        let inputVolumeMenuItem = NSMenuItem.init(title: "Set Output Level", action: nil, keyEquivalent: "")
//        let inputVolumeMenu = NSMenu.init(title: "Set Output Level")
//        for i in 5...10{
//            let level = i * 10
//            let levelActual:Float32 = Float32.init(i)/10
//            let menuItem = NSMenuItem(title: "\(level)", action: #selector(setInputVolume1), keyEquivalent: "")
//
//            inputVolumeMenu.addItem(menuItem)
//        }
//        menu.addItem(inputVolumeMenuItem)
//        menu.setSubmenu(inputVolumeMenu, for: inputVolumeMenuItem)
//        

        
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

        NSApp.activate(ignoringOtherApps: true)

        NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
        
    }
    
    func toggleInputMute() {
        isMuted.toggle()

        if(isMuted != true ){
            let bezel = BezelNotification.init(view: NSHostingView.init(rootView: Toast.init(muted: false)), visibleTime: 1.0 )
            
            NSSound.systemInputVolume = lastKnownNonZeroInputVolume
            statusBar.button?.image = imgIconUnmuted
            if(Preferences.enableToast){
                bezel.show()
            }

        }else{
            let bezel = BezelNotification.init(view: NSHostingView.init(rootView: Toast.init(muted: true)), visibleTime: 1.0)
            NSSound.systemInputVolume = 0.0
            statusBar.button?.image = imgIconMuted
            if(Preferences.enableToast){
                bezel.show()
            }
            
        }
        if(Preferences.enableSounds){
            playSound(isMuted)
        }
    }
    
    

    // Creating the sequence
    func playSound(_ muted:Bool){
        var sequence : MusicSequence? = nil
        _ = NewMusicSequence(&sequence)
            

            var track : MusicTrack? = nil
            if(sequence == nil ){return}
            var musicTrack = MusicSequenceNewTrack(sequence!, &track)

            // Adding notes
            var time = MusicTimeStamp(1.0)
            for index:UInt8 in 0...2 { // C4 to C5
                let noteVal = muted ? (64-index*2) : (60 + index*2)
                var note = MIDINoteMessage(channel: 0,
                                           note: noteVal,
                                           velocity: 64,
                                           releaseVelocity: 64,
                                           duration: 0.1 )
                musicTrack = MusicTrackNewMIDINoteEvent(track!, time, &note)
                time += 0.1
            }

            
            if(track == nil ){return}
            var inMessage = MIDIChannelMessage(status: 0xE0, data1: 120, data2: 0, reserved: 0)
            MusicTrackNewMIDIChannelEvent(track!, 0, &inMessage)
            // set msb to 120 and lsb to 0
            inMessage = MIDIChannelMessage(status: 0xC0, data1: 4, data2: 0, reserved: 0)
            if(track == nil ){return}
            MusicTrackNewMIDIChannelEvent(track!, 0, &inMessage)
            if(track == nil ){return}
            MusicTrackNewMIDIChannelEvent(track!, 0, &inMessage)

            // Creating a player

            var musicPlayer : MusicPlayer? = nil
            var player = NewMusicPlayer(&musicPlayer)
        
            if(musicPlayer == nil ){return}
            player = MusicPlayerSetSequence(musicPlayer!, sequence)
            player = MusicPlayerStart(musicPlayer!)
            
    }
}
