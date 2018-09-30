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

}

// MARK: - UIView Extension
extension UIView{
   
}

