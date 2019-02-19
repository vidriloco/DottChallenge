//
//  UIView+Extensions.swift
//  Restos
//
//  Created by Alejandro on 18/02/2019.
//  Copyright © 2019 Alejandro. All rights reserved.
//

import UIKit

extension UIView {
    
    func withoutAutoConstraints() -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
    func added(to viewController: UIViewController) -> Self {
        viewController.view.addSubview(self)
        return self
    }
    
}
