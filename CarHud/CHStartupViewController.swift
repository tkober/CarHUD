//
//  CHStartupViewController.swift
//  CarHud
//
//  Created by Thorsten Kober on 05/09/16.
//  Copyright © 2016 Thorsten Kober. All rights reserved.
//

import UIKit


enum CHStartupStatus {
    
    case processing(message: String, color: UIColor)
    
    case success(message: String)
    
    case error(error: String)
}



let PROCESSING_COLOR = UIColor.white

let SUCCESS_COLOR = UIColor.green

let ERROR_COLOR = UIColor.red


private let HUD_CONTROLLER_STORYBOARD_ID = "hudController"



class CHStartupViewController: UIViewController {
    
    
    // MARK: | IB Outlets
    
    @IBOutlet fileprivate weak var statusLabel: UILabel?
    
    @IBOutlet fileprivate weak var activityIndicator: UIActivityIndicatorView?
    
    @IBOutlet fileprivate weak var retryButton: UIButton?
    
    
    // MARK: | IB Actions
    
    @IBAction fileprivate func retryButtonPressed(_ sender: UIButton) {
    }
    
    
    // MARK: | Status
    
    var status = CHStartupStatus.processing(message: "", color: PROCESSING_COLOR) {
        didSet {
            self.updateUI()
        }
        
    }
    
    
    fileprivate func updateUI() {
        switch status {
            
        case .processing(let message, let color):
            self.statusLabel?.textColor = color
            self.activityIndicator?.color = color
            self.activityIndicator?.isHidden = false
            self.activityIndicator?.startAnimating()
            self.retryButton?.isHidden = true
            self.statusLabel?.text = message
            break
            
        case .success(let message):
            self.statusLabel?.textColor = SUCCESS_COLOR
            self.activityIndicator?.isHidden = true
            self.retryButton?.isHidden = true
            self.statusLabel?.text = message
            break
            
        case .error(let error):
            self.statusLabel?.textColor = ERROR_COLOR
            self.activityIndicator?.isHidden = true
            self.retryButton?.isHidden = false
            self.statusLabel?.text = error
            break
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
    }
    
    
    lazy var hudController: CHHudViewController = self.storyboard?.instantiateViewController(withIdentifier: HUD_CONTROLLER_STORYBOARD_ID) as! CHHudViewController
}


extension CHStartupViewController: CHBLEConnectorDelegate {
    
    func connectorDiscoveredOBD2Adapter(_ connector: CHBLEConnector) {
        DispatchQueue.main.async { () -> Void in
            self.status = CHStartupStatus.processing(message: "Establishing connection", color: PROCESSING_COLOR)
        }
    }
    
    
    func connectorEstablishedConnection(_ connector: CHBLEConnector) {
        DispatchQueue.main.async { () -> Void in
            self.status = CHStartupStatus.processing(message: "Authenticating", color: SUCCESS_COLOR)
            
        }
    }
    
    
    func connectorAuthenticationSuccessful(_ connector: CHBLEConnector) {
        DispatchQueue.main.async { () -> Void in
            self.status = CHStartupStatus.processing(message: "Starting OBD2-Module", color: SUCCESS_COLOR)
            
        }
    }
    
    
    func connectorServiceStarted(_ connector: CHBLEConnector) {
        DispatchQueue.main.async { () -> Void in
            self.status = CHStartupStatus.success(message: "OBD2-Module started")
            self.present(self.hudController, animated: true, completion: nil)
        }
    }
    
    
    func connectorServiceStopped(_ connector: CHBLEConnector) {
        DispatchQueue.main.async { () -> Void in
            print("connectorServiceStopped()")
        }
    }
    
    
    func connectorFailedConnecting(_ connector: CHBLEConnector) {
        DispatchQueue.main.async { () -> Void in
            self.status =  CHStartupStatus.error(error: "Establishing connection failed")
        }
    }
    
    
    func connectorLostConnection(_ connector: CHBLEConnector) {
        DispatchQueue.main.async { () -> Void in
            self.hudController.dismiss(animated: true, completion: nil)
            self.status = CHStartupStatus.processing(message: "Lost connection,\nreconnecting", color: ERROR_COLOR)
        }
    }
    
}
