//
//  SNKTransitionAction.swift
//  Brigid
//
//  Created by Stephen Work on 08/02/2019.
//  Copyright © 2019 Stephen Walsh. All rights reserved.
//

import UIKit

enum SNKTransitionAction {
    case presentation(sourceViewController: UIViewController?, destinationViewController: UIViewController?)
    case dismissal(viewController: UIViewController?)
}
