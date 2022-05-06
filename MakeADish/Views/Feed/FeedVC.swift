//
//  FeedVC.swift
//  MakeADish
//
//  Created by Johan Forsell on 2022-05-04.
//

import UIKit

class FeedVC: UITableViewController {
    private let service: DishesServiceable
    var reqError: RequestError?
    var dishes = [Dish]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = DynamicSizeTableView()
        tableView.register(DishCell.self, forCellReuseIdentifier: "Dish")
        tableView.estimatedRowHeight = 400

        view.backgroundColor = .purple
        
        loadDishes()
    }
    
    init(service: DishesServiceable) {
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Setup
    
    // API call to fetch all dishes
    func loadDishes(completion: (() -> Void)? = nil) {
        Task {
            do {
                dishes = try await service.getAllDishes()
                tableView.reloadData()
                tableView.invalidateIntrinsicContentSize()
                completion?()
            } catch let error as RequestError {
                reqError = error
            }
        }
    }
    
    // MARK: - Table View methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dishes.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Dish", for: indexPath) as? DishCell else {
            fatalError()
        }
        cell.dish = dishes[indexPath.item]
        return cell
    }

}
