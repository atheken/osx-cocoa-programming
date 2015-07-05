//
//  AppDelegate.swift
//  Dice
//
//  Created by Andrew Theken on 7/5/15.
//  Copyright (c) 2015 attrio. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    private var mainWindowContoller:MainWindowController?

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        var controller = MainWindowController()
        controller.showWindow(self)
        self.mainWindowContoller = controller
    }


}

