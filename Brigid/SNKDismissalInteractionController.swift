//
//  SNKDismissalInteractionController.swift
//  Brigid
//
//  Created by Stephen Walsh on 07/02/2019.
//  Copyright © 2019 Stephen Walsh. All rights reserved.
//

import UIKit

final class SNKDismissalInteractionController: UIPercentDrivenInteractiveTransition {
    
    var interactionInProgress = false
    private var shouldCompleteTransition = false
    
    private let transitionType: SNKTransitionType
    private weak var viewController: SNKViewController?
    
    init(transitionType: SNKTransitionType,
         viewController: SNKViewController?) {
        self.transitionType = transitionType
        self.viewController = viewController
        
        super.init()
        
        prepareGestureRecognizers()
    }
    
    private func prepareGestureRecognizers() {
        guard let view = viewController?.presentationGestureHandleView(forTransitionType: transitionType) ?? viewController?.view else { return }
        let gesture = createGestureRecognizer(forTransitionType: transitionType)
        view.addGestureRecognizer(gesture)
    }
    
    private func createGestureRecognizer(forTransitionType transitionType: SNKTransitionType) -> UIGestureRecognizer {
        switch transitionType {
        default:
            let gesture = UIScreenEdgePanGestureRecognizer(target: self,
                                                           action: #selector(handleGesture(gestureRecognizer:)))
            gesture.edges = transitionType.edge
            
            return gesture
        }
    }
    
    @objc
    private func handleGesture(gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        
        guard let viewController = viewController,
            let gestureView = gestureRecognizer.view?.superview else { return }
        
        let translation = gestureRecognizer.translation(in: gestureView)
        let progress = calculateProgress(for: translation)
        
        switch gestureRecognizer.state {
        case .began:
            interactionInProgress = true
            viewController.dismiss(animated: true, completion: nil)
        case .changed:
            shouldCompleteTransition = progress > transitionType.progressNeededForCompletion
            update(progress)
        case .cancelled, .ended:
            interactionInProgress = false
            if shouldCompleteTransition {
                finish()
            } else {
                cancel()
            }
        case .possible, .failed:
            break
        }
    }
    
    private func calculateProgress(for translation: CGPoint) -> CGFloat {
        
        switch transitionType {
        case .fromLeft, .fromRight:
            let screenWidth = viewController?.view.frame.width ?? UIScreen.main.bounds.width
            let progress = abs(translation.x / screenWidth)
            return CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        case .fromTop, .fromBottom:
            let screenHeight = viewController?.view.frame.height ?? UIScreen.main.bounds.height
            let progress = abs(translation.y / screenHeight)
            return CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        }
    }
}

private extension SNKTransitionType {
    
    var edge: UIRectEdge {
        switch self {
        case .fromTop:
            return .bottom
        case .fromLeft:
            return .right
        case .fromBottom:
            return .top
        case .fromRight:
            return .left
        }
    }
    
    var progressNeededForCompletion: CGFloat {
        switch self {
        case .fromLeft, .fromRight:
            return 0.26
        case .fromTop, .fromBottom:
            return 0.3
        }
    }
}
