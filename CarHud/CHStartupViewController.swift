//
//  CHStartupViewController.swift
//  CarHud
//
//  Created by Thorsten Kober on 05/09/16.
//  Copyright © 2016 Thorsten Kober. All rights reserved.
//

import UIKit


enum CHStartupStatus {
    
    case Processing(message: String, color: UIColor)
    
    case Success(message: String)
    
    case Error(error: String)
}



let PROCESSING_COLOR = UIColor.whiteColor()

let SUCCESS_COLOR = UIColor.greenColor()

let ERROR_COLOR = UIColor.redColor()


private let HUD_CONTROLLER_STORYBOARD_ID = "hudController"



class CHStartupViewController: UIViewController {
    
    
    // MARK: | IB Outlets
    
    @IBOutlet private weak var statusLabel: UILabel?
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView?
    
    @IBOutlet private weak var retryButton: UIButton?
    
    
    // MARK: | IB Actions
    
    @IBAction private func retryButtonPressed(sender: UIButton) {
    }
    
    
    // MARK: | Status
    
    var status = CHStartupStatus.Processing(message: "", color: PROCESSING_COLOR) {
        didSet {
            self.updateUI()
        }
        
    }
    
    
    private func updateUI() {
        switch status {
            
        case .Processing(let message, let color):
            self.statusLabel?.textColor = color
            self.activityIndicator?.color = color
            self.activityIndicator?.hidden = false
            self.activityIndicator?.startAnimating()
            self.retryButton?.hidden = true
            self.statusLabel?.text = message
            break
            
        case .Success(let message):
            self.statusLabel?.textColor = SUCCESS_COLOR
            self.activityIndicator?.hidden = true
            self.retryButton?.hidden = true
            self.statusLabel?.text = message
            break
            
        case .Error(let error):
            self.statusLabel?.textColor = ERROR_COLOR
            self.activityIndicator?.hidden = true
            self.retryButton?.hidden = false
            self.statusLabel?.text = error
            break
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
    }
    
    
    lazy var hudController: CHHudViewController = self.storyboard?.instantiateViewControllerWithIdentifier(HUD_CONTROLLER_STORYBOARD_ID) as! CHHudViewController
}


extension CHStartupViewController: CHBLEConnectorDelegate {
    
    func connectorDiscoveredOBD2Adapter(connector: CHBLEConnector) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.status = CHStartupStatus.Processing(message: "Establishing connection", color: PROCESSING_COLOR)
        }
    }
    
    
    func connectorEstablishedConnection(connector: CHBLEConnector) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.status = CHStartupStatus.Success(message: "Connection established")
            self.presentViewController(self.hudController, animated: true, completion: nil)
        }
    }
    
    
    func connectorFailedConnecting(connector: CHBLEConnector) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.status =  CHStartupStatus.Error(error: "Establishing connection failed")
        }
    }
    
    
    func connectorLostConnection(connector: CHBLEConnector) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.hudController.dismissViewControllerAnimated(true, completion: nil)
            self.status = CHStartupStatus.Processing(message: "Lost connection,\nreconnecting", color: ERROR_COLOR)
        }
    }
    
}
