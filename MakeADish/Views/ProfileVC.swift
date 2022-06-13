//
//  ProfileVC.swift
//  MakeADish
//
//  Created by Johan Forsell on 2022-05-04.
//

import UIKit

class ProfileVC: UIViewController, UITextFieldDelegate {
    private let service: DishesServiceable
    
    let titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Enter dish title"
        return view
    }()
    
    let titleTF: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .roundedRect
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .words
        return tf
    }()
    
    let descLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Enter dish description"
        return view
    }()
    
    let descTF: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .roundedRect
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .sentences
        return tf
    }()
    
    let videoLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Enter YouTube link"
        return view
    }()

    let videoIdTF: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .roundedRect
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        return tf
    }()
    
    let submitButton: UIButton = {
        let btn = UIButton(configuration: .bordered())
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .systemBlue
        btn.setTitle("Submit", for: .normal)
        btn.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        btn.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
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
        view.addSubview(titleLabel)
        view.addSubview(titleTF)
        view.addSubview(descLabel)
        view.addSubview(descTF)
        view.addSubview(videoLabel)
        view.addSubview(videoIdTF)
        view.addSubview(submitButton)
    }
    
    // MARK: - Constraints
    
    let labelHeight: CGFloat = 20
    let textFieldHeight: CGFloat = 32
    let horizontalPadding: CGFloat = 20
    let labelTopPadding: CGFloat = 60
    let textFieldTopPadding: CGFloat = 20
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            titleLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            
            titleTF.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: textFieldTopPadding),
            titleTF.heightAnchor.constraint(equalToConstant: textFieldHeight),
            titleTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            titleTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            
            descLabel.topAnchor.constraint(equalTo: titleTF.topAnchor, constant: labelTopPadding),
            descLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            descLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),

            descTF.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: textFieldTopPadding),
            descTF.heightAnchor.constraint(equalToConstant: textFieldHeight),
            descTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            descTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            
            videoLabel.topAnchor.constraint(equalTo: descTF.topAnchor, constant: labelTopPadding),
            videoLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            videoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),

            videoIdTF.topAnchor.constraint(equalTo: videoLabel.bottomAnchor, constant: textFieldTopPadding),
            videoIdTF.heightAnchor.constraint(equalToConstant: textFieldHeight),
            videoIdTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            videoIdTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            
            submitButton.topAnchor.constraint(equalTo: videoIdTF.bottomAnchor, constant: 20),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.widthAnchor.constraint(equalToConstant: submitButton.intrinsicContentSize.width),
            submitButton.heightAnchor.constraint(equalToConstant: submitButton.intrinsicContentSize.height)
        ])
    }
    
    @objc
    func submitAction() {
        guard let title = titleTF.text, let description = descTF.text, let videoUrl = videoIdTF.text, let videoId = extractYoutubeIdFromLink(link: videoUrl) else { return }
        
        
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
