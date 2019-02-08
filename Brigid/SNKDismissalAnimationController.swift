//
//  SNKDismissalAnimationController.swift
//  Brigid
//
//  Created by Stephen Work on 07/02/2019.
//  Copyright © 2019 Stephen Walsh. All rights reserved.
//

import UIKit

final class SNKDismissalAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
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
        guard let fromVC = transitionContext.viewController(forKey: .from)
            else {
                return
        }
        
        fromVC.view.transform = .identity
        fromVC.view.alpha = 1.0
        
        let containerView = transitionContext.containerView
        containerView.addSubview(fromVC.view)
        
        let duration = transitionDuration(using: transitionContext)
        let options = animationOptions(for: transitionContext)
        
        (fromVC as? SNKDismissable)?.willBeginDismissalAnimation()
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: options,
                       animations: {
                        fromVC.view.alpha = self.type.endingAlpha
                        fromVC.view.transform = self.type.endingTransform(for: fromVC.view)
                        
                        (fromVC as? SNKDismissable)?.didEndDismissalAnimation()
        }) { _ in
            if !transitionContext.transitionWasCancelled {
                fromVC.view.removeFromSuperview()
            }
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    private func animationOptions(for context: UIViewControllerContextTransitioning) -> UIView.AnimationOptions {
        return context.isInteractive ? .curveLinear : .curveEaseInOut
    }
}

private extension SNKTransitionType {
    
    var endingAlpha: CGFloat {
        switch self {
        case .fromTop, .fromBottom:
            return 0.8
        case .fromLeft, .fromRight:
            return 0.26
        }
    }
    
    func endingTransform(for view: UIView) -> CGAffineTransform {
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
