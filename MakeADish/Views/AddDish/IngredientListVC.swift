//
//  IngredientListVC.swift
//  MakeADish
//
//  Created by Johan Forsell on 2022-06-20.
//

import UIKit

class IngredientListVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = DynamicSizeTableView()
        tableView.register(IngredientListCell.self, forCellReuseIdentifier: IngredientListCell.identifier)
        tableView.estimatedRowHeight = 120
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
}
