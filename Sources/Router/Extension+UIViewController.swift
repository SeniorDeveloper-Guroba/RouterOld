//
//  extension UIViewController.swift
//  
//
//  Created by Senior Developer on 01.02.2023.
//

import UIKit

extension UIViewController {
    
    func present(
        with viewController: UIViewController,
        with animated: Bool,
        with transitionStyle: UIModalTransitionStyle,
        with presentationStyle:  UIModalPresentationStyle,
        completion: (() -> Void)? = nil
    ) {
        viewController.modalTransitionStyle   = transitionStyle
        viewController.modalPresentationStyle = presentationStyle
        self.present(
            viewController,
            animated: animated,
            completion: completion
        )
    }
}
