//
//  CHPowerDisplayController.swift
//  CarHud
//
//  Created by Thorsten Kober on 26.07.15.
//  Copyright (c) 2015 Thorsten Kober. All rights reserved.
//

import UIKit


class CHPowerDisplayController: CHGaugeViewController, CHSecondaryDisplay {
    
    
    // MARK: - Private
    // MARK: | Storyboard
    
    
    
    private static let STORYBOARD_NAME = "Main";
    private static let STORYBOARD_ID = "Power";
    
    
    // MARK: - CHSecondaryDisplay
    
    
    
    static func display() -> CHSecondaryDisplay {
        return UIStoryboard(name: self.STORYBOARD_NAME, bundle: nil).instantiateViewControllerWithIdentifier(STORYBOARD_ID) as! CHSecondaryDisplay;
    }
}
