//
//  CHEngineDisplayController.swift
//  CarHud
//
//  Created by Thorsten Kober on 26.07.15.
//  Copyright (c) 2015 Thorsten Kober. All rights reserved.
//

import UIKit


class CHEngineDisplayController: CHGaugeViewController, CHSecondaryDisplay {
    
    @IBOutlet weak var engineLoadGauge: CHGaugeView!
    @IBOutlet weak var coolantTempGauge: CHGaugeView!
    @IBOutlet weak var intakeTempGauge: CHGaugeView!
    @IBOutlet weak var intakeMAPGauge: CHGaugeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectableElements.append(self.engineLoadGauge)
        self.selectableElements.append(self.coolantTempGauge)
        self.selectableElements.append(self.intakeTempGauge)
        self.selectableElements.append(self.intakeMAPGauge)
        self.currentSelection = 0
        
        CHCarBridgeConnector.sharedInstance.onEngineLoadUpdate = { (value: NSNumber) -> () in
            self.engineLoadGauge.value = value.doubleValue
        }
        
        CHCarBridgeConnector.sharedInstance.onCoolantTempUpdate = { (value: NSNumber) -> () in
            self.coolantTempGauge.value = value.doubleValue
        }
        
        CHCarBridgeConnector.sharedInstance.onIntakeTempUpdate = { (value: NSNumber) -> () in
            self.intakeTempGauge.value = value.doubleValue
        }
        
        CHCarBridgeConnector.sharedInstance.onIntakeMAPUpdate = { (value: NSNumber) -> () in
            self.intakeMAPGauge.value = value.doubleValue
        }
    }
    
    // MARK: - Private
    // MARK: | Storyboard
    
    
    
    fileprivate static let STORYBOARD_NAME = "Main";
    fileprivate static let STORYBOARD_ID = "Engine";
    
    
    // MARK: - CHSecondaryDisplay
    
    
    
    static func display() -> CHSecondaryDisplay {
        return UIStoryboard(name: self.STORYBOARD_NAME, bundle: nil).instantiateViewController(withIdentifier: STORYBOARD_ID) as! CHSecondaryDisplay;
    }
}
