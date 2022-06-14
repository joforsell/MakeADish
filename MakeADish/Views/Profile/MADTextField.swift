//
//  MADTextField.swift
//  MakeADish
//
//  Created by Johan Forsell on 2022-06-14.
//

import UIKit

final class MADTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    init(placeholder: String?, borderStyle: UITextField.BorderStyle, autocapitalizationType: UITextAutocapitalizationType) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        self.borderStyle = borderStyle
        self.autocapitalizationType = autocapitalizationType
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        autocorrectionType = .no
    }
}
