//
//  SNKPresentable.swift
//  Brigid
//
//  Created by Stephen Walsh on 08/02/2019.
//  Copyright © 2019 Stephen Walsh. All rights reserved.
//

import UIKit

protocol SNKPresentable {
    
    func presentationGestureHandleView(forTransitionType transitionType: SNKTransitionType) -> UIView?

    func willBeginPresentationAnimation()
    func didEndPresentationAnimation()
}

typealias SNKPresentableViewController = SNKPresentable & UIViewController
typealias SNKViewController = SNKPresentableViewController & SNKDismissableViewController
