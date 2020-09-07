//
//  UIViewControllerExt.swift
//  goalpost
//
//  Created by Penny on 31/8/20.
//  Copyright © 2020 Penny. All rights reserved.
//

import UIKit

// We are overriding the default animation when you present a view controller
extension UIViewController {
    
    func presentDetail(_ viewControllerToPresent : UIViewController) {
        
        // CA = Core Animation
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        
        // Set the layer for this view controller to have this transition
        self.view.window?.layer.add(transition, forKey: kCATransition)
        
        // Now we need to present the view controller.
        // Note that animation is set to false, because we are overriding the default
        // animation.
        viewControllerToPresent.modalPresentationStyle = .fullScreen
        present(viewControllerToPresent, animated: false, completion: nil)
        
    }//presentDetail
    
    
    func presentSecondaryDetail(_ viewControllerToPresent : UIViewController) {
        
        // CA = Core Animation
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        
        // Grab a hold of current VC so that we can dismiss it.
        guard let presentedViewController = presentedViewController else { return }
        
        // Here we are dismissing the current VC (animation is false because we
        // are overriding it with our own transition) AND instead of passing through
        // nil for the completion function, we are adding in the code to present the
        // new VC.
        presentedViewController.dismiss(animated: false) {
            // Set the layer for this view controller to have this transition
            self.view.window?.layer.add(transition, forKey: kCATransition)
            viewControllerToPresent.modalPresentationStyle = .fullScreen
            self.present(viewControllerToPresent, animated: false, completion: nil)
        }
                
    }//presentSecondaryDetail
    
    
    
    func dismissDetail() {
        
        // CA = Core Animation
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        
        // Set the layer for this view controller to have this transition
        self.view.window?.layer.add(transition, forKey: kCATransition)
        
        // Now we need to dismiss the view controller.
        // Note that animation is set to false, because we are overriding the default
        // animation.
        dismiss(animated: false, completion: nil)
        
    }//dismissDetail
    
    
    
    
}//extension
