//
//  SNKTransitionController.swift
//  Brigid
//
//  Created by Stephen Work on 08/02/2019.
//  Copyright © 2019 Stephen Walsh. All rights reserved.
//

import UIKit

final class SNKTransitionController: NSObject, UIViewControllerTransitioningDelegate {
    
    private let transitionType: SNKTransitionType
    private weak var sourceViewController: SNKPresentableViewController?
    private weak var destinationViewController: SNKViewController?
    private weak var listenerView: UIView?
    
    private let presentationInteractionController: SNKPresentationInteractionController
    private let dismissalInteractionController: SNKDismissalInteractionController
    
    init(with transitionType: SNKTransitionType,
         from sourceViewController: SNKPresentableViewController?,
         to destinationViewController: SNKViewController?) {
        self.transitionType = transitionType
        self.sourceViewController = sourceViewController
        self.destinationViewController = destinationViewController

        self.presentationInteractionController = SNKPresentationInteractionController(transitionType: transitionType,
                                                                                      viewController: sourceViewController,
                                                                               destinationViewController: destinationViewController)
        
        self.dismissalInteractionController = SNKDismissalInteractionController(transitionType: transitionType,
                                                                                viewController: destinationViewController)
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
