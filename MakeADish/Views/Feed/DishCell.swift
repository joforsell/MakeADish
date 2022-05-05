//
//  DishCell.swift
//  MakeADish
//
//  Created by Johan Forsell on 2022-05-05.
//

import UIKit

class DishCell: UITableViewCell {
    
    var dish: Dish? {
        didSet {
            guard let dishItem = dish else { return }
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
    
    let dishTags: UICollectionView = {
        let collectionView = UICollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(dishImageView)
        contentView.addSubview(dishTitle)
        contentView.addSubview(dishDescription)
        contentView.addSubview(dishTags)
        
        NSLayoutConstraint.activate([
            dishImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dishImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            dishTitle.topAnchor.constraint(equalTo: dishImageView.bottomAnchor, constant: 20),
            dishTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dishTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            dishDescription.topAnchor.constraint(equalTo: dishTitle.bottomAnchor, constant: 10),
            dishDescription.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dishDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            dishTags.topAnchor.constraint(equalTo: dishDescription.bottomAnchor, constant: 20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
