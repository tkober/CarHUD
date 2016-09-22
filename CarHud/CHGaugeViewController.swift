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
    
    func gaugeTapped(_ gauge: CHGaugeView) {
        if let maximized = maximizedGauge {
            unmaximizeGauge(maximized)
            maximizedGauge = nil
        } else {
            maximizedGauge = gauge
            maximizeGauge(gauge)
        }
    }
    
    func maximizeGauge(_ gauge: CHGaugeView) {
        gauge.backgroundColor = self.view.backgroundColor
        
        let bindings = Dictionary(dictionaryLiteral: ("gauge", gauge))
        var allConstraints = [NSLayoutConstraint]()
        
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-40-[gauge]-0-|", options: [], metrics: nil, views: bindings)
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[gauge]-10-|", options: [], metrics: nil, views: bindings)
        
        for view in self.view.subviews {
            if view != titleLabel && view != gauge {
                view.isHidden = true
            }
        }
        
        self.maximizedConstraints = allConstraints
        UIView.animate(withDuration: 0.3, animations: {
            NSLayoutConstraint.activate(allConstraints)
            [self.view .layoutIfNeeded()];
        }) ;
    }
    
    func unmaximizeGauge(_ gauge: CHGaugeView) {
        gauge.backgroundColor = UIColor.clear
        UIView.animate(withDuration: 0.3, animations: {
            NSLayoutConstraint.deactivate(self.maximizedConstraints!)
            [self.view .layoutIfNeeded()];
        }, completion: { (finished: Bool) in
            for view in self.view.subviews {
                if view != self.titleLabel && view != gauge {
                    view.isHidden = false
                }
            }
        }) 
    }
}

