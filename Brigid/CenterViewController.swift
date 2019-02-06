//
//  CenterViewController.swift
//  Brigid
//
//  Created by Stephen Work on 04/02/2019.
//  Copyright © 2019 Stephen Walsh. All rights reserved.
//

import UIKit

final class CenterViewController: UIViewController {
    
    private var swipeInteractionController: SwipeInteractionController!

    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "dummy"))
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        swipeInteractionController = SwipeInteractionController(viewController: self)
        performInitialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Setup

extension CenterViewController {
    
    private func performInitialSetup() {
        view.backgroundColor = .black

        view.addSubview(backgroundImageView)

        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor)
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(presentDetailView))
        backgroundImageView.isUserInteractionEnabled = true
        backgroundImageView.addGestureRecognizer(tap)
    }
}

// MARK: Actions

extension CenterViewController {
    
    @objc
    private func presentDetailView() {
        let viewController = DetailViewController()
        viewController.transitioningDelegate = self
        
        present(viewController, animated: true, completion: nil)
    }
}

// MARK: UIViewControllerTransitioningDelegate Implementation

extension CenterViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimationController(destinationFrame: presented.view.frame,
                                              interactionController: swipeInteractionController)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimationController(destinationFrame: dismissed.view.frame,
                                              interactionController: swipeInteractionController)
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return swipeInteractionController
    }
}

