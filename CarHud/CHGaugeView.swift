//
//  CHGaugeView.swift
//  CarHud
//
//  Created by Thorsten Kober on 26.07.15.
//  Copyright (c) 2015 Thorsten Kober. All rights reserved.
//

import UIKit


protocol CHGaugeViewDelegate {
    
    func gaugeTapped(_ gauge: CHGaugeView)
    
}


@IBDesignable class CHGaugeView: UIView, CHSelectableView {
    
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
    
    override func draw(_ rect: CGRect) {
        super.draw(rect);
        
        let size = min(rect.height, rect.width * (1-unitAreaSize))
        
        let context = UIGraphicsGetCurrentContext()
        let scaleSize = isSelected ? self.scaleSize * 4 : self.scaleSize
        context?.setLineWidth(size*scaleSize)
        context?.setStrokeColor(isSelected ? UIColor.white.cgColor : scaleColor.cgColor)
        
        let center = CGPoint(x: size/2.0, y: size/2.0);
        let from = 215.0;
        let to = 115.0;
        let range = (360.0 - from) + to;
        let radius = (size / 2.0) - (size*indicatorSize + size*scaleSize);
        
        CGContextAddArc(context, center.x, center.y, radius, degreesToRadians(from), degreesToRadians(to), 0)
        context?.drawPath(using: CGPathDrawingMode.stroke)
        
        context?.setLineWidth(size*indicatorSize);
        context?.setStrokeColor(indicatorColor.cgColor);
        
        let relativeValue = (self.value + abs(self.minValue)) / abs(self.minValue - self.maxValue)
        let valueToDegrees = (from + (relativeValue * range)).truncatingRemainder(dividingBy: 360.0)
        CGContextAddArc(context, center.x, center.y, radius+(size*indicatorSize / (isSelected ? 1.0 : 2.0)), degreesToRadians(from), degreesToRadians(valueToDegrees), 0);
        context?.strokePath();
        
        drawDescriptionText(size)
        drawUnitText(size)
        drawValue(size)
    }
    
    
    fileprivate func drawDescriptionText(_ gaugeSize: CGFloat) {
        let text = descriptionText.uppercased()
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        let labelAttributes: [String: AnyObject] = [
            NSFontAttributeName: UIFont.systemFont(ofSize: gaugeSize * descriptionTextSize),
            NSForegroundColorAttributeName: descriptionTextColor,
            NSParagraphStyleAttributeName: style
        ]
        let boundingBox = text.size(attributes: labelAttributes)
        text.draw(in: CGRect(origin: CGPoint(x: (gaugeSize - boundingBox.width) / 2, y: (gaugeSize - boundingBox.height) / 2), size: boundingBox), withAttributes: labelAttributes)
    }
    
    
    fileprivate func drawUnitText(_ gaugeSize: CGFloat) {
        let text = unitText
        let labelAttributes: [String: AnyObject] = [
            NSFontAttributeName: UIFont.systemFont(ofSize: gaugeSize * unitTextSize),
            NSForegroundColorAttributeName: unitTextColor
        ]
        let boundingBox = text.size(attributes: labelAttributes)
        text.draw(at: CGPoint(x: gaugeSize, y: gaugeSize - boundingBox.height), withAttributes: labelAttributes)
    }
    
    
    fileprivate func drawValue(_ gaugeSize: CGFloat) {
        let text = showDecimals ? "\(value)" : "\(Int(value))"
        let labelAttributes: [String: AnyObject] = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: gaugeSize * valueTextSize),
            NSForegroundColorAttributeName: indicatorColor
        ]
        let boundingBox = text.size(attributes: labelAttributes)
        text.draw(at: CGPoint(x: gaugeSize - boundingBox.width - (gaugeSize*valueTextMargin), y: gaugeSize - boundingBox.height), withAttributes: labelAttributes)
    }
    
    
    fileprivate func degreesToRadians(_ degrees: Double) -> CGFloat {
        let checkedDegrees = (degrees + 270).truncatingRemainder(dividingBy: 360);
        let result = (2.0 * M_PI * checkedDegrees) / 360.0;
        return CGFloat(result);
    }
    
    
    func gaugeTapped() {
        self.tapDelegate?.gaugeTapped(self)
    }
    
    
    // MARK: - CHSelectableView
    
    func select() {
        self.isSelected = true
    }
    
    func deselect() {
        self.isSelected = false
    }
    
    func engage() {
        gaugeTapped()
    }
}
