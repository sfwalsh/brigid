//
//  CenterViewController.swift
//  Brigid
//
//  Created by Stephen Walsh on 04/02/2019.
//  Copyright © 2019 Stephen Walsh. All rights reserved.
//

import UIKit

final class CenterViewController: UIViewController {
    
    private let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Dismiss", for: .normal)
        
        return button
    }()
    
    private let leftButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Left", for: .normal)
        
        return button
    }()
    
    private let rightButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Right", for: .normal)
        
        return button
    }()
    
    let topViewController: DetailViewController = {
        let viewController = DetailViewController()
        return viewController
    }()
    
    let leftViewController: DetailViewController = {
        let viewController = DetailViewController()
        return viewController
    }()
    
    let bottomViewController: DetailViewController = {
        let viewController = DetailViewController()
        return viewController
    }()
    
    let rightViewController: DetailViewController = {
        let viewController = DetailViewController()
        return viewController
    }()
    
    private let swipeableTransitionCoordinator: SNKTransitionCoordinator

    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "dummy"))
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    init() {
        self.swipeableTransitionCoordinator = SNKTransitionCoordinator()
        super.init(nibName: nil, bundle: nil)
        swipeableTransitionCoordinator.sourceViewController = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performInitialSetup()
    }
}

// MARK: SNKPresentable Implementation

extension CenterViewController: SNKPresentable {
    
    func presentationGestureListenerView(forTransitionType transitionType: SNKTransitionType) -> UIView? {
        switch transitionType {
        case .fromLeft, .fromRight:
            return view
        case .fromTop, .fromBottom:
            // TODO: Something else
            return view
        }
    }
    
    func willBeginPresentationAnimation() {
    }
    
    func didEndPresentationAnimation() {
    }
}

// MARK: Setup

extension CenterViewController {
    
    private func performInitialSetup() {
     
        dismissButton.addTarget(self, action: #selector(dismissMe), for: .touchUpInside)
        leftButton.addTarget(self, action: #selector(showLeftView), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(showRightView), for: .touchUpInside)
        view.backgroundColor = .black

        view.addSubview(backgroundImageView)
        view.addSubview(dismissButton)
        view.addSubview(leftButton)
        view.addSubview(rightButton)
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dismissButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            dismissButton.widthAnchor.constraint(equalToConstant: 100.0),
            dismissButton.heightAnchor.constraint(equalToConstant: 50.0)
            ])
        
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            leftButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10.0),
            leftButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            leftButton.widthAnchor.constraint(equalToConstant: 100.0),
            leftButton.heightAnchor.constraint(equalToConstant: 50.0)
            ])
    
        
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            rightButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10.0),
            rightButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rightButton.widthAnchor.constraint(equalToConstant: 100.0),
            rightButton.heightAnchor.constraint(equalToConstant: 50.0)
            ])
        
        
        swipeableTransitionCoordinator.addDestinationViewController(destinationViewController: topViewController,
                                                                    forTransitionType: .fromTop)
        swipeableTransitionCoordinator.addDestinationViewController(destinationViewController: leftViewController,
                                                                    forTransitionType: .fromLeft)
        swipeableTransitionCoordinator.addDestinationViewController(destinationViewController: bottomViewController,
                                                                    forTransitionType: .fromBottom)
        swipeableTransitionCoordinator.addDestinationViewController(destinationViewController: rightViewController,
                                                                    forTransitionType: .fromRight)
    }
    
    @objc
    private func dismissMe() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func showLeftView() {
        present(leftViewController, animated: true, completion: nil)
    }
    
    @objc
    private func showRightView() {
        present(rightViewController, animated: true, completion: nil)
    }
}
