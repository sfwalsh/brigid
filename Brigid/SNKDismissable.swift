//
//  SNKDismissable.swift
//  Brigid
//
//  Created by Stephen Walsh on 08/02/2019.
//  Copyright © 2019 Stephen Walsh. All rights reserved.
//

import UIKit

protocol SNKDismissable {
    
    func dismissalGestureHandleView(forTransitionType transitionType: SNKTransitionType) -> UIView?
    
    func willBeginDismissalAnimation()
    func didEndDismissalAnimation()
}

typealias SNKDismissableViewController = SNKDismissable & UIViewController
