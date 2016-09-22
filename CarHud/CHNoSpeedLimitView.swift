//
//  CHNoSpeedLimitView.swift
//  CarHud
//
//  Created by Thorsten Kober on 18/09/16.
//  Copyright © 2016 Thorsten Kober. All rights reserved.
//

import UIKit


@IBDesignable class CHNoSpeedLimitView: CHSpeedLimitView {

    
    override func drawSymbol(_ rect: CGRect, context: CGContext?, size: CGFloat) {
        context?.setStrokeColor(self.isSelected ? self.selectedFrameColor.cgColor : self.unselectedColor.cgColor)
        context?.setLineWidth(size * self.symbolSize)
        
        let center = CGPoint(x: rect.width/2.0, y: rect.height/2.0);
        let radius = (size - size * self.frameSize) / 2.0
        
        var point = CGPoint(x: (cos(degreesToRadians(-60)) * radius) + center.x, y: (sin(degreesToRadians(-60)) * radius) + center.y)
        context?.move(to: CGPoint(x: point.x, y: point.y))
        point = CGPoint(x: (cos(degreesToRadians(150)) * radius) + center.x, y: (sin(degreesToRadians(150)) * radius) + center.y)
        context?.addLine(to: CGPoint(x: point.x, y: point.y))
        
        point = CGPoint(x: (cos(degreesToRadians(-50)) * radius) + center.x, y: (sin(degreesToRadians(-50)) * radius) + center.y)
        context?.move(to: CGPoint(x: point.x, y: point.y))
        point = CGPoint(x: (cos(degreesToRadians(140)) * radius) + center.x, y: (sin(degreesToRadians(140)) * radius) + center.y)
        context?.addLine(to: CGPoint(x: point.x, y: point.y))
        
        point = CGPoint(x: (cos(degreesToRadians(-40)) * radius) + center.x, y: (sin(degreesToRadians(-40)) * radius) + center.y)
        context?.move(to: CGPoint(x: point.x, y: point.y))
        point = CGPoint(x: (cos(degreesToRadians(130)) * radius) + center.x, y: (sin(degreesToRadians(130)) * radius) + center.y)
        context?.addLine(to: CGPoint(x: point.x, y: point.y))
        
        point = CGPoint(x: (cos(degreesToRadians(-30)) * radius) + center.x, y: (sin(degreesToRadians(-30)) * radius) + center.y)
        context?.move(to: CGPoint(x: point.x, y: point.y))
        point = CGPoint(x: (cos(degreesToRadians(120)) * radius) + center.x, y: (sin(degreesToRadians(120)) * radius) + center.y)
        context?.addLine(to: CGPoint(x: point.x, y: point.y))
        
        context?.strokePath()
    }
    
    fileprivate func degreesToRadians(_ degrees: Double) -> CGFloat {
        return CGFloat(degrees / 180.0 * M_PI)
    }
}
