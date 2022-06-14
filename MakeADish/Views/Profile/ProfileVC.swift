//
//  ProfileVC.swift
//  MakeADish
//
//  Created by Johan Forsell on 2022-05-04.
//

import UIKit

class ProfileVC: UIViewController, UITextFieldDelegate {
    private let service: DishesServiceable
    
    private lazy var titleRow = MADTextFieldRow(labelText: "Enter dish title")
    private lazy var descriptionRow = MADTextFieldRow(labelText: "Enter dish description")
    private lazy var videoRow = MADTextFieldRow(labelText: "Enter YouTube link", autocapitalizationType: .none)
    private lazy var submitButton = MADButton("Submit", image: UIImage(systemName: "paperplane.fill"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        addSubviews()
        addConstraints()
    }
    
    init(service: DishesServiceable) {
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        view.addSubview(titleRow)
        view.addSubview(descriptionRow)
        view.addSubview(videoRow)
        view.addSubview(submitButton)
    }
    
    // MARK: - Constraints
    
    let rowHeight: CGFloat = 60
    let horizontalPadding: CGFloat = 20
    let rowTopPadding: CGFloat = 60
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            titleRow.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            titleRow.heightAnchor.constraint(equalToConstant: rowHeight),
            titleRow.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            titleRow.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: horizontalPadding),
            
            descriptionRow.topAnchor.constraint(equalTo: titleRow.bottomAnchor, constant: rowTopPadding),
            descriptionRow.heightAnchor.constraint(equalToConstant: rowHeight),
            descriptionRow.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            descriptionRow.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: horizontalPadding),
            
            videoRow.topAnchor.constraint(equalTo: descriptionRow.bottomAnchor, constant: rowTopPadding),
            videoRow.heightAnchor.constraint(equalToConstant: rowHeight),
            videoRow.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            videoRow.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: horizontalPadding),
            
            submitButton.topAnchor.constraint(equalTo: videoRow.bottomAnchor, constant: rowTopPadding),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.widthAnchor.constraint(equalToConstant: submitButton.intrinsicContentSize.width),
            submitButton.heightAnchor.constraint(equalToConstant: submitButton.intrinsicContentSize.height)
        ])
    }
    
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
