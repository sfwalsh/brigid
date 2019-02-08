//
//  SNKInteractionController.swift
//  Brigid
//
//  Created by Stephen Walsh on 07/02/2019.
//  Copyright © 2019 Stephen Walsh. All rights reserved.
//

import UIKit

final class SNKInteractionController: UIPercentDrivenInteractiveTransition {
    
    var interactionInProgress = false
    private var shouldCompleteTransition = false
    
    private let transitionContext: SNKTransitionContext
    private let transitionType: SNKTransitionType
    private weak var gestureView: UIView?
    private let transformsGestureView: Bool
    
    init(transitionType: SNKTransitionType,
         transitionContext: SNKTransitionContext,
         gestureView: UIView?,
         transformsGestureView: Bool) {
        self.transitionType = transitionType
        self.transitionContext = transitionContext
        self.gestureView = gestureView
        self.transformsGestureView = transformsGestureView
        
        super.init()
        
        prepareGestureRecognizers()
    }
    
    private func prepareGestureRecognizers() {
        guard let view = gestureView else { return }
        let gesture = createGestureRecognizer(forTransitionType: transitionType)
        view.addGestureRecognizer(gesture)
    }
    
    private func createGestureRecognizer(forTransitionType transitionType: SNKTransitionType) -> UIPanGestureRecognizer {
        
        switch transitionType {
        case .fromLeft, .fromRight:
            let gesture = UIScreenEdgePanGestureRecognizer(target: self,
                                                           action: #selector(handleGesture(gestureRecognizer:)))
            let edge = transitionType.activeEdge(forContext: transitionContext)
            gesture.edges = edge
            return gesture
        case .fromTop, .fromBottom:
            let gesture = UIPanGestureRecognizer(target: self,
                                                 action: #selector(handleGesture(gestureRecognizer:)))
            return gesture
        }
    }
    
    @objc
    private func handleGesture(gestureRecognizer: UIPanGestureRecognizer) {

        guard let gestureContainerView = gestureRecognizer.view?.superview else { return }
        
        let translation = gestureRecognizer.translation(in: gestureContainerView)
        let progress = calculateProgress(for: translation)
        
        switch gestureRecognizer.state {
        case .began:
            interactionInProgress = true
            performContextAction()
        case .changed:
            let progressThreshold = transitionType.progressNeededForCompletion(forContext: transitionContext)
            shouldCompleteTransition = progress > progressThreshold
            updateGestureViewTransform(for: translation)
            update(progress)
        case .cancelled, .ended:
            interactionInProgress = false
            resetGestureViewTransform()
            if shouldCompleteTransition {
                finish()
            } else {
                cancel()
            }
        case .possible, .failed:
            break
        }
    }
}

// MARK: Actions

extension SNKInteractionController {
    
    private func performContextAction() {
        switch transitionContext {
        case .presentation(let sourceViewController, let destinationViewController):
            guard let destinationViewController = destinationViewController else { return }
            sourceViewController?.present(destinationViewController, animated: true, completion: nil)
        case .dismissal(let viewController):
            viewController?.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: Handle View Updating

extension SNKInteractionController {
    
    private func updateGestureViewTransform(for translation: CGPoint) {
        guard transformsGestureView else { return }
        switch transitionType {
        case .fromLeft, .fromRight:
            gestureView?.transform = CGAffineTransform(translationX: translation.x, y: 0)
        case .fromTop, .fromBottom:
            gestureView?.transform = CGAffineTransform(translationX: 0, y: translation.y)
        }
    }
    
    private func resetGestureViewTransform() {
        guard transformsGestureView else { return }
        gestureView?.transform = .identity
    }
}

// MARK: Helpers

extension SNKInteractionController {
    
    private func calculateProgress(for translation: CGPoint) -> CGFloat {
        switch transitionType {
        case .fromLeft, .fromRight:
            let screenWidth = UIScreen.main.bounds.width
            let progress = abs(translation.x / screenWidth)
            return CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        case .fromTop, .fromBottom:
            let screenHeight = UIScreen.main.bounds.height
            let progress = abs(translation.y / screenHeight)
            return CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        }
    }
}

private extension SNKTransitionType {
    
    func activeEdge(forContext transitionContext: SNKTransitionContext) -> UIRectEdge {
        switch (self, transitionContext) {
        case (.fromTop, .presentation):
            return .top
        case (.fromLeft, .presentation):
            return .left
        case (.fromBottom, .presentation):
            return .bottom
        case (.fromRight, .presentation):
            return .right
        case (.fromTop, .dismissal):
            return .bottom
        case (.fromLeft, .dismissal):
            return .right
        case (.fromBottom, .dismissal):
            return .top
        case (.fromRight, .dismissal):
            return .left
        }
    }
    
    func progressNeededForCompletion(forContext transitionContext: SNKTransitionContext) -> CGFloat {
        switch (self, transitionContext) {
        case (.fromLeft, .presentation), (.fromRight, .presentation):
            return 0.5
        case (.fromLeft, .dismissal), (.fromRight, .dismissal):
            return 0.26
        default:
            return 0.3
        }
    }
}
