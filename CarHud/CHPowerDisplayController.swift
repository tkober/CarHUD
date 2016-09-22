//
//  CHPowerDisplayController.swift
//  CarHud
//
//  Created by Thorsten Kober on 26.07.15.
//  Copyright (c) 2015 Thorsten Kober. All rights reserved.
//

import UIKit


class CHPowerDisplayController: CHGaugeViewController, CHSecondaryDisplay {
    
    @IBOutlet weak var throttleGauge: CHGaugeView!
    @IBOutlet weak var engineGauge: CHGaugeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectableElements.append(self.throttleGauge)
        self.selectableElements.append(self.engineGauge)
        self.currentSelection = 0
        
        CHCarBridgeConnector.sharedInstance.onThrottleUpdate = { (value: NSNumber) -> () in
            self.throttleGauge.value = value.doubleValue
        }
        
        CHCarBridgeConnector.sharedInstance.onRPMUpdate = { (value: NSNumber) -> () in
            self.engineGauge.value = value.doubleValue
        }
    }
    
    
    // MARK: - Private
    // MARK: | Storyboard
    
    
    
    fileprivate static let STORYBOARD_NAME = "Main";
    fileprivate static let STORYBOARD_ID = "Power";
    
    
    // MARK: - CHSecondaryDisplay
    
    
    
    static func display() -> CHSecondaryDisplay {
        return UIStoryboard(name: self.STORYBOARD_NAME, bundle: nil).instantiateViewController(withIdentifier: STORYBOARD_ID) as! CHSecondaryDisplay;
    }
}
