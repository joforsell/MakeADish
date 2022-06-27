//
//  IngredientListCell.swift
//  MakeADish
//
//  Created by Johan Forsell on 2022-06-20.
//

import UIKit

class IngredientListCell: UITableViewCell {
    
    static let identifier = "IngredientListCell"
    
    lazy var ingredientNameLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var ingredientVolumeLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var ingredientUnitLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(ingredientNameLabel)
        contentView.addSubview(ingredientVolumeLabel)
        contentView.addSubview(ingredientUnitLabel)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Constraints
    
    func setConstraints() {
        let padding: CGFloat = 4
        
        NSLayoutConstraint.activate([
            ingredientNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ingredientNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            ingredientNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            
            ingredientVolumeLabel.trailingAnchor.constraint(equalTo: ingredientUnitLabel.leadingAnchor, constant: -padding),
            ingredientVolumeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            ingredientVolumeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            
            ingredientUnitLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            ingredientUnitLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            ingredientUnitLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])
    }
}
