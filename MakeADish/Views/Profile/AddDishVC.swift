//
//  AddDishVC.swift
//  MakeADish
//
//  Created by Johan Forsell on 2022-05-04.
//

import UIKit

class AddDishVC: UIViewController, UITextFieldDelegate {
    
    private let service: DishesServiceable
    var addIngredientsVC = AddIngredientsVC()
    var ingredients: [UIView] {
        didSet {
            ingredientStack.arrangedSubviews.forEach { ingredientStack.removeArrangedSubview($0) }
            ingredients.forEach { ingredientStack.addArrangedSubview($0) }
            ingredientStack.layoutSubviews()
        }
    }
    
    private lazy var videoRow = MADTextFieldRow(labelText: "Enter YouTube link", autocapitalizationType: .none)
    private lazy var titleRow = MADTextFieldRow(labelText: "Enter dish title")
    private lazy var descriptionRow = MADTextFieldRow(labelText: "Enter dish description")
    private lazy var submitButton = MADButton("Submit", image: UIImage(systemName: "paperplane.fill"))
    private lazy var ingredientsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Add ingredients"
        return label
    }()
    private lazy var ingredientStack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .equalSpacing
        view.axis = .vertical
        view.alignment = .fill
        view.spacing = 4
//        let dummyIngredient = MADIngredientRow(name: "Dummyingredient", volume: 2, unit: .tablespoon)
//        view.addArrangedSubview(dummyIngredient)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        addSubviews()
        addConstraints()
        submitButton.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
        videoRow.textField.delegate = self
    }
    
    init(service: DishesServiceable) {
        self.service = service
        self.ingredients = []
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set up views
    
    func addSubviews() {
        view.addSubview(titleRow)
        view.addSubview(descriptionRow)
        view.addSubview(videoRow)
        view.addSubview(ingredientsLabel)
        addChild(addIngredientsVC)
        addIngredientsVC.delegate = self
        addIngredientsVC.didMove(toParent: self)
        view.addSubview(addIngredientsVC.view)
        view.addSubview(ingredientStack)
        view.addSubview(submitButton)
    }
    
    // MARK: - Constraints
    
    private func addConstraints() {
        
        let horizontalPadding: CGFloat = 20
        let rowTopPadding: CGFloat = 16

        NSLayoutConstraint.activate([
            videoRow.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            videoRow.heightAnchor.constraint(equalToConstant: videoRow.label.intrinsicContentSize.height + videoRow.textField.intrinsicContentSize.height + 8),
            videoRow.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            videoRow.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),

            titleRow.topAnchor.constraint(equalTo: videoRow.bottomAnchor, constant: rowTopPadding),
            titleRow.heightAnchor.constraint(equalToConstant: titleRow.label.intrinsicContentSize.height + titleRow.textField.intrinsicContentSize.height + 8),
            titleRow.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            titleRow.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            
            descriptionRow.topAnchor.constraint(equalTo: titleRow.bottomAnchor, constant: rowTopPadding),
            descriptionRow.heightAnchor.constraint(equalToConstant: descriptionRow.label.intrinsicContentSize.height + descriptionRow.textField.intrinsicContentSize.height + 8),
            descriptionRow.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            descriptionRow.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            
            ingredientsLabel.topAnchor.constraint(equalTo: descriptionRow.bottomAnchor, constant: rowTopPadding),
            ingredientsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            
            addIngredientsVC.view.topAnchor.constraint(equalTo: ingredientsLabel.bottomAnchor, constant: 4),
            addIngredientsVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            addIngredientsVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            
            ingredientStack.topAnchor.constraint(equalTo: addIngredientsVC.view.bottomAnchor, constant: rowTopPadding),
            ingredientStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            ingredientStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            
            submitButton.topAnchor.constraint(equalTo: ingredientStack.bottomAnchor, constant: rowTopPadding * 2),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    // MARK: - Logic
    
    @objc
    func submitAction() {
        guard let title = titleRow.textField.text, let description = descriptionRow.textField.text, let videoUrl = videoRow.textField.text, let videoId = extractYoutubeIdFromLink(link: videoUrl) else { return }
        
        
        let newDish = Dish(id: UUID(), title: title, description: description, videoId: videoId, tags: [], ratings: [])
        Task {
            do {
                let _ = try await service.addDish(newDish)
            } catch let reqError as RequestError {
                print(reqError.customMessage)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func extractYoutubeIdFromLink(link: String) -> String? {
        let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
        guard let regExp = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return nil
        }
        let nsLink = link as NSString
        let options = NSRegularExpression.MatchingOptions(rawValue: 0)
        let range = NSRange(location: 0, length: nsLink.length)
        let matches = regExp.matches(in: link as String, options:options, range:range)
        if let firstMatch = matches.first {
            return nsLink.substring(with: firstMatch.range)
        }
        return nil
    }
}

extension AddDishVC: IngredientsDelegate {
    func makeIngredientView(from ingredient: Ingredient) {
        let ingredientView = MADIngredientRow(name: ingredient.name, volume: ingredient.volume, unit: ingredient.unit)
        if !ingredientStack.arrangedSubviews.isEmpty {
            let separator = UIView(frame: .zero)
            separator.translatesAutoresizingMaskIntoConstraints = false
            separator.backgroundColor = .quaternaryLabel
            separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
            ingredients.append(separator)
        }
        ingredients.append(ingredientView)
    }
}
