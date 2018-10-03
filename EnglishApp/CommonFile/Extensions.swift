//
//  Extensions.swift
//  EnglishApp
//
//  Created by Nguyen Van Trung on 9/29/18.
//  Copyright © 2018 Nguyen Van Trung. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Buttons Extension
extension UIButton{
    func buzz() {
        let buzz = CABasicAnimation(keyPath: "position")
        buzz.duration = 0.1
        buzz.repeatCount = 2
        buzz.autoreverses = true
        
        let fromPoint = CGPoint(x: center.x - 5, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: center.x + 5, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        
        buzz.fromValue = fromValue
        buzz.toValue = toValue
        
        layer.add(buzz, forKey: nil)
    }
    
    func nhayLonBe() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.6
        pulse.fromValue = 1
        pulse.toValue = 1.2
        pulse.autoreverses = false
//        pulse.repeatCount = 1
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        layer.add(pulse, forKey: nil)
    }
    
    @objc func touchOnButton(sender : UITapGestureRecognizer) {
        let myEffectView = UIView(frame: CGRect(x: sender.location(in: self).x, y: sender.location(in: self).y, width: 15, height: 15))
        myEffectView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        myEffectView.alpha = 0.5
        myEffectView.layer.cornerRadius = myEffectView.frame.height / 2
        myEffectView.clipsToBounds = true
        self.addSubview(myEffectView)
        UIView.animate(withDuration: 0.5, animations: {
            myEffectView.transform = CGAffineTransform.init(scaleX: 10, y: 10)
            myEffectView.alpha = 0.1
        }) { (isFinish) in
            myEffectView.removeFromSuperview()
        }
        self.sendActions(for: .allEvents)
    }

    func addEffect() {
        self.clipsToBounds = true
        self.adjustsImageWhenDisabled = false
        self.adjustsImageWhenHighlighted = false
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.touchOnButton))
        self.addGestureRecognizer(gesture)
    }
}

// MARK: - UIView Extension
extension UIView{
   
}

