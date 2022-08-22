//
//  CustomViewTransition.swift
//  JTChat
//
//  Created by Evgeny on 05.05.2022.
//

import UIKit

class CustomViewTransition: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        1.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else {
            return
        }
        let containerView = transitionContext.containerView
        toView.alpha = 0
        containerView.addSubview(toView)
        
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0) {
            toView.alpha = 1
        } completion: { _ in
            transitionContext.completeTransition(true)
        }
    }
}
