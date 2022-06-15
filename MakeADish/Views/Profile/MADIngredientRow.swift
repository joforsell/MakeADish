//
//  MADIngredientRow.swift
//  MakeADish
//
//  Created by Johan Forsell on 2022-06-15.
//

import UIKit

class MADIngredientRow: UIView {
    
    private lazy var nameLabel: UILabel = createLabel()
    private lazy var volumeLabel: UILabel = createLabel()
    private lazy var unitLabel: UILabel = createLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(name: String, volume: Double, unit: MeasuringUnit) {
        super.init(frame: .zero)
        self.nameLabel.text = name
        self.volumeLabel.text = String(volume)
        self.unitLabel.text = unit.shorthand
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    // MARK: - Constraints
    
    func setConstraints() {
        let padding: CGFloat = 4
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: nameLabel.intrinsicContentSize.height),
            
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            volumeLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: padding),
            
            unitLabel.leadingAnchor.constraint(equalTo: volumeLabel.trailingAnchor, constant: padding)
        ])
    }
}
