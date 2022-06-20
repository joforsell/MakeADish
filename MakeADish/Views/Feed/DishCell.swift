//
//  DishCell.swift
//  MakeADish
//
//  Created by Johan Forsell on 2022-05-05.
//

import UIKit

class DishCell: UITableViewCell {
    
    var tagViews: [UILabel]? {
        didSet {
            guard let tagViews = tagViews else { return }
            
            // To make sure old tags don't stay when reloading.
            dishTags.safelyRemoveArrangedSubviews()
            
            for tagView in tagViews {
                dishTags.addArrangedSubview(tagView)
            }
        }
    }
    
    // MARK: - Views
    
    let dishImageView: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    let dishTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        return label
    }()
    
    let dishDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()
    
    let dishTags: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .trailing
        stackView.spacing = 2
        return stackView
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(dishImageView)
        contentView.addSubview(dishTitle)
        contentView.addSubview(dishDescription)
        contentView.addSubview(dishTags)
        
        NSLayoutConstraint.activate([
            dishImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            dishImageView.widthAnchor.constraint(equalTo: dishImageView.heightAnchor, multiplier: 16/9),
            dishImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dishImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            dishTitle.topAnchor.constraint(equalTo: dishImageView.bottomAnchor, constant: 20),
            dishTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            dishTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            dishDescription.topAnchor.constraint(equalTo: dishTitle.bottomAnchor, constant: 10),
            dishDescription.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            dishDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            dishTags.topAnchor.constraint(equalTo: dishDescription.bottomAnchor, constant: 10),
            dishTags.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            dishTags.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
