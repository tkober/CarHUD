//
//  CHGaugeView.swift
//  CarHud
//
//  Created by Thorsten Kober on 26.07.15.
//  Copyright (c) 2015 Thorsten Kober. All rights reserved.
//

import UIKit


@IBDesignable
class CHGaugeView: UIView {
    
    
    // MARK: - Internal
    // MARK: | Views Lifecylce
    
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect);
        let context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 1);
        CGContextSetStrokeColorWithColor(context, UIColor(red: 1, green: 1, blue: 1, alpha: 0.4).CGColor);
        
        let center = CGPointMake(rect.size.width/2.0, rect.size.height/2.0);
        let from = self.degreesToRadians(215);
        let to = self.degreesToRadians(115);
        let radius = (min(rect.size.width, rect.size.height) / 2.0) - 5.0;
        
        CGContextAddArc(context, center.x, center.y, radius, from, to, 0);
        CGContextStrokePath(context);
        
        CGContextSetLineWidth(context, 4);
        CGContextSetStrokeColorWithColor(context, UIColor(red: 0, green: 165.0/255.0, blue: 1, alpha: 1).CGColor);
        CGContextAddArc(context, center.x, center.y, radius+2, from, self.degreesToRadians(330), 0);
        CGContextStrokePath(context);
    }
    
    
    
    // MARK: - Private
    // MARK: | Calculations
    
    

    private func degreesToRadians(degrees: Double) -> CGFloat {
        let checkedDegrees = (degrees + 270) % 360;
        let result = (2.0 * M_PI * checkedDegrees) / 360.0;
        return CGFloat(result);
    }

}
