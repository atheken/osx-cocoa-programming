//
//  NSString+Drawing.swift
//  Dice
//
//  Created by Andrew Theken on 7/7/15.
//  Copyright (c) 2015 attrio. All rights reserved.
//

import Cocoa

extension NSString {
    func drawCenteredInRect(rect:NSRect, attributes:[NSString:AnyObject]!){
        let stringSize = sizeWithAttributes(attributes)
        let point = NSPoint(x: rect.origin.x + (rect.width - stringSize.width)/2.0, y: rect.origin.y + (rect.height - stringSize.height)/2.0)

        drawAtPoint(point, withAttributes: attributes)
    }
}