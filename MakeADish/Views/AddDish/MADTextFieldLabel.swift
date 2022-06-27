//
//  MADTextFieldLabel.swift
//  MakeADish
//
//  Created by Johan Forsell on 2022-06-14.
//

import UIKit

final class MADTextFieldLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    init(_ text: String) {
        super.init(frame: .zero)
        self.text = text
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        font = .preferredFont(forTextStyle: .callout)
    }
}
