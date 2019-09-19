//
//  sliderPropertiesVC.swift
//  ProCusPro
//
//  Created by Benjamin Purbowasito on 18/09/19.
//  Copyright © 2019 iosda. All rights reserved.
//

import UIKit
import LocalAuthentication

class SliderPropertiesFM: UIViewController, MSCircularSliderDelegate {
    
    
    //outlet
    
    
    @IBOutlet weak var slider: MSCircularSlider!
    @IBOutlet weak var valueLbl: UILabel!
    
    
    //members
    var animationTimer: Timer?
    var animationReversed = false
    var currentRevolutions = 0
    var currentValue = 0.0
    var countdownTimer: Timer!
    var totalTime:Double = 0.0
    
    
    
    //init
    override func viewDidLoad() {
        super.viewDidLoad()
    

        slider.delegate = self
        
        currentValue = slider.currentValue
        valueLbl.text = String(format: "%.1f", currentValue)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Slider animation
        animateSlider()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // Delegate Methods
    func circularSlider(_ slider: MSCircularSlider, valueChangedTo value: Double, fromUser: Bool) {
        currentValue = value
        if !slider.endlesslyLoops || !slider.fullCircle {
            valueLbl.text = String(format: "%.1f\nx%d", currentValue, currentRevolutions + 1)
        }
        else {
            valueLbl.text = String(format: "%.1f", currentValue)
        }
    }
    
    func circularSlider(_ slider: MSCircularSlider, startedTrackingWith value: Double) {
        // optional delegate method
    }
    
    func circularSlider(_ slider: MSCircularSlider, endedTrackingWith value: Double) {
        // optional delegate method
    }
    
    
    func circularSlider(_ slider: MSCircularSlider, revolutionsChangedTo value: Int) {
        currentRevolutions = value
        valueLbl.text = String(format: "%.1f\nx%d", currentValue, currentRevolutions + 1)
    }
    
    
    
    func animateSlider() {
        animationTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateSliderValue), userInfo: nil, repeats: true)
    }
    
    @objc func updateSliderValue() {
        slider.currentValue += animationReversed ? -1.0 : 1.0
        
        if slider.currentValue >= slider.maximumValue {
            animationTimer?.invalidate()
            // Reverse animation
            animationReversed = true
            animationTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateSliderValue), userInfo: nil, repeats: true)
        }
        else if slider.currentValue <= slider.minimumValue && animationReversed {
            // Animation ended
            animationTimer?.invalidate()
        }
    }
    
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        valueLbl.text = "\(timeFormatted(Int(totalTime)))"
        
        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
        }
    }
    
    func endTimer() {
        countdownTimer.invalidate()
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    
    @IBAction func startTimerPressed(_ sender: UIButton) {
        //biometric
        let context: LAContext = LAContext()
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Message") {
                (good,error) in
                
                if good {
                    print("Nice!")
                }else {
                    print("Try again")
                }
            }
        }
        totalTime = slider.currentValue * 60
        startTimer()
    }

}

