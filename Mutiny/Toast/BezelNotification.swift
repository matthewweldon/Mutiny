//
//  BezelNotification.swift
//  Muda
//
//  Created by Matthew Weldon on 2021-07-19.
//

import Cocoa
import SwiftUI

/// A utility class for displaying Xcode-like notifications, aka bezel notifications.
/// It currently only supports displaying a given text that will be centered on screen, will remain on screen for 3 seconds,
/// then fade out.
public class BezelNotification {
    
    let window: NSWindow
    let visibleTime: TimeInterval
    var toast = NSHostingView.init(rootView: Toast.init(muted: false))
    /// Create a BezelNotification with the given text. It is not displayed until `show()` or `runModal()` is called.
    /// The text is displayed with regular weight and a font size of 18, on a single line.
    init(view: NSHostingView<Toast>,
                visibleTime: TimeInterval = 2.0,muted:Bool=true) {
        self.toast = view
        
        self.window = NSWindow(contentRect: NSRect(origin: .zero, size: CGSize(width: 100, height: 500)),
                               styleMask: .borderless, backing: .buffered, defer: true)
        self.visibleTime = visibleTime
        buildUI()
    }
    
    class NotificationSession {
        var cancelled = false
        let modal: Bool
        
        init(modal: Bool) {
            self.modal = modal
        }
    }
    
    var previousShowSession: NotificationSession?
    
    /// Show the notification then return. After 3 seconds, the notification will fade out.
    public func show() {
        fadeOutTimer?.invalidate()
        fadeOutTimer = nil
        previousShowSession?.cancelled = true
        
        let newSession = NotificationSession(modal: false)
        self.previousShowSession = newSession
        fadeIn(session: newSession)
        window.makeKeyAndOrderFront(nil)
        window.center()
    }
    
    /// Show the notification, wait 3 seconds and fade out. Does not return until the fade out is over.
    public func runModal() {
        fadeIn(session: NotificationSession(modal: true))
        NSApp.runModal(for: window)
    }
    
    func buildUI() {
        window.hasShadow = false
        window.level = .modalPanel
        window.backgroundColor = .clear
        window.alphaValue = 0
        
        let contentView = NSView(frame: self.window.frame)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.wantsLayer = true
        contentView.layer!.masksToBounds = true
        contentView.layer!.cornerRadius = 10.0
        
        self.window.contentView = contentView
        let visualEffectView = NSVisualEffectView(frame: self.window.frame)
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        visualEffectView.material = .hudWindow
        visualEffectView.state = .active
        contentView.addSubview(visualEffectView)
        NSLayoutConstraint.activate([
            visualEffectView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            visualEffectView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            visualEffectView.topAnchor.constraint(equalTo: contentView.topAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        
        toast.translatesAutoresizingMaskIntoConstraints = false
        toast.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        toast.setContentHuggingPriority(.defaultHigh, for: .vertical)
        toast.setContentCompressionResistancePriority(.required, for: .vertical)
        toast.setContentCompressionResistancePriority(.required, for: .horizontal)
        visualEffectView.addSubview(toast)

        NSLayoutConstraint.activate([
            toast.leadingAnchor.constraint(equalTo: visualEffectView.leadingAnchor, constant: 10),
            toast.trailingAnchor.constraint(equalTo: visualEffectView.trailingAnchor, constant: -10),
            toast.topAnchor.constraint(equalTo: visualEffectView.topAnchor, constant: 10),
            toast.bottomAnchor.constraint(equalTo: visualEffectView.bottomAnchor, constant: -10)
        ])
        
    }
    
    var fadeOutTimer: Timer?
    func fadeIn(session: NotificationSession) {
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.1
            window.animator().alphaValue = 1.0
        }, completionHandler: {
            guard !session.cancelled else { return }
            let timer = Timer(timeInterval: self.visibleTime, repeats: false) { _ in
                self.fadeOut(session: session)
            }
            
            // For modal run loop
            RunLoop.current.add(timer, forMode: .common)
            self.fadeOutTimer = timer
        })
    }
    
    func fadeOut(session: NotificationSession) {
        window.alphaValue = 1.0
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.5
            window.animator().alphaValue = 0.0
        }, completionHandler: {
            if session.modal {
                NSApp.stopModal()
            }
        })
    }
}
