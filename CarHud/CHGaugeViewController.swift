//
//  CHGaugeViewController.swift
//  CarHud
//
//  Created by Thorsten Kober on 06/09/16.
//  Copyright © 2016 Thorsten Kober. All rights reserved.
//

import UIKit

class CHGaugeViewController: CHSecondaryDisplayViewController, CHGaugeViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel?
    
    var maximizedGauge: CHGaugeView?
    var maximizedConstraints: [NSLayoutConstraint]?
    
    func gaugeTapped(gauge: CHGaugeView) {
        if let maximized = maximizedGauge {
            unmaximizeGauge(maximized)
            maximizedGauge = nil
        } else {
            maximizedGauge = gauge
            maximizeGauge(gauge)
        }
    }
    
    func maximizeGauge(gauge: CHGaugeView) {
        gauge.backgroundColor = self.view.backgroundColor
        
        let bindings = Dictionary(dictionaryLiteral: ("gauge", gauge))
        var allConstraints = [NSLayoutConstraint]()
        
        allConstraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-40-[gauge]-0-|", options: [], metrics: nil, views: bindings)
        allConstraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[gauge]-10-|", options: [], metrics: nil, views: bindings)
        
        for view in self.view.subviews {
            if view != titleLabel && view != gauge {
                view.hidden = true
            }
        }
        
        self.maximizedConstraints = allConstraints
        UIView.animateWithDuration(0.3) {
            NSLayoutConstraint.activateConstraints(allConstraints)
            [self.view .layoutIfNeeded()];
        };
    }
    
    func unmaximizeGauge(gauge: CHGaugeView) {
        gauge.backgroundColor = UIColor.clearColor()
        UIView.animateWithDuration(0.3, animations: {
            NSLayoutConstraint.deactivateConstraints(self.maximizedConstraints!)
            [self.view .layoutIfNeeded()];
        }) { (finished: Bool) in
            for view in self.view.subviews {
                if view != self.titleLabel && view != gauge {
                    view.hidden = false
                }
            }
        }
    }
}

