//
//  SNKInteractionContext.swift
//  Brigid
//
//  Created by Stephen Walsh on 08/02/2019.
//  Copyright © 2019 Stephen Walsh. All rights reserved.
//

import UIKit

struct SNKInteractionContext {
    let action: SNKTransitionAction
    let transitionType: SNKTransitionType
    weak var gestureView: UIView?
    var transformsGestureView: Bool
}

extension SNKInteractionContext {
    
    var activeEdge: UIRectEdge {
        switch (transitionType, action) {
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
    
    var progressNeededForCompletion: CGFloat {
        switch (transitionType, action) {
        case (.fromLeft, .presentation), (.fromRight, .presentation):
            return 0.5
        case (.fromLeft, .dismissal), (.fromRight, .dismissal):
            return 0.26
        default:
            return 0.3
        }
    }
}


// MARK: Builders

extension SNKInteractionContext {
    
    static func PresentationContext(sourceViewController: SNKPresentableViewController?,
                                    destinationViewController: UIViewController?,
                                    transitionType: SNKTransitionType) -> SNKInteractionContext {
        let action = SNKTransitionAction.presentation(sourceViewController: sourceViewController,
                                                      destinationViewController: destinationViewController)
        
        let gestureHandleView = sourceViewController?.presentationGestureHandleView(forTransitionType: transitionType)
        let shouldTransformGestureView = gestureHandleView != nil
        return SNKInteractionContext(action: action,
                                    transitionType: transitionType,
                                    gestureView: gestureHandleView ?? sourceViewController?.view,
                                    transformsGestureView: shouldTransformGestureView)
    }
    
    static func DismissalContext(viewController: SNKDismissableViewController?,
                                 transitionType: SNKTransitionType) -> SNKInteractionContext {
        let action = SNKTransitionAction.dismissal(viewController: viewController)
        let gestureHandleView = viewController?.dismissalGestureHandleView(forTransitionType: transitionType)
        
        return SNKInteractionContext(action: action,
                                    transitionType: transitionType,
                                    gestureView: gestureHandleView ?? viewController?.view,
                                    transformsGestureView: false)
    }
}
