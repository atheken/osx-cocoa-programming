//
//  DiceView.swift
//  Dice
//
//  Created by Andrew Theken on 7/5/15.
//  Copyright (c) 2015 attrio. All rights reserved.
//

import Cocoa

class DieView:NSView, NSDraggingSource {

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func commonInit(){
        self.registerForDraggedTypes([NSPasteboardTypeString])
    }

    override func drawRect(dirtyRect: NSRect) {
        let backgroundColor = NSColor.lightGrayColor()
        backgroundColor.set()
        NSBezierPath.fillRect(bounds)

        //drawWithSize(bounds.size)
        if highlightForDragging {
            let gradient = NSGradient(startingColor: NSColor.whiteColor(), endingColor: backgroundColor)
            gradient.drawInRect(bounds, relativeCenterPosition:NSZeroPoint)
        }
        else {
            drawWithSize(bounds.size)
        }
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
            else{
                var paraStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle

                paraStyle.alignment = .CenterTextAlignment
                let font = NSFont.systemFontOfSize(edgeLength * 0.5)
                let attrs = [NSForegroundColorAttributeName: NSColor.blackColor(),
                    NSFontAttributeName: font,
                    NSParagraphStyleAttributeName : paraStyle]

                let string = "\(intValue)" as NSString
                string.drawCenteredInRect(dieFrame, attributes: attrs)
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
        mouseDownEvent = theEvent
        let dieFrame = metricsForSize(bounds.size).dieFrame
        let pointInView = convertPoint(theEvent.locationInWindow, fromView: nil)
        pressed = outlineForFrame(dieFrame).path.containsPoint(pointInView)
    }

    override func mouseDragged(theEvent: NSEvent) {
        let downPoint = mouseDownEvent!.locationInWindow
        let dragPoint = theEvent.locationInWindow
        let distanceDragged = hypot(downPoint.x - dragPoint.x, downPoint.y - dragPoint.y)
        if distanceDragged < 3 {
            return
        }
        pressed = false
        if let intValue = intValue {
            let imageSize = bounds.size
            let image = NSImage(size: imageSize, flipped:false){ i in
                self.drawWithSize(i.size)
                return true
            }

            let draggingFrameOrigin = convertPoint(downPoint, fromView: nil)
            let draggingFrame = NSRect(origin: draggingFrameOrigin, size: imageSize).rectByOffsetting(dx: -imageSize.width/2, dy: -imageSize.height/2)

            let item = NSDraggingItem(pasteboardWriter: "\(intValue)")
            item.draggingFrame = draggingFrame
            item.imageComponentsProvider = {
                let component = NSDraggingImageComponent(key: NSDraggingImageComponentIconKey)
                component.contents = image
                component.frame = NSRect(origin: NSPoint(), size: imageSize)
                return [component]
            }
            beginDraggingSessionWithItems([item], event: mouseDownEvent!, source: self)
        }
    }

    override func mouseUp(theEvent: NSEvent) {
        if theEvent.clickCount == 2 {
            roll()
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

    //MARK: exporting...

    @IBAction func savePDF(sender:AnyObject!){
        let savePanel = NSSavePanel()
        savePanel.allowedFileTypes = ["pdf"]
        savePanel.beginSheetModalForWindow(window!){
            [unowned savePanel] (result) in
            if result == NSModalResponseOK {
                let data = self.dataWithPDFInsideRect(self.bounds)
                var error:NSError?
                let ok = data.writeToURL(savePanel.URL!, options: NSDataWritingOptions.AtomicWrite, error:&error)
                if !ok {
                    let alert = NSAlert(error:error!)
                    alert.runModal()
                }
            }
        }
    }

    //MARK: - Pasteboard

    func writeToPasteboard(pasteboard:NSPasteboard){
        if let intValue = intValue {
            pasteboard.clearContents()
            pasteboard.writeObjects(["\(intValue)"])
        }
    }

    func readFromPasteboard(pasteboard:NSPasteboard) -> Bool {
        let objects = pasteboard.readObjectsForClasses([NSString.self], options: [:]) as! [String]
        if let str = objects.first {
            intValue = str.toInt()
            return true
        }
        return false
    }

    @IBAction func cut(sender:AnyObject?){
        writeToPasteboard(NSPasteboard.generalPasteboard())
        intValue = nil
    }

    @IBAction func copy(sender:AnyObject?) {
        writeToPasteboard(NSPasteboard.generalPasteboard())
    }

    @IBAction func paste(sender:AnyObject?){
        readFromPasteboard(NSPasteboard.generalPasteboard())
    }

    override func validateMenuItem(menuItem: NSMenuItem) -> Bool {
        switch menuItem.action {
        case Selector("copy:"):
            return intValue == nil
        default:
            return super.validateMenuItem(menuItem)
        }
    }

    //MARK: Dragging Source

    func draggingSession(session: NSDraggingSession, sourceOperationMaskForDraggingContext context: NSDraggingContext) -> NSDragOperation {
        return .Copy | .Delete
    }

    func draggingSession(session: NSDraggingSession, endedAtPoint screenPoint: NSPoint, operation: NSDragOperation) {
        if operation == .Delete {
            intValue = nil
        }
    }

    var mouseDownEvent:NSEvent?

    var highlightForDragging: Bool = false {
        didSet {
            needsDisplay = true
        }
    }

    //MARK: - Drag Destination
    override func draggingEntered(sender: NSDraggingInfo) -> NSDragOperation {
        if sender.draggingSource() === self {
            return .None
        }
        else{
            highlightForDragging = true
            return sender.draggingSourceOperationMask()
        }
    }

    override func draggingExited(sender: NSDraggingInfo?) {
        highlightForDragging = false
    }

    override func prepareForDragOperation(sender: NSDraggingInfo) -> Bool {
        return true
    }

    override func performDragOperation(sender: NSDraggingInfo) -> Bool {
        let ok = readFromPasteboard(sender.draggingPasteboard())
        return ok
    }

    override func concludeDragOperation(sender: NSDraggingInfo?) {
        highlightForDragging = false
    }

    //MARK - Timers!

    var rollsRemaining: Int = 0
    func roll(){
        rollsRemaining = 10
        NSTimer.scheduledTimerWithTimeInterval(0.15, target: self, selector: Selector("rollTick:"), userInfo: nil, repeats: true)
        window?.makeFirstResponder(nil)
    }

    func rollTick(sender:NSTimer){
        let lastIntValue = intValue
        while intValue == lastIntValue{
            randomize()
        }
        rollsRemaining--
        if rollsRemaining == 0 {
            sender.invalidate()
        }
        window?.makeFirstResponder(self)
    }
}
