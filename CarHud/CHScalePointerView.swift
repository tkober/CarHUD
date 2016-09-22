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
    
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(self.borderColor.cgColor)
        context?.setLineWidth(self.borderWidth)
        context?.setLineCap(CGLineCap.round)
        
        
        context?.move(to: CGPoint(x: pointerWidth, y: verticalMargin))
        context?.addLine(to: CGPoint(x: pointerWidth, y: ((rect.height - pointerHeight) / 2.0)))
        context?.addLine(to: CGPoint(x: 0, y: (rect.height / 2.0)))
        context?.addLine(to: CGPoint(x: pointerWidth, y: ((rect.height + pointerHeight) / 2.0)))
        context?.addLine(to: CGPoint(x: pointerWidth, y: rect.height - verticalMargin))
        
        context?.drawPath(using: CGPathDrawingMode.fillStroke)
    }

}
