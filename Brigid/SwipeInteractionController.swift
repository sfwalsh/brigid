//
//  SwipeInteractionController.swift
//  Brigid
//
//  Created by Stephen Walsh on 05/02/2019.
//  Copyright © 2019 Stephen Walsh. All rights reserved.
//

import UIKit

protocol SwipeInteractionControllerDelegate: class {
    var sourceViewController: UIViewController { get }
    var destinationViewController: UIViewController { get }
}

final class SwipeInteractionController: UIPercentDrivenInteractiveTransition {
    
    private var interactionInProgress = false
    private var shouldCompleteTransition = false
    private let transitionType: TransitionType
    private weak var delegate: SwipeInteractionControllerDelegate?
    
    init(transitionType: TransitionType) {
        self.transitionType = transitionType
        super.init()
    }
    
    func setDelegate(to delegate: SwipeInteractionControllerDelegate) {
        self.delegate = delegate
        prepareGestureRecognizers()
    }
    
    private func prepareGestureRecognizers() {
        guard let view = delegate?.sourceViewController.view else { return }
        let gesture = UIScreenEdgePanGestureRecognizer(target: self,
                                                       action: #selector(handleGesture(gestureRecognizer:)))
        gesture.edges = transitionType.activeEdge
        
        view.addGestureRecognizer(gesture)
    }
    
    @objc
    private func handleGesture(gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        
        guard let sourceView = delegate?.sourceViewController,
            let destinationView = delegate?.destinationViewController,
            let gestureView = gestureRecognizer.view?.superview else { return }
        
        let translation = gestureRecognizer.translation(in: gestureView)
        var progress = (translation.x / 200)
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        
        switch gestureRecognizer.state {
        case .began:
            interactionInProgress = true
            sourceView.dismiss(animated: true, completion: nil)
            sourceView.present(destinationView, animated: true, completion: nil)
        case .changed:
            shouldCompleteTransition = progress > 0.5
            update(progress)
        case .cancelled:
            interactionInProgress = false
            cancel()
        case .ended:
            interactionInProgress = false
            if shouldCompleteTransition {
                finish()
            } else {
                cancel()
            }
        default:
            break
        }
    }
}

private extension TransitionType {
    
    var activeEdge: UIRectEdge {
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
}
