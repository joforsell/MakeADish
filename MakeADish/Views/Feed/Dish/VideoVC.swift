//
//  VideoVC.swift
//  MakeADish
//
//  Created by Johan Forsell on 2022-06-08.
//

import UIKit
import WebKit

class VideoVC: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    var videoId: String? = nil
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = true
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let videoId = videoId else { return }
        loadVideo(with: videoId)
    }
    
    func loadVideo(with videoId: String) {
        guard let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoId)") else { return }
        webView.load(URLRequest(url: youtubeURL))
    }
}
