//
//  DishVC.swift
//  MakeADish
//
//  Created by Johan Forsell on 2022-06-07.
//

import UIKit
import WebKit

class DishVC: UIViewController {
    
    var dish: Dish
    let videoVC = VideoVC()
    let ingredientsVC = IngredientsVC()
    
    let titleView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .largeTitle)
        return label
    }()
    
    let starsView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .fillEqually
        return view
    }()
    
    let descriptionView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .callout)
        return label
    }()
    
    init(dish: Dish) {
        self.dish = dish
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        makeVideoView()
        setTitle(to: dish.title)
        makeStarsView(with: dish.ratings)
        setDescription(to: dish.description)
        makeIngredientsView(with: dish.ingredients ?? [])
        
        setConstraints()
    }
}

// MARK: - Set UI

extension DishVC {
    func makeVideoView() {
        videoVC.videoId = dish.videoId
        addChild(videoVC)
        videoVC.didMove(toParent: self)
        videoVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(videoVC.view)
    }

    func setTitle(to title: String) {
        titleView.text = title
        view.addSubview(titleView)
    }

    func getRatingAverage(from ratings: [Int]) -> Int {
        let total = ratings.reduce(0, +)
        guard !ratings.isEmpty else { return 0 }
        let average = total/ratings.count
        return average
    }
    
    func makeStarsView(with ratings: [Int]) {

        let averageRating = getRatingAverage(from: ratings)
        
        for _ in 0..<averageRating {
            let star = UIImageView(image: UIImage(systemName: "star.fill"))
            star.tintColor = .starYellow
            starsView.addArrangedSubview(star)
        }
        
        for _ in 0..<(5 - averageRating) {
            let star = UIImageView(image: UIImage(systemName: "star"))
            star.tintColor = .starYellow
            starsView.addArrangedSubview(star)
        }
        
        if ratings.isEmpty {
            for star in starsView.arrangedSubviews {
                star.tintColor = .gray
                star.layer.opacity = 0.5
            }
        }
        
        view.addSubview(starsView)
    }
    
    func setDescription(to description: String) {
        descriptionView.text = description
        view.addSubview(descriptionView)
    }
    
    func makeIngredientsView(with ingredients: [Ingredient]) {
        ingredientsVC.ingredients = dish.ingredients ?? []
        addChild(ingredientsVC)
        ingredientsVC.didMove(toParent: self)
        ingredientsVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ingredientsVC.view)
    }
}

// MARK: - Constraints

extension DishVC {
    func setConstraints() {
        NSLayoutConstraint.activate([
            videoVC.view.topAnchor.constraint(equalTo: view.topAnchor),
            videoVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            videoVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            videoVC.view.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            titleView.topAnchor.constraint(equalTo: videoVC.view.bottomAnchor, constant: 8),
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            
            starsView.topAnchor.constraint(equalTo: videoVC.view.bottomAnchor, constant: 8),
            starsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            starsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width * 0.7),
            
            descriptionView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 8),
            descriptionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            descriptionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            ingredientsVC.view.topAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: 16),
            ingredientsVC.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
}
