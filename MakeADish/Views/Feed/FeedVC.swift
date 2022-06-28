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
        tableView.showsVerticalScrollIndicator = false
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        
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
                refreshControl?.endRefreshing()
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
        let dish = dishes[indexPath.item]
        Task {
            do {
                cell.dishImageView.image = try await getImageForId(dish.videoId)
            } catch {
                print(error.localizedDescription)
            }
        }
        cell.dishTitle.text = dish.title
        cell.dishDescription.text = dish.description
        cell.tagViews = makeTagViews(tags: dish.tags)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dish = dishes[indexPath.item]
        let vc = DishVC(dish: dish)
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc
    func onRefresh() {
        loadDishes()
    }
    
    // MARK: - Cell logic
    
    let imageLoader = ImageLoader()
    
    func getImageForId(_ id: String) async throws -> UIImage {
        let url = URL(string: "https://img.youtube.com/vi/\(id)/0.jpg")!
        let image = try await imageLoader.fetch(url)
        return image
    }
    
    func makeTagViews(tags: [String]) -> [UILabel] {
        var labels = [UILabel]()
        for tag in tags {
            let label = UILabel()
            label.text = tag
            labels.append(label)
        }
        return labels
    }
}
