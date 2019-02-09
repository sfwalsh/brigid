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
    private let context: SNKInteractionContext
    
    init(transitionContext: SNKInteractionContext) {
        self.context = transitionContext
        super.init()
        
        prepareGestureRecognizers()
    }
    
    private func prepareGestureRecognizers() {
        guard let view = context.gestureView else { return }
        let gesture = createGestureRecognizer(forContext: context)
        view.addGestureRecognizer(gesture)
    }
    
    private func createGestureRecognizer(forContext context: SNKInteractionContext) -> UIPanGestureRecognizer {
        
        switch context.transitionType {
        case .fromLeft, .fromRight:
            let gesture = UIScreenEdgePanGestureRecognizer(target: self,
                                                           action: #selector(handleGesture(gestureRecognizer:)))
            gesture.edges = context.activeEdge
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
            guard isCorrectDirection(forTranslation: translation) else {
                cancel()
                return
            }
            shouldCompleteTransition = progress > context.progressNeededForCompletion
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
        switch context.action {
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
        guard context.transformsGestureView else { return }
        switch context.transitionType {
        case .fromLeft, .fromRight:
            context.gestureView?.transform = CGAffineTransform(translationX: translation.x, y: 0)
        case .fromTop, .fromBottom:
            context.gestureView?.transform = CGAffineTransform(translationX: 0, y: translation.y)
        }
    }
    
    private func resetGestureViewTransform() {
        guard context.transformsGestureView else { return }
        context.gestureView?.transform = .identity
    }
}

// MARK: Helpers

extension SNKInteractionController {
    
    private func calculateProgress(for translation: CGPoint) -> CGFloat {
        switch context.transitionType {
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
    
    private func isCorrectDirection(forTranslation translation: CGPoint) -> Bool {
        switch (context.transitionType, context.action) {
        case (.fromLeft, .presentation):
            return translation.x > 0
        case (.fromRight, .presentation):
            return translation.x < 0
        case (.fromBottom, .presentation):
            return translation.y < 0
        case (.fromTop, .presentation):
            return translation.y > 0
        case (.fromLeft, .dismissal):
            return translation.x < 0
        case (.fromRight, .dismissal):
            return translation.x > 0
        case (.fromBottom, .dismissal):
            return translation.y > 0
        case (.fromTop, .dismissal):
            return translation.y < 0
        }
    }
}
