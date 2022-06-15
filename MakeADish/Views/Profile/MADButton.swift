//
//  MADButton.swift
//  MakeADish
//
//  Created by Johan Forsell on 2022-06-14.
//

import UIKit

final class MADButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    init(_ label: String? = nil, image: UIImage? = nil, tintColor: UIColor = .systemBlue, configuration: UIButton.Configuration = .bordered()) {
        super.init(frame: .zero)
        self.tintColor = tintColor
        setTitle(label, for: .normal)
        if image != nil {
            setImage(image, for: .normal)
        }
        self.configuration = configuration
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
    }

}
