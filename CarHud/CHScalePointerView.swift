//
//  CHScalePointerView.swift
//  CarHud
//
//  Created by Thorsten Kober on 18/09/16.
//  Copyright © 2016 Thorsten Kober. All rights reserved.
//

import UIKit

@IBDesignable class CHScalePointerView: UIView {

    @IBInspectable var borderColor: UIColor = UIColor(red: 0, green: 165.0/255.0, blue: 1, alpha: 1)
    
    
    @IBInspectable var borderWidth: CGFloat = 2
    
    
    @IBInspectable var pointerHeight: CGFloat = 20
    
    
    @IBInspectable var pointerWidth: CGFloat = 12
    
    
    @IBInspectable var verticalMargin: CGFloat = 20
    
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetStrokeColorWithColor(context, self.borderColor.CGColor)
        CGContextSetLineWidth(context, self.borderWidth)
        CGContextSetLineCap(context, CGLineCap.Round)
        
        
        CGContextMoveToPoint(context, pointerWidth, verticalMargin)
        CGContextAddLineToPoint(context, pointerWidth, ((rect.height - pointerHeight) / 2.0))
        CGContextAddLineToPoint(context, 0, (rect.height / 2.0))
        CGContextAddLineToPoint(context, pointerWidth, ((rect.height + pointerHeight) / 2.0))
        CGContextAddLineToPoint(context, pointerWidth, rect.height - verticalMargin)
        
        CGContextDrawPath(context, CGPathDrawingMode.FillStroke)
    }

}
