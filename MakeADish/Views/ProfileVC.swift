//
//  ProfileVC.swift
//  MakeADish
//
//  Created by Johan Forsell on 2022-05-04.
//

import UIKit

class ProfileVC: UIViewController, UITextFieldDelegate {
    private let service: DishesServiceable
    
    let titleTF: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .bezel
        return tf
    }()
    
    let descTF: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .bezel
        return tf
    }()

    let videoIdTF: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .bezel
        return tf
    }()
    
    let submitButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .systemBlue
        btn.setTitle("Submit", for: .normal)
        btn.addTarget(ProfileVC.self, action: #selector(submitAction), for: .touchUpInside)
        return btn
    }()
    
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
        view.addSubview(titleTF)
        view.addSubview(descTF)
        view.addSubview(videoIdTF)
        view.addSubview(submitButton)
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            titleTF.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            titleTF.heightAnchor.constraint(equalToConstant: 20),
            titleTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            descTF.topAnchor.constraint(equalTo: titleTF.bottomAnchor, constant: 20),
            descTF.heightAnchor.constraint(equalToConstant: 20),
            descTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            videoIdTF.topAnchor.constraint(equalTo: descTF.bottomAnchor, constant: 20),
            videoIdTF.heightAnchor.constraint(equalToConstant: 20),
            videoIdTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            videoIdTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            submitButton.topAnchor.constraint(equalTo: videoIdTF.bottomAnchor, constant: 20),
            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            submitButton.widthAnchor.constraint(equalToConstant: 60),
            submitButton.heightAnchor.constraint(equalTo: submitButton.widthAnchor, multiplier: 0.5)
        ])
    }
    
    @objc
    func submitAction() {
        guard let title = titleTF.text, let description = descTF.text, let videoUrl = videoIdTF.text, let videoId = extractYoutubeIdFromLink(link: videoUrl) else { return }
        
        
        let newDish = Dish(id: UUID(), title: title, description: description, videoId: videoId, ingredients: [], tags: [], ratings: [])
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
