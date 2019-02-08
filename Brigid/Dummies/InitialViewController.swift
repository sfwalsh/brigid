//
//  InitialViewController.swift
//  Brigid
//
//  Created by Stephen Walsh on 07/02/2019.
//  Copyright © 2019 Stephen Walsh. All rights reserved.
//

import UIKit

final class InitialViewController: UIViewController {
    
    private var hasAppeared: Bool = false
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard !hasAppeared else { return }
        hasAppeared = true
        let view = CenterViewController()
        present(view, animated: true, completion: nil)
    }
}
