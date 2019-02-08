//
//  SwipeInteractionController.swift
//  Brigid
//
//  Created by Stephen Walsh on 05/02/2019.
//  Copyright © 2019 Stephen Walsh. All rights reserved.
//

import UIKit

final class SNKPresentationInteractionController: UIPercentDrivenInteractiveTransition {
    
    var interactionInProgress = false
    private var shouldCompleteTransition = false
    
    private let transitionType: SNKTransitionType
    private weak var viewController: SNKPresentableViewController?
    private weak var destinationViewController: SNKViewController?
    
    init(transitionType: SNKTransitionType,
         viewController: SNKPresentableViewController?,
         destinationViewController: SNKViewController?) {
        self.transitionType = transitionType
        self.viewController = viewController
        self.destinationViewController = destinationViewController
        
        super.init()
        
        prepareGestureRecognizers()
    }
    
    private func prepareGestureRecognizers() {
        guard let view = viewController?.presentationGestureListenerView(forTransitionType: transitionType) ?? viewController?.view else { return }
        let gesture = createGestureRecognizer(forTransitionType: transitionType)
        view.addGestureRecognizer(gesture)
    }
    
    private func createGestureRecognizer(forTransitionType transitionType: SNKTransitionType) -> UIPanGestureRecognizer {
        
        switch transitionType {
        case .fromLeft, .fromRight:
            let gesture = UIScreenEdgePanGestureRecognizer(target: self,
                                                           action: #selector(handleGesture(gestureRecognizer:)))
            gesture.edges = transitionType.edge
            return gesture
        case .fromTop, .fromBottom:
            let gesture = UIPanGestureRecognizer(target: self,
                                                 action: #selector(handleGesture(gestureRecognizer:)))
            return gesture
        }
    }

    @objc
    private func handleGesture(gestureRecognizer: UIPanGestureRecognizer) {
        
        guard let sourceView = viewController,
            let destinationView = destinationViewController,
            let gestureView = gestureRecognizer.view?.superview else { return }
        
        let translation = gestureRecognizer.translation(in: gestureView)
        let progress = calculateProgress(for: translation)
        
        switch gestureRecognizer.state {
        case .began:
            interactionInProgress = true
            sourceView.present(destinationView, animated: true, completion: nil)
        case .changed:
            shouldCompleteTransition = progress > transitionType.progressNeededForCompletion
            updateListenerViewTransform(for: translation)
            update(progress)
        case .cancelled, .ended:
            interactionInProgress = false
            resetListenerViewTransform()
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

// MARK: Handle View Updating

extension SNKPresentationInteractionController {
    
    private func updateListenerViewTransform(for translation: CGPoint) {
        switch transitionType {
        case .fromLeft, .fromRight:
            viewController?.presentationGestureListenerView(forTransitionType: transitionType)?.transform = CGAffineTransform(translationX: translation.x,
                                                                                                                                    y: 0)
        case .fromTop, .fromBottom:
            viewController?.presentationGestureListenerView(forTransitionType: transitionType)?.transform = CGAffineTransform(translationX: 0,
                                                                                                                                    y: translation.y)
        }
    }
    
    private func resetListenerViewTransform() {
        viewController?.presentationGestureListenerView(forTransitionType: transitionType)?.transform = .identity
    }
}

private extension SNKTransitionType {
    
    var edge: UIRectEdge {
        switch self {
        case .fromTop:
            return .top
        case .fromLeft:
            return .left
        case .fromBottom:
            return .bottom
        case .fromRight:
            return .right
        }
    }
    
    var progressNeededForCompletion: CGFloat {
        switch self {
        case .fromLeft, .fromRight:
            return 0.5
        case .fromTop, .fromBottom:
            return 0.3
        }
    }
}
