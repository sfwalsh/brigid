//
//  AnimationController.swift
//  Brigid
//
//  Created by Stephen Walsh on 05/02/2019.
//  Copyright © 2019 Stephen Walsh. All rights reserved.
//

import UIKit

final class AnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    private enum Defaults {
        static let transitionDuration: Double = 0.5
    }
    
    private let type: TransitionType
    private let transitionDuration: Double
    
    convenience init(type: TransitionType) {
        self.init(type: type, transitionDuration: Defaults.transitionDuration)
    }
    
    init(type: TransitionType,
         transitionDuration: Double) {
        self.type = type
        self.transitionDuration = transitionDuration
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to)
            else {
                return
        }
        
        toVC.view.transform = type.startingTransform(for: toVC.view)
        toVC.view.alpha = type.startingAlpha
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)
        
        let duration = transitionDuration(using: transitionContext)
        let options = animationOptions(for: transitionContext)
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: options,
                       animations: {
                        toVC.view.alpha = 1.0
                        toVC.view.transform = CGAffineTransform.identity
        }) { _ in
            if transitionContext.transitionWasCancelled {
                toVC.view.removeFromSuperview()
            }
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    private func animationOptions(for context: UIViewControllerContextTransitioning) -> UIView.AnimationOptions {
        return context.isInteractive ? .curveLinear : .curveEaseInOut
    }
}

private extension TransitionType {
    
    var startingAlpha: CGFloat {
        switch self {
        case .fromTop, .fromBottom:
            return 0.8
        case .fromLeft, .fromRight:
            return 0.26
        }
    }
    
    func startingTransform(for view: UIView) -> CGAffineTransform {
        switch self {
        case .fromTop:
            return CGAffineTransform(translationX: 0, y: -view.frame.height)
        case .fromLeft:
            return CGAffineTransform(translationX: -view.frame.width, y: 0)
        case .fromBottom:
            return CGAffineTransform(translationX: 0, y: view.frame.height)
        case .fromRight:
            return CGAffineTransform(translationX: view.frame.width, y: 0)
        }
    }
}
