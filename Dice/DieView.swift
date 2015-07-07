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

        var dieFrame = drawingBounds.rectByInsetting(dx: padding, dy: padding)

        if pressed {
            dieFrame = drawingBounds.rectByOffsetting(dx: 0, dy: -edgeLength/40.0)
        }

        return (edgeLength, dieFrame)
    }

    override var intrinsicContentSize:NSSize {
        return NSSize(width: 20.0, height: 20.0)
    }

    func outlineForFrame(frame:CGRect) -> (radius:CGFloat, path:NSBezierPath){
        let radius = frame.width/5.0
        let path = NSBezierPath(roundedRect: frame, xRadius: radius, yRadius: radius)
        return (radius, path)
    }

    func drawWithSize(size: CGSize){
        if let intValue = intValue {
            let (edgeLength, dieFrame) = metricsForSize(size)

            let dotRadius = edgeLength/12.0
            let dotFrame = dieFrame.rectByInsetting(dx: dotRadius * 2.5, dy: dotRadius * 2.5)

            NSColor.whiteColor().set()

            NSGraphicsContext.saveGraphicsState()

            let shadow = NSShadow()
            shadow.shadowOffset = NSSize(width: 0, height: -1)
            shadow.shadowBlurRadius = pressed ? edgeLength/100.0 : edgeLength/20.0
            shadow.set()

            outlineForFrame(dieFrame).path.fill()

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

    var pressed = false {
        didSet {
            needsDisplay = true
        }
    }

    func randomize(){
        intValue = Int(arc4random_uniform(5)) + 1
    }

    // MARK: - Mouse Events

    override func mouseDown(theEvent:NSEvent){
        let dieFrame = metricsForSize(bounds.size).dieFrame
        let pointInView = convertPoint(theEvent.locationInWindow, fromView: nil)
        pressed = outlineForFrame(dieFrame).path.containsPoint(pointInView)
    }

    override func mouseDragged(theEvent: NSEvent) {
        println("mouseDragged location: \(theEvent.locationInWindow)")
    }

    override func mouseUp(theEvent: NSEvent) {
        if theEvent.clickCount == 2 {
            randomize()

        }
        pressed = false
    }

    //MARK: First Responder

    override var acceptsFirstResponder:Bool {
        return true
    }

    override func becomeFirstResponder() -> Bool {
        return true
    }

    override func resignFirstResponder() -> Bool {
        return true
    }

    override func keyDown(theEvent: NSEvent) {
        interpretKeyEvents([theEvent])
    }

    override func insertText(insertString: AnyObject) {
        let text = insertString as! String

        if let number = text.toInt() {
            intValue = number
        }
    }

    override func drawFocusRingMask() {
        NSBezierPath.fillRect(self.bounds)
    }

    override var focusRingMaskBounds:NSRect {
        return self.bounds
    }

    override func insertBacktab(sender: AnyObject?) {
        window?.selectPreviousKeyView(sender)
    }

    override func insertTab(sender: AnyObject?) {
        window?.selectNextKeyView(sender)
    }
}
