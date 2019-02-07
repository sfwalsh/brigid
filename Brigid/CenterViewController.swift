//
//  CenterViewController.swift
//  Brigid
//
//  Created by Stephen Walsh on 04/02/2019.
//  Copyright © 2019 Stephen Walsh. All rights reserved.
//

import UIKit

final class CenterViewController: UIViewController {
    
    let leftViewController: UIViewController = {
        let viewController = DetailViewController()
        
        return viewController
    }()
    
    private var leftTransitioningController: TransitioningController?

    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "dummy"))
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        leftTransitioningController = TransitioningController(type: .fromLeft,
                                                              sourceViewController: self,
                                                              destinationViewController: leftViewController)
        performInitialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Setup

extension CenterViewController {
    
    private func performInitialSetup() {
        leftViewController.modalPresentationStyle = .overCurrentContext
        view.backgroundColor = .black

        view.addSubview(backgroundImageView)

        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor)
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    
//        let tap = UITapGestureRecognizer(target: self,
//                                         action: #selector(presentDetailView))
//        backgroundImageView.isUserInteractionEnabled = true
//        backgroundImageView.addGestureRecognizer(tap)
    }
}
