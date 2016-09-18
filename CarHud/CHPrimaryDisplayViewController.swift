//
//  CHPrimaryDisplayViewController.swift
//  CarHud
//
//  Created by Thorsten Kober on 07/09/16.
//  Copyright © 2016 Thorsten Kober. All rights reserved.
//

import UIKit

class CHPrimaryDisplayViewController: UIViewController {
    
    @IBOutlet weak var speedLabel: UILabel!
    
    @IBOutlet weak var speedScale: AirspeedScaleView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.speedScale.overspeedTolerance = (UIApplication.sharedApplication().delegate as! AppDelegate).overspeedTolerance
        (UIApplication.sharedApplication().delegate as! AppDelegate).onSpeedLimitUpdate = { (newValue: UInt?) -> () in
            self.speedScale.speedLimit = newValue
        };
        
        CHCarBridgeConnector.sharedInstance.onSpeedUpdate = { (newValue: NSNumber) -> () in
            self.speedLabel.text = newValue.stringValue
            self.speedScale.setAirspeed(newValue.unsignedIntegerValue)
        }
    }

}
