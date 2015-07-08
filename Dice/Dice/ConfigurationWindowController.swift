//
//  ConfigurationWindowController.swift
//  Dice
//
//  Created by Andrew Theken on 7/8/15.
//  Copyright (c) 2015 attrio. All rights reserved.
//

import Cocoa

class ConfigurationWindowController: NSWindowController {

    private dynamic var color:NSColor = NSColor.whiteColor()
    private dynamic var rolls:Int = 10

    var configuration:DieConfiguration {
        set {
            color = newValue.color
            rolls = newValue.rolls
        }
        get {
            return DieConfiguration(color: color, rolls: rolls)
        }
    }

    override var windowNibName:String {
        return "ConfigurationWindowController"
    }

    @IBAction func okayButtonClicked(button:NSButton){
        window?.endEditingFor(nil)
        self.dismissWithModalResponse(NSModalResponseOK)
    }

    @IBAction func cancelButtonClicked(button:NSButton){
        self.dismissWithModalResponse(NSModalResponseCancel)
    }

    func dismissWithModalResponse(response:NSModalResponse){
        window?.sheetParent?.endSheet(window!, returnCode: response)
    }
}

struct DieConfiguration {
    let color:NSColor
    let rolls:Int
    init(color:NSColor, rolls:Int){
        self.color = color
        self.rolls = max(rolls,1)
    }
}