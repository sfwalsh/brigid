//
//  SNKTransitionController.swift
//  Brigid
//
//  Created by Stephen Walsh on 08/02/2019.
//  Copyright © 2019 Stephen Walsh. All rights reserved.
//

import UIKit

final class SNKTransitionController: NSObject, UIViewControllerTransitioningDelegate {
    
    private let transitionType: SNKTransitionType
    private weak var sourceViewController: SNKPresentableViewController?
    private weak var destinationViewController: SNKViewController?
    
    private let presentationInteractionController: SNKInteractionController
    private let dismissalInteractionController: SNKInteractionController
    
    init(with transitionType: SNKTransitionType,
         from sourceViewController: SNKPresentableViewController?,
         to destinationViewController: SNKViewController?) {
        self.transitionType = transitionType
        self.sourceViewController = sourceViewController
        self.destinationViewController = destinationViewController
        
        let presentationTransitionContext = SNKInteractionContext.PresentationContext(sourceViewController: sourceViewController,
                                                                         destinationViewController: destinationViewController,
                                                                         transitionType: transitionType)
        
        self.presentationInteractionController = SNKInteractionController(transitionContext: presentationTransitionContext)
        
        let dismissalTransitionContext = SNKInteractionContext.DismissalContext(viewController: destinationViewController,
                                                                               transitionType: transitionType)
        
        self.dismissalInteractionController = SNKInteractionController(transitionContext: dismissalTransitionContext)
        super.init()
        
        destinationViewController?.modalPresentationStyle = .overCurrentContext
        destinationViewController?.transitioningDelegate = self
    }
}


// MARK: UIViewControllerTransitioningDelegate Implementations

extension SNKTransitionController {
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SNKPresentationAnimationController(type: transitionType)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SNKDismissalAnimationController(type: transitionType)
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return presentationInteractionController.interactionInProgress ? presentationInteractionController : nil
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return dismissalInteractionController.interactionInProgress ? dismissalInteractionController : nil
    }
}
