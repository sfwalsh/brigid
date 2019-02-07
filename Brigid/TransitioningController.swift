//
//  TransitioningController.swift
//  Brigid
//
//  Created by Stephen Walsh on 06/02/2019.
//  Copyright © 2019 Stephen Walsh. All rights reserved.
//

import UIKit

enum TransitionType {
    case fromTop, fromLeft, fromBottom, fromRight
}

final class TransitioningController: NSObject, SwipeInteractionControllerDelegate {
    
    private let type: TransitionType
    internal let sourceViewController: UIViewController
    internal let destinationViewController: UIViewController
    private let swipeInteractionController: SwipeInteractionController
    
    init(type: TransitionType,
         sourceViewController: UIViewController,
         destinationViewController: UIViewController) {
        self.type = type
        self.sourceViewController = sourceViewController
        self.destinationViewController = destinationViewController
        self.swipeInteractionController = SwipeInteractionController(transitionType: type)
        
        super.init()
        destinationViewController.transitioningDelegate = self
        swipeInteractionController.setDelegate(to: self)
    }
}


// MARK: UIViewControllerTransitioningDelegate Implementations

extension TransitioningController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimationController(type: type)
    }
    
    //    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    ////        return AnimationController(destinationFrame: dismissed.view.frame,
    ////                                   interactionController: swipeInteractionController)
    //    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return swipeInteractionController
    }
    
    //    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    ////        return swipeInteractionController
    //    }}
}
