//
//  DisplayImageVC.swift
//  MakeADish
//
//  Created by Johan Forsell on 2022-06-20.
//

import Foundation
import UIKit

class DisplayImageVC: UIViewController {
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = UIImage.placeholder
        view = imageView
    }
    
    // MARK: - Image loading
    
    private let imageLoader = ImageLoader()
    
    func getImageForId(_ id: String) async throws {
        let url = URL(string: "https://img.youtube.com/vi/\(id)/0.jpg")!
        let image = try await imageLoader.fetch(url)
        imageView.image = image
    }
}
