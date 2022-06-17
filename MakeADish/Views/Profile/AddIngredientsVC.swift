//
//  AddIngredientsVC.swift
//  MakeADish
//
//  Created by Johan Forsell on 2022-06-14.
//

import UIKit

protocol IngredientsDelegate: AnyObject {
    func makeIngredientView(from ingredient: Ingredient)
}

class AddIngredientsVC: UIViewController {
    
    weak var delegate: IngredientsDelegate?
    var unit: MeasuringUnit?
    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.spacing = 4
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(addAction), for: .touchUpInside)
        addSubviews()
        setConstraints()
        
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        unitTextField.inputView = picker
        
        view = stack
    }
    
    // MARK: - View setup
    
    lazy var ingredientTextField = MADTextField(placeholder: "Add ingredient")
    private lazy var volumeTextField = MADTextField(placeholder: "Volume")
    private lazy var unitTextField = MADTextField(placeholder: "Unit")
    private lazy var addButton = MADButton(image: UIImage(systemName: "plus"))

    func addSubviews() {
        volumeTextField.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        unitTextField.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        stack.addArrangedSubview(ingredientTextField)
        stack.addArrangedSubview(volumeTextField)
        stack.addArrangedSubview(unitTextField)
        stack.addArrangedSubview(addButton)
    }
    
    // MARK: - Constraints
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            volumeTextField.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 0.2),

            unitTextField.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 0.2),

            addButton.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 0.1),
        ])
    }
    
    // MARK: - Logic
    
    @objc
    func addAction() {
        guard let name = ingredientTextField.text, !name.isEmpty,
                let volume = volumeTextField.text, !volume.isEmpty,
                let unit = unit else { return }
        
        let newIngredient = Ingredient(id: UUID(), name: name, volume: Double(volume) ?? 0, unit: unit)
        unitTextField.text = nil
        volumeTextField.text = nil
        ingredientTextField.text = nil
        self.unit = nil
        delegate?.makeIngredientView(from: newIngredient)
    }
}

extension AddIngredientsVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        MeasuringUnit.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        MeasuringUnit.allCases[row].rawValue.capitalized
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        unitTextField.text = MeasuringUnit.allCases[row].shorthand
        unitTextField.resignFirstResponder()
        unit = MeasuringUnit.allCases[row]
    }
}
