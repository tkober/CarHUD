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
    
    private let OVERSPEED_WARNING = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Overspeed_Warning", ofType: "wav")!)
    
    private var isPlayingOverspeedWarning = false
    
    private var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.speedScale.overspeedTolerance = (UIApplication.sharedApplication().delegate as! AppDelegate).overspeedTolerance
        (UIApplication.sharedApplication().delegate as! AppDelegate).onSpeedLimitUpdate = { (newValue: UInt?) -> () in
            self.speedScale.speedLimit = newValue
        };
        
        CHCarBridgeConnector.sharedInstance.onSpeedUpdate = { (newValue: NSNumber) -> () in
            if let speedLimit = (UIApplication.sharedApplication().delegate as! AppDelegate).speedLimit {
                let overspeedTolerance = (UIApplication.sharedApplication().delegate as! AppDelegate).overspeedTolerance
                if newValue.unsignedIntegerValue > (speedLimit + overspeedTolerance) {
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
            self.speedScale.setAirspeed(newValue.unsignedIntegerValue)
        }
    }
    
    private func playSound(sound: NSURL, loop: Bool) {
        stopCurrentSound()
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
            try AVAudioSession.sharedInstance().setInputGain(1.0)
            try AVAudioSession.sharedInstance().setActive(true)
            self.audioPlayer = try AVAudioPlayer(contentsOfURL: sound)
            self.audioPlayer?.volume = 1.0
            self.audioPlayer?.numberOfLoops = loop ? -1 : 1
            self.audioPlayer!.prepareToPlay()
            self.audioPlayer!.play()
        } catch {
            print("Error playing sound '\(sound)'")
        }
    }
    
    private func stopCurrentSound() {
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
