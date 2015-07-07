//
//  TiledImageView.swift
//  ImageTiling
//
//  Created by Andrew Theken on 7/5/15.
//  Copyright (c) 2015 attrio. All rights reserved.
//

import Cocoa

@IBDesignable class TiledImageView: NSView {

    @IBInspectable var image:NSImage?
    @IBInspectable var rowCount:Int = 5
    @IBInspectable var columnCount:Int = 5

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        if let image = image {
            for r in 0..<rowCount {
                for c in 0..<columnCount {
                    image.drawInRect(frameForImageAt(c, logicalY: r))
                }
            }
        }
    }

    override var flipped:Bool {
        return true
    }

    func frameForImageAt(logicalX:Int, logicalY:Int) -> CGRect{
        let spacing = 10
        let width = 100
        let height = 100
        let x = (spacing + width) * logicalX
        let y = (spacing + height) * logicalY
        return CGRect(x: x, y: y, width: width, height: height)
    }

    override var intrinsicContentSize:CGSize {
        let max = frameForImageAt(columnCount-1, logicalY: rowCount-1)
        return CGSize(width: max.maxX, height: max.maxY)
    }

}
