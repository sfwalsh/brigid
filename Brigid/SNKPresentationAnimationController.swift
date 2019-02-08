//
//  SNKPresentationAnimationController.swift
//  Brigid
//
//  Created by Stephen Walsh on 05/02/2019.
//  Copyright © 2019 Stephen Walsh. All rights reserved.
//

import UIKit

final class SNKPresentationAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    private enum Defaults {
        static let transitionDuration: Double = 0.5
    }
    
    private let type: SNKTransitionType
    private let transitionDuration: Double
    
    convenience init(type: SNKTransitionType) {
        self.init(type: type, transitionDuration: Defaults.transitionDuration)
    }
    
    init(type: SNKTransitionType,
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
        
        (toVC as? SNKPresentable)?.willBeginPresentationAnimation()
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: options,
                       animations: {
                        toVC.view.alpha = 1.0
                        toVC.view.transform = CGAffineTransform.identity
                        (toVC as? SNKPresentable)?.didEndPresentationAnimation()
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

private extension SNKTransitionType {
    
    var startingAlpha: CGFloat {
        switch self {
        case .fromTop, .fromBottom:
            return 0.8
        case .fromLeft, .fromRight:
            return 0.8
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
