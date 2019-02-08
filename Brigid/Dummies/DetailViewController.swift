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
    
    private var dragHandleView: UIView?
        
    init(showsDragHandle: Bool) {
        self.dragHandleView = showsDragHandle ? UIView() : nil
        super.init(nibName: nil, bundle: nil)
        performInitialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: SNKPresentable Implementation

extension DetailViewController: SNKPresentable {
    
    func presentationGestureHandleView(forTransitionType transitionType: SNKTransitionType) -> UIView? {
        return nil
    }
    
    func willBeginPresentationAnimation() {
        blurView.effect = nil
    }
    
    func didEndPresentationAnimation() {
        blurView.effect = UIBlurEffect(style: .light)
    }
}

// MARK: SNKDismissable Implementation

extension DetailViewController: SNKDismissable {
    
    func dismissalGestureHandleView(forTransitionType transitionType: SNKTransitionType) -> UIView? {
        switch transitionType {
        case .fromLeft, .fromRight:
            return nil
        case .fromTop, .fromBottom:
            return dragHandleView
        }
    }
    
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
            dismissButton.heightAnchor.constraint(equalToConstant: 100.0)
            ])
        
        
        if let dragHandleView = dragHandleView {
            dragHandleView.backgroundColor = .green
            view.addSubview(dragHandleView)
            dragHandleView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                dragHandleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                dragHandleView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100),
                dragHandleView.widthAnchor.constraint(equalToConstant: 100.0),
                dragHandleView.heightAnchor.constraint(equalToConstant: 50.0)
                ])
        }
    }
    
    @objc
    private func dismissMe() {
        dismiss(animated: true, completion: nil)
    }
}
