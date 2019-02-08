//
//  DetailViewController.swift
//  Brigid
//
//  Created by Stephen Walsh on 05/02/2019.
//  Copyright © 2019 Stephen Walsh. All rights reserved.
//

import UIKit

final class DetailViewController: UIViewController {
    
    private let blurView: UIVisualEffectView = {
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        
        return blurView
    }()
    
    private let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Dismiss", for: .normal)
        
        return button
    }()
        
    init() {
        super.init(nibName: nil, bundle: nil)
        performInitialSetup()
        setNeedsUpdateOfScreenEdgesDeferringSystemGestures()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return [.top, .bottom]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setNeedsUpdateOfScreenEdgesDeferringSystemGestures()
    }
}

// MARK: SNKPresentable Implementation

extension DetailViewController: SNKPresentable {
    
    func willBeginPresentationAnimation() {
        blurView.effect = nil
    }
    
    func didEndPresentationAnimation() {
        blurView.effect = UIBlurEffect(style: .light)
    }
}

// MARK: SNKDismissable Implementation

extension DetailViewController: SNKDismissable {
    
    func willBeginDismissalAnimation() {
        blurView.effect = UIBlurEffect(style: .light)
    }
    
    func didEndDismissalAnimation() {
        blurView.effect = nil
    }
}

// MARK: Setup

extension DetailViewController {
    
    private func performInitialSetup() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.26)
        
        dismissButton.addTarget(self, action: #selector(dismissMe), for: .touchUpInside)
        
        view.addSubview(blurView)
        view.addSubview(dismissButton)
        
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ])
        
        
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dismissButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            dismissButton.widthAnchor.constraint(equalToConstant: 100.0),
            dismissButton.heightAnchor.constraint(equalToConstant: 50.0)
            ])
    }
    
    @objc
    private func dismissMe() {
        dismiss(animated: true, completion: nil)
    }
}
