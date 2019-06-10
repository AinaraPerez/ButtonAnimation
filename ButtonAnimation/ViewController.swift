//
//  ViewController.swift
//  ButtonAnimation
//
//  Created by Ainara Perez on 29/3/19.
//  Copyright © 2019 Ainara Perez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var buttonTap: UIButton!
    @IBOutlet weak var buttonPulsate: UIButton!
    @IBOutlet weak var buttonShake: UIButton!
    @IBOutlet weak var buttonRotation: UIButton!
    @IBOutlet weak var buttonVibrate: UIButton!
    
    var btIsVibrating = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeView()
    }
    
    func customizeView() {
        customButton(button: buttonTap)
        customButton(button: buttonPulsate)
        customButton(button: buttonShake)
        customButton(button: buttonRotation)
        customButton(button: buttonVibrate)
    }

    func customButton(button: UIButton) {
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @IBAction func btTapAction(_ sender: Any) {
        UIView.animate(withDuration: 0.2, delay: 0.1, options: [], animations: { self.buttonTap.transform = CGAffineTransform(scaleX: 2, y: 2)})
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: { self.buttonTap.transform = CGAffineTransform.identity})
    }
    
    @IBAction func btPulsateAction(_ sender: Any) {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 1
        pulse.fromValue = 1
        pulse.toValue = 0.90
        pulse.autoreverses = true
        pulse.repeatCount = 1
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        
        buttonPulsate.layer.add(pulse, forKey: "pulsate")
    }
    
    @IBAction func btShakeAction(_ sender: Any) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.06
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: buttonShake.center.x - 10, y: buttonShake.center.y)
        animation.toValue = CGPoint(x: buttonShake.center.x + 10, y: buttonShake.center.y)
        buttonShake.layer.add(animation, forKey: "position")
    }
    
    @IBAction func btRotationAction(_ sender: Any) {
        UIView.animate(withDuration: 1, delay: 0, options: [], animations: {self.buttonRotation.transform = CGAffineTransform(rotationAngle: CGFloat.pi)})
        UIView.animate(withDuration: 1, delay: 0, options: [], animations: {self.buttonRotation.transform = CGAffineTransform.identity})
    }
    
    @IBAction func btVibrateAction(_ sender: Any) {
        if btIsVibrating == false {
            btIsVibrating = true
            buttonVibrate.setTitle("Stop", for: .normal)
            CATransaction.begin()
            CATransaction.setDisableActions(false)
            self.buttonVibrate.layer.add(self.rotationAnimation(), forKey: "rotation")
            self.buttonVibrate.layer.add(self.bounceAnimation(), forKey: "bounce")
            CATransaction.commit()
        } else {
            btIsVibrating = false
            buttonVibrate.setTitle("Vibrate", for: .normal)
            buttonVibrate.layer.removeAllAnimations()
        }
    }
    
    //Vibrate functions
    func rotationAnimation() -> CAKeyframeAnimation {
        let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        let angle = CGFloat(0.03)
        let duration = TimeInterval(0.1)
        let variance = Double(0.025)
        animation.values = [angle, -angle]
        animation.autoreverses = true
        animation.duration = self.randomize(duration, withVariance: variance)
        animation.repeatCount = Float.infinity
        return animation
    }
    
    func bounceAnimation() -> CAKeyframeAnimation {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        let bounce = CGFloat(1.0)
        let duration = TimeInterval(0.12)
        let variance = Double(0.025)
        animation.values = [bounce, -bounce]
        animation.autoreverses = true
        animation.duration = self.randomize(duration, withVariance: variance)
        animation.repeatCount = Float.infinity
        return animation
    }
    
    func randomize(_ interval: TimeInterval, withVariance variance:Double) -> TimeInterval {
        let random = (Double(arc4random_uniform(1000)) - 500.0) / 500.0
        return interval + variance * random;
    }
}

