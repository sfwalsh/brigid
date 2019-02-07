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

final class SwipeableTransitionCoordinator {
    
    private var topTransitionController: TransitionController?
    private var leftTransitionController: TransitionController?
    private var bottomTransitionController: TransitionController?
    private var rightTransitionController: TransitionController?
    
    weak var sourceViewController: UIViewController?
}

extension SwipeableTransitionCoordinator {
    
    func addDestinationViewController(destinationViewController: UIViewController,
                                      forTransitionType transitionType: TransitionType) {
        switch transitionType {
        case .fromTop:
            self.topTransitionController = TransitionController(with: transitionType,
                                                                from: sourceViewController,
                                                                to: destinationViewController)
        case .fromLeft:
            self.leftTransitionController = TransitionController(with: transitionType,
                                                                 from: sourceViewController,
                                                                 to: destinationViewController)
        case .fromBottom:
            self.bottomTransitionController = TransitionController(with: transitionType,
                                                                   from: sourceViewController,
                                                                   to: destinationViewController)
        case .fromRight:
            self.rightTransitionController = TransitionController(with: transitionType,
                                                                  from: sourceViewController,
                                                                  to: destinationViewController)
        }
    }
}

final class TransitionController: NSObject, UIViewControllerTransitioningDelegate {
    
    private let transitionType: TransitionType
    private weak var sourceViewController: UIViewController?
    private weak var destinationViewController: UIViewController?
    private let swipeInteractionController: SwipeInteractionController
    
    init(with transitionType: TransitionType,
         from sourceViewController: UIViewController?,
         to destinationViewController: UIViewController?) {
        self.transitionType = transitionType
        self.sourceViewController = sourceViewController
        self.destinationViewController = destinationViewController
        self.swipeInteractionController = SwipeInteractionController(transitionType: transitionType,
                                                                     sourceViewController: sourceViewController,
                                                                     destinationViewController: destinationViewController)
        
        super.init()
        
        destinationViewController?.modalPresentationStyle = .overCurrentContext
        destinationViewController?.transitioningDelegate = self
    }
}


// MARK: UIViewControllerTransitioningDelegate Implementations

extension TransitionController {
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimationController(type: transitionType)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimationController(type: transitionType)
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return swipeInteractionController.interactionInProgress ? swipeInteractionController : nil
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return swipeInteractionController
    }
}
