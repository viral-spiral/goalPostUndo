//
//  UIViewExt.swift
//  goalpost
//
//  Created by Penny on 31/8/20.
//  Copyright © 2020 Penny. All rights reserved.
//

import UIKit

extension UIView {
    
    // Absolutely no friggin' idea what's going on here. I'm sure there's
    // a better way to attach a button to the keyboard.
    
    func bindToKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(UIView.keyboardWillChange(_:)), name: UIApplication.keyboardWillChangeFrameNotification, object: nil)
    }//bindToKeyboard
    
    @objc func keyboardWillChange(_ notification : NSNotification) {
        
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        let startingFrame = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let endingFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = endingFrame.origin.y - startingFrame.origin.y
        
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: KeyframeAnimationOptions.init(rawValue: curve), animations: { self.frame.origin.y += deltaY }, completion: nil)
        
    }//keyboardWillChange
    
    
}//extension
