//
//  IngredientsVC.swift
//  MakeADish
//
//  Created by Johan Forsell on 2022-06-13.
//

import UIKit

class IngredientsVC: UIViewController {
    
    var ingredientsStack: UIStackView!
    var ingredients = [Ingredient]()

    override func loadView() {
        ingredientsStack = UIStackView()
        ingredientsStack.axis = .vertical
        ingredientsStack.spacing = 4
        view = ingredientsStack
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        makeIngredientRows(from: ingredients)
    }
    
    func makeIngredientRows(from ingredients: [Ingredient]) {
        for ingredient in ingredients {
            let view = UIStackView()
            view.axis = .horizontal
            view.distribution = .fillEqually
            view.spacing = 2
            let name = UILabel()
            name.text = ingredient.name
            let volume = UILabel()
            volume.text = String(ingredient.volume)
            let unit = UILabel()
            unit.text = ingredient.unit.rawValue.capitalized
            view.addArrangedSubview(name)
            view.addArrangedSubview(volume)
            view.addArrangedSubview(unit)
            ingredientsStack.addArrangedSubview(view)
        }
    }
}
