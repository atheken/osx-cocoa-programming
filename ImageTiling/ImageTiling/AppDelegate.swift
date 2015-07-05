//
//  AppDelegate.swift
//  ImageTiling
//
//  Created by Andrew Theken on 7/5/15.
//  Copyright (c) 2015 attrio. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    private var mainWindowController:MainWindowController?

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        let controller = MainWindowController()
        controller.showWindow(self)
        self.mainWindowController = controller
    }

}

