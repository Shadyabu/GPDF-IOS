//
//  ViewController.swift
//  DruckerForumWebview
//
//  Created by Shady on 23.06.20.
//  Copyright © 2020 imc. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    
    @IBAction func swiperight(_ sender: Any) {
        webView.goBack()
    }
    
    
    private lazy var url = URL(string: "https://www.druckerforum.org")!
    private weak var webView: WKWebView!

    init (url: URL, configuration: WKWebViewConfiguration) {
        super.init(nibName: nil, bundle: nil)
        self.url = url
        navigationItem.title = ""
    }

    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }

    override func viewDidLoad() {
        super.viewDidLoad()
        initWebView()
        webView.loadPage(address: url)
        
        let swipeLeftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(recognizer:)))
            let swipeRightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(recognizer:)))
            swipeLeftRecognizer.direction = .left
            swipeRightRecognizer.direction = .right

            webView.addGestureRecognizer(swipeLeftRecognizer)
            webView.addGestureRecognizer(swipeRightRecognizer)
        }

        @objc private func handleSwipe(recognizer: UISwipeGestureRecognizer) {
            if (recognizer.direction == .left) {
                if webView.canGoForward {
                    webView.goForward()
                }
            }

            if (recognizer.direction == .right) {
                if webView.canGoBack {
                    webView.goBack()
                }
            }
    }

    private func initWebView() {
        let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        view.addSubview(webView)
        self.webView = webView
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        webView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
    }
}



extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let host = webView.url?.host else { return }
        navigationItem.title = host
    }
}

extension ViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        guard   navigationAction.targetFrame == nil,
                let url =  navigationAction.request.url else { return nil }
        let vc = ViewController(url: url, configuration: configuration)
        if let navigationController = navigationController {
            navigationController.pushViewController(vc, animated: false)
            return vc.webView
        }
        present(vc, animated: true, completion: nil)
        return nil
    }
}

extension WKWebView {
    func loadPage(address url: URL) { load(URLRequest(url: url)) }
    func loadPage(address urlString: String) {
        guard let url = URL(string: urlString) else { return }
        loadPage(address: url)
    }
}
