//
//  CHPrimaryDisplayViewController.swift
//  CarHud
//
//  Created by Thorsten Kober on 07/09/16.
//  Copyright © 2016 Thorsten Kober. All rights reserved.
//

import UIKit
import AVFoundation

class CHPrimaryDisplayViewController: UIViewController {
    
    @IBOutlet weak var speedLabel: UILabel!
    
    @IBOutlet weak var speedScale: AirspeedScaleView!
    
    fileprivate let OVERSPEED_WARNING = URL(fileURLWithPath: Bundle.main.path(forResource: "Overspeed_Warning", ofType: "wav")!)
    
    fileprivate var isPlayingOverspeedWarning = false
    
    fileprivate var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.speedScale.overspeedTolerance = (UIApplication.shared.delegate as! AppDelegate).overspeedTolerance
        (UIApplication.shared.delegate as! AppDelegate).onSpeedLimitUpdate = { (newValue: UInt?) -> () in
            self.speedScale.speedLimit = newValue
        };
        
        CHCarBridgeConnector.sharedInstance.onSpeedUpdate = { (newValue: NSNumber) -> () in
            if let speedLimit = (UIApplication.shared.delegate as! AppDelegate).speedLimit {
                let overspeedTolerance = (UIApplication.shared.delegate as! AppDelegate).overspeedTolerance
                if newValue.uintValue > (speedLimit + overspeedTolerance) {
                    if !self.isPlayingOverspeedWarning {
                        self.isPlayingOverspeedWarning = true
                        self.playSound(self.OVERSPEED_WARNING, loop: true)
                    }
                } else if self.isPlayingOverspeedWarning {
                    self.isPlayingOverspeedWarning = false
                    self.stopCurrentSound()
                }
            }
            
            self.speedLabel.text = newValue.stringValue
            self.speedScale.setAirspeed(newValue.uintValue)
        }
    }
    
    fileprivate func playSound(_ sound: URL, loop: Bool) {
        stopCurrentSound()
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
            try AVAudioSession.sharedInstance().setInputGain(1.0)
            try AVAudioSession.sharedInstance().setActive(true)
            self.audioPlayer = try AVAudioPlayer(contentsOf: sound)
            self.audioPlayer?.volume = 1.0
            self.audioPlayer?.numberOfLoops = loop ? -1 : 1
            self.audioPlayer!.prepareToPlay()
            self.audioPlayer!.play()
        } catch {
            print("Error playing sound '\(sound)'")
        }
    }
    
    fileprivate func stopCurrentSound() {
        if let audioPlayer = self.audioPlayer {
            audioPlayer.stop()
            do {
                try AVAudioSession.sharedInstance().setActive(false)
            } catch {
                
            }
            self.audioPlayer = nil
        }
    }

}
