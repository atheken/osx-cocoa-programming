//
//  MainWindowController.swift
//  Dice
//
//  Created by Andrew Theken on 7/5/15.
//  Copyright (c) 2015 attrio. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    }


    override var windowNibName:String {
        return "MainWindowController"
    }

    private var configurationWindowController:ConfigurationWindowController? = nil

    @IBAction func showDieConfiguration(sender:AnyObject?){
        if let window = window, let dieView = window.firstResponder as? DieView {
            let windowController = ConfigurationWindowController()
            windowController.configuration = DieConfiguration(color: dieView.color, rolls: dieView.numberOfTimesToRoll)

            window.beginSheet(windowController.window!, completionHandler: { response in
                if response == NSModalResponseOK {
                    if let configuration = self.configurationWindowController?.configuration {
                        dieView.color = configuration.color
                        dieView.rollsRemaining = configuration.rolls
                    }
                    self.configurationWindowController = nil
                }

            })
            configurationWindowController = windowController
        }
    }
}
