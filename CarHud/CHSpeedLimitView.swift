//
//  CHSpeedLimitView.swift
//  CarHud
//
//  Created by Thorsten Kober on 18/09/16.
//  Copyright © 2016 Thorsten Kober. All rights reserved.
//

import UIKit


protocol CHSpeedLimitDelegate {
    func didSelectSpeedLimit(speedLimit: UInt?)
}


@IBDesignable class CHSpeedLimitView: UIView, CHSelectableView {
    
    @IBOutlet var speedLimitDelegate: CHSpeedLimitDisplayController?
    
    @IBInspectable var unselectedColor: UIColor = UIColor.clearColor() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var selectedSymbolColor: UIColor = UIColor.whiteColor() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var selectedFrameColor: UIColor = UIColor.redColor() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var frameSize: CGFloat = 0.1 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var symbolSize: CGFloat = 0.4 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var value: UInt = 0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var isSelected: Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect);
        
        let size = min(rect.height, rect.width)
        let context = UIGraphicsGetCurrentContext()
        
        drawSymbol(rect, context: context, size: size)
        drawFrame(rect, context: context, size: size)
    }
    
    func drawSymbol(rect: CGRect, context: CGContext?, size: CGFloat) {
        let text = "\(self.value)"
        let labelAttributes: [String: AnyObject] = [
            NSFontAttributeName: UIFont.systemFontOfSize(size * self.symbolSize),
            NSForegroundColorAttributeName: self.isSelected ? self.selectedSymbolColor : self.unselectedColor
        ]
        let boundingBox = text.sizeWithAttributes(labelAttributes)
        text.drawInRect(CGRect(origin: CGPoint(x: (rect.width - boundingBox.width) / 2, y: (rect.height - boundingBox.height) / 2), size: boundingBox), withAttributes: labelAttributes)
    }
    
    func drawFrame(rect: CGRect, context: CGContext?, size: CGFloat) {
        CGContextSetStrokeColorWithColor(context, self.isSelected ? self.selectedFrameColor.CGColor : self.unselectedColor.CGColor)
        CGContextSetLineWidth(context, size * self.frameSize)
        
        let rect = CGRect(x: (rect.width - size + size * self.frameSize) / 2.0,
                          y: (rect.height - size + size * self.frameSize) / 2.0,
                          width: size - size * self.frameSize,
                          height: size - size * self.frameSize)
        CGContextAddEllipseInRect(context, rect)
        
        CGContextStrokePath(context)
    }
    
    func select() {
        self.isSelected = true
        self.speedLimitDelegate?.didSelectSpeedLimit(self.value)
    }
    
    func deselect() {
        self.isSelected = false
    }
    
    func engage() {
    }
}
