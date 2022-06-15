//
//  MADTextFieldRow.swift
//  MakeADish
//
//  Created by Johan Forsell on 2022-06-14.
//

import UIKit

class MADTextFieldRow: UIView {
    var label: MADTextFieldLabel!
    var textField: MADTextField!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(labelText: String,
         placeholder: String? = nil,
         borderStyle: UITextField.BorderStyle = .roundedRect,
         autocapitalizationType: UITextAutocapitalizationType = .sentences) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        label = MADTextFieldLabel(labelText)
        textField = MADTextField(placeholder: placeholder ?? labelText,
                                 borderStyle: borderStyle,
                                 autocapitalizationType: autocapitalizationType)
        addSubview(label)
        addSubview(textField)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Constraints
    
    func addConstraints() {
        let padding: CGFloat = 4
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.heightAnchor.constraint(equalToConstant: label.intrinsicContentSize.height),
            
            textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: padding),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.heightAnchor.constraint(equalToConstant: textField.intrinsicContentSize.height + 8)
        ])
    }
}
