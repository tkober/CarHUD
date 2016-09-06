//
//  CHGaugeView.swift
//  CarHud
//
//  Created by Thorsten Kober on 26.07.15.
//  Copyright (c) 2015 Thorsten Kober. All rights reserved.
//

import UIKit


protocol CHGaugeViewDelegate {
    
    func gaugeTapped(gauge: CHGaugeView)
    
}


@IBDesignable class CHGaugeView: UIView {
    
    @IBOutlet var tapDelegate: CHGaugeViewController?
    
    
    // MARK: | Description Text
    // e.g. THROTTLE, POWER...

    @IBInspectable var descriptionTextSize: CGFloat = 0.15 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var descriptionTextColor: UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1) {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var descriptionText: String = "" {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    
    // MARK: | Unit Text
    // e.g. rpm, %...
    
    @IBInspectable var unitAreaSize: CGFloat = 0.23 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var unitTextSize: CGFloat = 0.15 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    @IBInspectable var unitTextColor: UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8) {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var unitText: String = "" {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    
    // MARK: | Value
    
    @IBInspectable var value: Double = 0.5 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var maxValue: Double = 1.0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var minValue: Double = 0.0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var showDecimals: Bool = true {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var valueTextSize: CGFloat = 0.25 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var valueTextMargin: CGFloat = 0.03 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    
    // MARK: | Indicator
    
    @IBInspectable var indicatorColor: UIColor = UIColor(red: 0, green: 165.0/255.0, blue: 1, alpha: 1) {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var indicatorSize: CGFloat = 0.03 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    
    // MARK: | Scale
    
    @IBInspectable var scaleColor: UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4) {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var scaleSize: CGFloat = 0.005 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    
    // MARK: | Selection
    
    
    @IBInspectable var isSelected: Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    
    // MARK: | Views Lifecylce
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gaugeTapped)))
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect);
        
        let size = min(rect.height, rect.width * (1-unitAreaSize))
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, size*scaleSize)
        CGContextSetStrokeColorWithColor(context, scaleColor.CGColor)
        CGContextSetFillColorWithColor(context, scaleColor.colorWithAlphaComponent(0.2).CGColor)
        
        let center = CGPointMake(size/2.0, size/2.0);
        let from = self.degreesToRadians(215);
        let to = self.degreesToRadians(115);
        let radius = (size / 2.0) - (size*indicatorSize + size*scaleSize);
        
        CGContextAddArc(context, center.x, center.y, radius, from, from, 0)
        let arcBegin = CGContextGetPathCurrentPoint(context)
        CGContextAddArc(context, center.x, center.y, radius, from, to, 0)
        if (isSelected) {
            CGContextAddLineToPoint(context, size + size*unitAreaSize + size*valueTextMargin, CGContextGetPathCurrentPoint(context).y)
            CGContextAddLineToPoint(context, size + size*unitAreaSize + size*valueTextMargin, size)
            CGContextAddLineToPoint(context, size, CGContextGetPathCurrentPoint(context).y)
            CGContextAddLineToPoint(context, size, size)
            CGContextAddLineToPoint(context, arcBegin.x, size)
            CGContextDrawPath(context, CGPathDrawingMode.Fill)
        } else {
            CGContextDrawPath(context, CGPathDrawingMode.Stroke)
        }
        
        CGContextSetLineWidth(context, size*indicatorSize);
        CGContextSetStrokeColorWithColor(context, indicatorColor.CGColor);
        CGContextAddArc(context, center.x, center.y, radius+(size*indicatorSize / 2.0), from, self.degreesToRadians(330), 0);
        CGContextStrokePath(context);
        
        drawDescriptionText(size)
        drawUnitText(size)
        drawValue(size)
    }
    
    
    private func drawDescriptionText(gaugeSize: CGFloat) {
        let text = descriptionText.uppercaseString
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.Center
        let labelAttributes: [String: AnyObject] = [
            NSFontAttributeName: UIFont.systemFontOfSize(gaugeSize * descriptionTextSize),
            NSForegroundColorAttributeName: descriptionTextColor,
            NSParagraphStyleAttributeName: style
        ]
        let boundingBox = text.sizeWithAttributes(labelAttributes)
        text.drawInRect(CGRect(origin: CGPoint(x: (gaugeSize - boundingBox.width) / 2, y: (gaugeSize - boundingBox.height) / 2), size: boundingBox), withAttributes: labelAttributes)
    }
    
    
    private func drawUnitText(gaugeSize: CGFloat) {
        let text = unitText
        let labelAttributes: [String: AnyObject] = [
            NSFontAttributeName: UIFont.systemFontOfSize(gaugeSize * unitTextSize),
            NSForegroundColorAttributeName: unitTextColor
        ]
        let boundingBox = text.sizeWithAttributes(labelAttributes)
        text.drawAtPoint(CGPoint(x: gaugeSize, y: gaugeSize - boundingBox.height), withAttributes: labelAttributes)
    }
    
    
    private func drawValue(gaugeSize: CGFloat) {
        let text = showDecimals ? "\(value)" : "\(Int(value))"
        let labelAttributes: [String: AnyObject] = [
            NSFontAttributeName: UIFont.boldSystemFontOfSize(gaugeSize * valueTextSize),
            NSForegroundColorAttributeName: indicatorColor
        ]
        let boundingBox = text.sizeWithAttributes(labelAttributes)
        text.drawAtPoint(CGPoint(x: gaugeSize - boundingBox.width - (gaugeSize*valueTextMargin), y: gaugeSize - boundingBox.height), withAttributes: labelAttributes)
    }
    
    
    private func degreesToRadians(degrees: Double) -> CGFloat {
        let checkedDegrees = (degrees + 270) % 360;
        let result = (2.0 * M_PI * checkedDegrees) / 360.0;
        return CGFloat(result);
    }
    
    
    func gaugeTapped() {
        self.tapDelegate?.gaugeTapped(self)
    }
    
}
