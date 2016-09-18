//
//  CHSpeedLimitDisplayController.swift
//  CarHud
//
//  Created by Thorsten Kober on 26.07.15.
//  Copyright (c) 2015 Thorsten Kober. All rights reserved.
//

import UIKit


class CHSpeedLimitDisplayController: CHGaugeViewController, CHSecondaryDisplay, CHSpeedLimitDelegate {
    
    @IBOutlet weak var speedLimitNo: CHSpeedLimitView!
    @IBOutlet weak var speedLimit30: CHSpeedLimitView!
    @IBOutlet weak var speedLimit40: CHSpeedLimitView!
    @IBOutlet weak var speedLimit50: CHSpeedLimitView!
    @IBOutlet weak var speedLimit60: CHSpeedLimitView!
    @IBOutlet weak var speedLimit70: CHSpeedLimitView!
    @IBOutlet weak var speedLimit80: CHSpeedLimitView!
    @IBOutlet weak var speedLimit90: CHSpeedLimitView!
    @IBOutlet weak var speedLimit100: CHSpeedLimitView!
    @IBOutlet weak var speedLimit110: CHSpeedLimitView!
    @IBOutlet weak var speedLimit120: CHSpeedLimitView!
    @IBOutlet weak var speedLimit130: CHSpeedLimitView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectableElements.append(speedLimitNo)
        self.selectableElements.append(speedLimit30)
        self.selectableElements.append(speedLimit40)
        self.selectableElements.append(speedLimit50)
        self.selectableElements.append(speedLimit60)
        self.selectableElements.append(speedLimit70)
        self.selectableElements.append(speedLimit80)
        self.selectableElements.append(speedLimit90)
        self.selectableElements.append(speedLimit100)
        self.selectableElements.append(speedLimit110)
        self.selectableElements.append(speedLimit120)
        self.selectableElements.append(speedLimit130)
        self.currentSelection = 0
        
        self.speedLimitNo.select()
    }
    
    
    func didSelectSpeedLimit(speedLimit: UInt?) {
        (UIApplication.sharedApplication().delegate as! AppDelegate).speedLimit = speedLimit
    }
    
    
    // MARK: - Private
    // MARK: | Storyboard
    
    
    
    private static let STORYBOARD_NAME = "Main";
    private static let STORYBOARD_ID = "SpeedLimit";
    
    
    // MARK: - CHSecondaryDisplay
    
    
    
    static func display() -> CHSecondaryDisplay {
        return UIStoryboard(name: self.STORYBOARD_NAME, bundle: nil).instantiateViewControllerWithIdentifier(STORYBOARD_ID) as! CHSecondaryDisplay;
    }
    
    override func shouldDeselectOnBecommingInactive() -> Bool {
        return false
    }
    
    override func shouldEngage() -> Bool {
        return false
    }
}
