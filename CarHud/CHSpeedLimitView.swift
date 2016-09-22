//
//  CHSpeedLimitView.swift
//  CarHud
//
//  Created by Thorsten Kober on 18/09/16.
//  Copyright © 2016 Thorsten Kober. All rights reserved.
//

import UIKit


protocol CHSpeedLimitDelegate {
    func didSelectSpeedLimit(_ speedLimit: UInt?)
}


@IBDesignable class CHSpeedLimitView: UIView, CHSelectableView {
    
    @IBOutlet var speedLimitDelegate: CHSpeedLimitDisplayController?
    
    @IBInspectable var unselectedColor: UIColor = UIColor.clear {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var selectedSymbolColor: UIColor = UIColor.white {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var selectedFrameColor: UIColor = UIColor.red {
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
    
    override func draw(_ rect: CGRect) {
        super.draw(rect);
        
        let size = min(rect.height, rect.width)
        let context = UIGraphicsGetCurrentContext()
        
        drawSymbol(rect, context: context, size: size)
        drawFrame(rect, context: context, size: size)
    }
    
    func drawSymbol(_ rect: CGRect, context: CGContext?, size: CGFloat) {
        let text = "\(self.value)"
        let labelAttributes: [String: AnyObject] = [
            NSFontAttributeName: UIFont.systemFont(ofSize: size * self.symbolSize),
            NSForegroundColorAttributeName: self.isSelected ? self.selectedSymbolColor : self.unselectedColor
        ]
        let boundingBox = text.size(attributes: labelAttributes)
        text.draw(in: CGRect(origin: CGPoint(x: (rect.width - boundingBox.width) / 2, y: (rect.height - boundingBox.height) / 2), size: boundingBox), withAttributes: labelAttributes)
    }
    
    func drawFrame(_ rect: CGRect, context: CGContext?, size: CGFloat) {
        context?.setStrokeColor(self.isSelected ? self.selectedFrameColor.cgColor : self.unselectedColor.cgColor)
        context?.setLineWidth(size * self.frameSize)
        
        let rect = CGRect(x: (rect.width - size + size * self.frameSize) / 2.0,
                          y: (rect.height - size + size * self.frameSize) / 2.0,
                          width: size - size * self.frameSize,
                          height: size - size * self.frameSize)
        context?.addEllipse(in: rect)
        
        context?.strokePath()
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
