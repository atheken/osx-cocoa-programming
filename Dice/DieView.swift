//
//  DiceView.swift
//  Dice
//
//  Created by Andrew Theken on 7/5/15.
//  Copyright (c) 2015 attrio. All rights reserved.
//

import Cocoa

class DieView:NSView {

    override func drawRect(dirtyRect: NSRect) {
        let backgroundColor = NSColor.lightGrayColor()
        backgroundColor.set()
        NSBezierPath.fillRect(bounds)

        drawWithSize(bounds.size)
    }

    func metricsForSize(size: CGSize) -> (edgeLength:CGFloat, dieFrame:CGRect) {

        let edgeLength = min(size.height, size.width)
        let padding = edgeLength/10.0
        let drawingBounds = CGRect(x: 0, y: 0, width: edgeLength, height: edgeLength)

        let dieFrame = drawingBounds.rectByInsetting(dx: padding, dy: padding)

        return (edgeLength, dieFrame)
    }

    override var intrinsicContentSize:NSSize {
        return NSSize(width: 20.0, height: 20.0)
    }

    func drawWithSize(size: CGSize){
        if let intValue = intValue {
            let (edgeLength, dieFrame) = metricsForSize(size)
            let cornerRadius = edgeLength/5.0

            let dotRadius = edgeLength/12.0
            let dotFrame = dieFrame.rectByInsetting(dx: dotRadius * 2.5, dy: dotRadius * 2.5)

            NSColor.whiteColor().set()

            NSGraphicsContext.saveGraphicsState()

            let shadow = NSShadow()
            shadow.shadowOffset = NSSize(width: 0, height: -1)
            shadow.shadowBlurRadius = edgeLength/20.0
            shadow.set()

            NSBezierPath(roundedRect: dieFrame, xRadius: cornerRadius, yRadius: cornerRadius).fill()

            NSGraphicsContext.restoreGraphicsState()

            NSColor.blackColor().set()

            func drawDot(u: CGFloat, v: CGFloat){
                let dotOrigin = CGPoint(x: dotFrame.minX + dotFrame.width * u, y: dotFrame.minY + dotFrame.height * v)
                let dotRect = CGRect(origin: dotOrigin, size: CGSizeZero).rectByInsetting(dx: -dotRadius, dy: -dotRadius)
                NSBezierPath(ovalInRect: dotRect).fill()
            }

            if find(1...6, intValue) != nil {
                if find([1,3,5], intValue) != nil {
                    drawDot(0.5, 0.5)
                }
                if find(2...6, intValue) != nil {
                    drawDot(0,1)
                    drawDot(1,0)
                }
                if find(4...6, intValue) != nil {
                    drawDot(1,1)
                    drawDot(0,0)
                }
                if intValue == 6 {
                    drawDot(0, 0.5)
                    drawDot(1, 0.5)
                }
            }

        }
    }

    var intValue: Int? = 1 {
        didSet {
            needsDisplay = true
        }
    }

}
