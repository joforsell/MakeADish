//
//  UIStackView+RemoveSubviews.swift
//  MakeADish
//
//  Created by Johan Forsell on 2022-06-07.
//

import Foundation
import UIKit

extension UIStackView {

    func safelyRemoveArrangedSubviews() {

        // Remove all the arranged subviews and save them to an array
        let removedSubviews = arrangedSubviews.reduce([]) { (sum, next) -> [UIView] in
            self.removeArrangedSubview(next)
            return sum + [next]
        }

        // Deactive all constraints at once
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))

        // Remove the views from self
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}
