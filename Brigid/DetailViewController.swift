//
//  DetailViewController.swift
//  Brigid
//
//  Created by Stephen Work on 05/02/2019.
//  Copyright © 2019 Stephen Walsh. All rights reserved.
//

import UIKit

final class DetailViewController: UIViewController {
    
    private let blurView: UIVisualEffectView = {
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        
        return blurView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        performInitialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DetailViewController {
    
    private func performInitialSetup() {
        view.backgroundColor = .green
        
        view.addSubview(blurView)
        
        blurView.topAnchor.constraint(equalTo: view.topAnchor)
        blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    }
}
