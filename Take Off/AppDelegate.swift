//
//  AppDelegate.swift
//  Take Off
//
//  Created by MyMac on 8/9/20.
//  Copyright © 2020 White Paladin Games. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!
    
    var r = [TakeOffAppInfo]()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let ff = FileFunctions();
        r = ff.getFiles(path: "/Applications/", first: true)
        r.append(contentsOf: ff.getFiles(path: "/System/Applications/", first: true))
        let r1 = r.sorted{
            ($0.lowerName, $0.lowerName) <
            ($1.lowerName, $1.lowerName)
        }
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView(originalList: r1, appInfoArray: r1)

        // Create the window and set the content view. 
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        NSApp.terminate(self)
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}

