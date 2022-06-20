//
//  AddDishVC.swift
//  MakeADish
//
//  Created by Johan Forsell on 2022-05-04.
//

import UIKit

class AddDishVC: UIViewController, UITextFieldDelegate {
    
    private let service: DishesServiceable
    private var displayImageVC: DisplayImageVC!
    private var addIngredientsVC: AddIngredientsVC!
    private var ingredientListVC: IngredientListVC!
    private var ingredients = [Ingredient]() {
        didSet {
            ingredientListVC.tableView.reloadData()
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
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        displayImageVC = DisplayImageVC()
        addIngredientsVC = AddIngredientsVC(action: addIngredient)
        ingredientListVC = IngredientListVC(style: .insetGrouped)
        videoRow.textField.addTarget(self, action: #selector(videoTextFieldDidChange), for: .editingChanged)
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
    
    private func addSubviews() {
        addChild(displayImageVC)
        displayImageVC.didMove(toParent: self)
        view.addSubview(displayImageVC.view)
        view.addSubview(titleRow)
        view.addSubview(descriptionRow)
        view.addSubview(videoRow)
        view.addSubview(ingredientsLabel)
        addChild(addIngredientsVC)
        addIngredientsVC.didMove(toParent: self)
        view.addSubview(addIngredientsVC.view)
        addChild(ingredientListVC)
        ingredientListVC.didMove(toParent: self)
        ingredientListVC.tableView.dataSource = self
        view.addSubview(ingredientListVC.view)
        view.addSubview(submitButton)
    }
    
    // MARK: - Constraints
    
    private func addConstraints() {
        
        let horizontalPadding: CGFloat = 20
        let rowTopPadding: CGFloat = 16

        NSLayoutConstraint.activate([
            displayImageVC.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            displayImageVC.view.widthAnchor.constraint(equalTo: displayImageVC.view.heightAnchor, multiplier: 16/9),
            displayImageVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            displayImageVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            
            videoRow.topAnchor.constraint(equalTo: displayImageVC.view.bottomAnchor, constant: horizontalPadding),
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
            
            ingredientListVC.view.topAnchor.constraint(equalTo: addIngredientsVC.view.bottomAnchor, constant: rowTopPadding),
            ingredientListVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            ingredientListVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            
            submitButton.topAnchor.constraint(equalTo: ingredientListVC.view.bottomAnchor, constant: rowTopPadding * 2),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    // MARK: - Logic
    
    @objc
    private func submitAction() {
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
    
    private func extractYoutubeIdFromLink(link: String) -> String? {
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
        
    private func addIngredient(ingredient: Ingredient) {
        ingredients.insert(ingredient, at: 0)
    }
    
    @objc
    private func videoTextFieldDidChange() {
        guard let text = videoRow.textField.text else { return }
        
        if let videoId = extractYoutubeIdFromLink(link: text) {
            Task {
                do {
                    try await displayImageVC.getImageForId(videoId)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - TableView methods for ingredients list

extension AddDishVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ingredients.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: IngredientListCell.identifier, for: indexPath) as? IngredientListCell else {
            fatalError()
        }
        let ingredient = ingredients[indexPath.item]
        cell.ingredientNameLabel.text = ingredient.name
        cell.ingredientVolumeLabel.text = String(ingredient.volume)
        cell.ingredientUnitLabel.text = ingredient.unit.shorthand
        return cell
    }
}
