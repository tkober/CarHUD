//
//  AirspeedScaleView.swift
//  WirelessPFD
//
//  Created by Thorsten Kober on 22/06/16.
//  Copyright © 2016 Thorsten Kober. All rights reserved.
//

import UIKit


@IBDesignable class AirspeedScaleView: UIView {

    
    @IBInspectable var visibleRange: UInt = 50
    
    
    @IBInspectable var scaleSteps: UInt = 5
    
    
    @IBInspectable var stepsPerLabel = 2
    
    
    @IBInspectable var maxSpeed: UInt = 220
    
    
    @IBInspectable var scaleColor: UIColor = UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 0.7)
    
    
    @IBInspectable var labelColor: UIColor = UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 0.7)
    
    
    @IBInspectable var scaleWidth: CGFloat = 2.0
    
    
    @IBInspectable var fontSize: CGFloat = 0.25
    
    
    @IBInspectable var labelMargin: CGFloat = 0
    
    
    @IBInspectable var notchWidth: CGFloat = 35
    
    
    @IBInspectable var areaWidth: CGFloat = 15
    
    
    @IBInspectable var overspeedIndicatorWidth: CGFloat = 10
    
    
    @IBInspectable var speedLimitIndicatorWidth: CGFloat = 5
    

    func setAirspeed(airspeed: UInt) {
        let value = max(0, airspeed)
        self._airspeed = value
    }
    
    private var _airspeed: UInt = 0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var scaleImage: UIImage? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var speedLimit: UInt? {
        didSet {
            self.scaleImage = nil
            self.setNeedsDisplay()
        }
    }
    
    var overspeedTolerance: UInt = 15 {
        didSet {
            self.scaleImage = nil
            self.setNeedsDisplay()
        }
    }
    
    
    
    override func drawRect(rect: CGRect) {
        if let image = self.scaleImage {
            let scale = UIScreen.mainScreen().scale
            
            let width = rect.width * scale
            let height = rect.height * scale
            let steps = height / CGFloat(self.visibleRange)
            let y = image.size.height - height - steps * CGFloat(self._airspeed);
            let sectionFrame = CGRect(x: 0, y: y, width: width, height: height)
            
            let section = CGImageCreateWithImageInRect(image.CGImage, sectionFrame)
            UIImage(CGImage: section!).drawInRect(rect)
        } else {
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.renderScale(rect)
            }
        }
    }
    
    private func renderScale(frame: CGRect) {
        let scale = UIScreen.mainScreen().scale
        
        let frameWidth = frame.width * scale
        let frameHeight = frame.height * scale
        let steps = frameHeight / CGFloat(self.visibleRange)
        
        let imageWidth = frameWidth
        let imageHeight = steps * CGFloat(self.maxSpeed + (self.visibleRange / 2))
        
        UIGraphicsBeginImageContext(CGSize(width: imageWidth, height: imageHeight))
        let context = UIGraphicsGetCurrentContext()
        
        // Scale
        CGContextSetLineWidth(context, self.scaleWidth * scale)
        CGContextSetStrokeColorWithColor(context, self.scaleColor.CGColor)
        
        var value: UInt = 0
        var i = 0
        let labelMargin = self.labelMargin * frameWidth
        while value <= self.maxSpeed {
            let y = imageHeight - (steps * CGFloat((self.visibleRange / 2) + value))
            CGContextMoveToPoint(context, imageWidth - (self.areaWidth * scale), y)
            CGContextAddLineToPoint(context, imageWidth - (self.notchWidth * scale), y)
            
            // Label
            if i % self.stepsPerLabel == 0 {
                let text: NSString = "\(value)"
                let labelAttributes: [String: AnyObject] = [
                    NSFontAttributeName: UIFont.boldSystemFontOfSize(frameWidth * self.fontSize),
                    NSForegroundColorAttributeName: labelColor,
                ]
                
                let boundingBox = text.sizeWithAttributes(labelAttributes)
                text.drawAtPoint(CGPoint(x: labelMargin, y: y - (boundingBox.height / 2.0)), withAttributes: labelAttributes)
            }
            
            value += self.scaleSteps
            i += 1
        }
        CGContextStrokePath(context)
        
        // Speed Limit
        if let speedLimit = self.speedLimit {
            let speedLimitY = imageHeight - (steps * CGFloat((self.visibleRange / 2) + speedLimit))
            let overspeedY = imageHeight - (steps * CGFloat((self.visibleRange / 2) + speedLimit + overspeedTolerance))
            CGContextSetStrokeColorWithColor(context, UIColor.orangeColor().CGColor)
            CGContextMoveToPoint(context, imageWidth - (overspeedIndicatorWidth * scale), speedLimitY)
            CGContextAddLineToPoint(context, imageWidth - (speedLimitIndicatorWidth * scale), speedLimitY)
            CGContextAddLineToPoint(context, imageWidth - (speedLimitIndicatorWidth * scale), overspeedY)
            CGContextStrokePath(context)
            
            CGContextSetFillColorWithColor(context, UIColor.redColor().CGColor)
            CGContextMoveToPoint(context, imageWidth - (overspeedIndicatorWidth * scale), overspeedY)
            CGContextAddLineToPoint(context, imageWidth, overspeedY)
            CGContextAddLineToPoint(context, imageWidth, 0)
            CGContextAddLineToPoint(context, imageWidth - (overspeedIndicatorWidth * scale), 0)
            CGContextAddLineToPoint(context, imageWidth - (overspeedIndicatorWidth * scale), overspeedY)
            CGContextFillPath(context)
        }
    
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.scaleImage = image
    }
}
