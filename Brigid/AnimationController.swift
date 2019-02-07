//
//  AnimationController.swift
//  Brigid
//
//  Created by Stephen Walsh on 05/02/2019.
//  Copyright © 2019 Stephen Walsh. All rights reserved.
//

import UIKit

struct AnimationHelper {
    static func yRotation(_ angle: Double) -> CATransform3D {
        return CATransform3DMakeRotation(CGFloat(angle), 0.0, 1.0, 0.0)
    }
    
    static func perspectiveTransform(for containerView: UIView) {
        var transform = CATransform3DIdentity
        transform.m34 = -0.026
        containerView.layer.transform = transform
    }
}

final class AnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    private enum Defaults {
        static let transitionDuration: Double = 0.6
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
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
            else {
                return
        }
        
        
        toVC.view.transform = type.startingTransform(for: toVC.view)
        toVC.view.alpha = 0.0
        
        let containerView = transitionContext.containerView
        containerView.insertSubview(toVC.view, at: 0)
        
        AnimationHelper.perspectiveTransform(for: fromVC.view)
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: .calculationModeCubic,
            animations: {
                
                // MARK: Alpha

                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1/6) {
                    toVC.view.alpha = 0.52
                }
                
                UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 1/3) {
                    toVC.view.alpha = 1.0
                }
                
                // MARK: Translation
                
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                    toVC.view.transform = CGAffineTransform.identity
                })
        },
            completion: { _ in
                if transitionContext.transitionWasCancelled {
                    toVC.view.removeFromSuperview()
                }
                
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

private extension TransitionType {
    
    func startingTransform(for view: UIView) -> CGAffineTransform {
        switch self {
        case .fromTop:
            return .identity
        case .fromLeft:
            return CGAffineTransform(translationX: -view.frame.width, y: 0)
        case .fromBottom:
            return .identity
        case .fromRight:
            return CGAffineTransform(translationX: view.frame.width * 2, y: 0)
        }
    }
}
