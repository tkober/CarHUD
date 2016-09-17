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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CHCarBridgeConnector.sharedInstance.onSpeedUpdate = { (newValue: NSNumber) -> () in
            self.speedLabel.text = newValue.stringValue
        }
    }

}
