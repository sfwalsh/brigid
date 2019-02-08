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
    private weak var listenerView: UIView?
    
    private let presentationInteractionController: SNKInteractionController
    private let dismissalInteractionController: SNKInteractionController
    
    init(with transitionType: SNKTransitionType,
         from sourceViewController: SNKPresentableViewController?,
         to destinationViewController: SNKViewController?) {
        self.transitionType = transitionType
        self.sourceViewController = sourceViewController
        self.destinationViewController = destinationViewController

        let presentationGestureView = SNKTransitionController.presentationGestureView(for: sourceViewController,
                                                                          transitionType: transitionType)
        let shouldTransformPresentationGestureView = SNKTransitionController.shouldTransformPresentationGestureView(for: sourceViewController,
                                                                                                        transitionType: transitionType)
        
        let dismissalGestureView = SNKTransitionController.dismissalGestureView(for: destinationViewController,
                                                                                transitionType: transitionType)
        
        self.presentationInteractionController = SNKInteractionController(transitionType: transitionType,
                                                                          transitionContext: SNKTransitionContext.presentation(sourceViewController: sourceViewController, destinationViewController: destinationViewController),
                                                                          gestureView: presentationGestureView,
                                                                          transformsGestureView: shouldTransformPresentationGestureView)
        
        self.dismissalInteractionController = SNKInteractionController(transitionType: transitionType,
                                                                       transitionContext: SNKTransitionContext.dismissal(viewController: destinationViewController),
                                                                       gestureView: dismissalGestureView,
                                                                       transformsGestureView: false)
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


// MARK: Static Helpers

extension SNKTransitionController {
    
    private static func presentationGestureView(for presentable: SNKPresentableViewController?, transitionType: SNKTransitionType) -> UIView? {
        if let handleView = presentable?.presentationGestureHandleView(forTransitionType: transitionType) {
            return handleView
        }
        
        return presentable?.view
    }
    
    private static func shouldTransformPresentationGestureView(for presentable: SNKPresentable?, transitionType: SNKTransitionType) -> Bool {
        if let _ = presentable?.presentationGestureHandleView(forTransitionType: transitionType) {
            return true
        }
        
        return false
    }
    
    private static func dismissalGestureView(for dismissable: SNKDismissableViewController?, transitionType: SNKTransitionType) -> UIView? {
        if let handleView = dismissable?.dismissalGestureHandleView(forTransitionType: transitionType) {
            return handleView
        }
        
        return dismissable?.view
    }
}
