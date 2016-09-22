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
    

    func setAirspeed(_ airspeed: UInt) {
        let value = max(0, airspeed)
        self._airspeed = value
    }
    
    fileprivate var _airspeed: UInt = 0 {
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
    
    
    
    override func draw(_ rect: CGRect) {
        if let image = self.scaleImage {
            let scale = UIScreen.main.scale
            
            let width = rect.width * scale
            let height = rect.height * scale
            let steps = height / CGFloat(self.visibleRange)
            let y = image.size.height - height - steps * CGFloat(self._airspeed);
            let sectionFrame = CGRect(x: 0, y: y, width: width, height: height)
            
            let section = image.cgImage?.cropping(to: sectionFrame)
            UIImage(cgImage: section!).draw(in: rect)
        } else {
            DispatchQueue.main.async { () -> Void in
                self.renderScale(rect)
            }
        }
    }
    
    fileprivate func renderScale(_ frame: CGRect) {
        let scale = UIScreen.main.scale
        
        let frameWidth = frame.width * scale
        let frameHeight = frame.height * scale
        let steps = frameHeight / CGFloat(self.visibleRange)
        
        let imageWidth = frameWidth
        let imageHeight = steps * CGFloat(self.maxSpeed + (self.visibleRange / 2))
        
        UIGraphicsBeginImageContext(CGSize(width: imageWidth, height: imageHeight))
        let context = UIGraphicsGetCurrentContext()
        
        // Scale
        context?.setLineWidth(self.scaleWidth * scale)
        context?.setStrokeColor(self.scaleColor.cgColor)
        
        var value: UInt = 0
        var i = 0
        let labelMargin = self.labelMargin * frameWidth
        while value <= self.maxSpeed {
            let y = imageHeight - (steps * CGFloat((self.visibleRange / 2) + value))
            context?.move(to: CGPoint(x: imageWidth - (self.areaWidth * scale), y: y))
            context?.addLine(to: CGPoint(x: imageWidth - (self.notchWidth * scale), y: y))
            
            // Label
            if i % self.stepsPerLabel == 0 {
                let text: NSString = "\(value)" as NSString
                let labelAttributes: [String: AnyObject] = [
                    NSFontAttributeName: UIFont.boldSystemFont(ofSize: frameWidth * self.fontSize),
                    NSForegroundColorAttributeName: labelColor,
                ]
                
                let boundingBox = text.size(attributes: labelAttributes)
                text.draw(at: CGPoint(x: labelMargin, y: y - (boundingBox.height / 2.0)), withAttributes: labelAttributes)
            }
            
            value += self.scaleSteps
            i += 1
        }
        context?.strokePath()
        
        // Speed Limit
        if let speedLimit = self.speedLimit {
            let speedLimitY = imageHeight - (steps * CGFloat((self.visibleRange / 2) + speedLimit))
            let overspeedY = imageHeight - (steps * CGFloat((self.visibleRange / 2) + speedLimit + overspeedTolerance))
            context?.setStrokeColor(UIColor.orange.cgColor)
            context?.move(to: CGPoint(x: imageWidth - (overspeedIndicatorWidth * scale), y: speedLimitY))
            context?.addLine(to: CGPoint(x: imageWidth - (speedLimitIndicatorWidth * scale), y: speedLimitY))
            context?.addLine(to: CGPoint(x: imageWidth - (speedLimitIndicatorWidth * scale), y: overspeedY))
            context?.strokePath()
            
            context?.setFillColor(UIColor.red.cgColor)
            context?.move(to: CGPoint(x: imageWidth - (overspeedIndicatorWidth * scale), y: overspeedY))
            context?.addLine(to: CGPoint(x: imageWidth, y: overspeedY))
            context?.addLine(to: CGPoint(x: imageWidth, y: 0))
            context?.addLine(to: CGPoint(x: imageWidth - (overspeedIndicatorWidth * scale), y: 0))
            context?.addLine(to: CGPoint(x: imageWidth - (overspeedIndicatorWidth * scale), y: overspeedY))
            context?.fillPath()
        }
    
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.scaleImage = image
    }
}
