//
//  TransitioningController.swift
//  Brigid
//
//  Created by Stephen Walsh on 06/02/2019.
//  Copyright © 2019 Stephen Walsh. All rights reserved.
//

import UIKit

final class SNKTransitionCoordinator {
    
    private var topTransitionController: SNKTransitionController?
    private var leftTransitionController: SNKTransitionController?
    private var bottomTransitionController: SNKTransitionController?
    private var rightTransitionController: SNKTransitionController?
    
    weak var sourceViewController: UIViewController?
}

extension SNKTransitionCoordinator {
    
    func addDestinationViewController(destinationViewController: UIViewController,
                                      forTransitionType transitionType: SNKTransitionType) {
        switch transitionType {
        case .fromTop:
            self.topTransitionController = SNKTransitionController(with: transitionType,
                                                                   from: sourceViewController,
                                                                   to: destinationViewController)
        case .fromLeft:
            self.leftTransitionController = SNKTransitionController(with: transitionType,
                                                                    from: sourceViewController,
                                                                    to: destinationViewController)
        case .fromBottom:
            self.bottomTransitionController = SNKTransitionController(with: transitionType,
                                                                      from: sourceViewController,
                                                                      to: destinationViewController)
        case .fromRight:
            self.rightTransitionController = SNKTransitionController(with: transitionType,
                                                                     from: sourceViewController,
                                                                     to: destinationViewController)
        }
    }
}
