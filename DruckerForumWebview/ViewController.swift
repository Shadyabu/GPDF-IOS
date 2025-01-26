import UIKit
import WebKit

class ViewController: UIViewController {

    private var splashScreenImageView: UIImageView!
    private weak var webView: WKWebView!
    
    private lazy var url = URL(string: "https://www.druckerforum.org")!

    init(url: URL, configuration: WKWebViewConfiguration) {
        super.init(nibName: nil, bundle: nil)
        self.url = url
        navigationItem.title = ""
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Step 1: Add a white background layer
        setupBackgroundLayer()
        
        // Step 2: Setup Splash Screen Image (on top of the background layer)
        setupSplashScreen()
        
        // Step 3: Setup WebView (keep it hidden initially)
        setupWebView()
        
        // Step 4: Start loading the web page
        loadWebPage()
    }

    // Create a white background layer
    private func setupBackgroundLayer() {
        let backgroundLayer = UIView()
        backgroundLayer.translatesAutoresizingMaskIntoConstraints = false
        backgroundLayer.backgroundColor = .white
        
        view.addSubview(backgroundLayer)
        
        // Make the background layer fill the entire view
        NSLayoutConstraint.activate([
            backgroundLayer.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundLayer.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundLayer.rightAnchor.constraint(equalTo: view.rightAnchor),
            backgroundLayer.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // Setup Splash Screen Image (on top of the background)
    private func setupSplashScreen() {
        splashScreenImageView = UIImageView(image: UIImage(named: "GpdfSplashScreen"))
        splashScreenImageView.contentMode = .scaleAspectFit
        splashScreenImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(splashScreenImageView)
        
        // Set constraints for the splash screen image
        NSLayoutConstraint.activate([
            splashScreenImageView.topAnchor.constraint(equalTo: view.topAnchor),
            splashScreenImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            splashScreenImageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            splashScreenImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // Setup WKWebView but keep it hidden initially
    private func setupWebView() {
        let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        self.webView = webView
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.alpha = 0  // Keep it hidden until the page loads

        // Add WKWebView to the view hierarchy
        view.addSubview(webView)

        // Add constraints for WKWebView to fill the view
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            webView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    // Start loading the web page
    private func loadWebPage() {
        webView.loadPage(address: url)
    }

    // Hide splash screen and show WebView after the page finishes loading
    private func hideSplashScreenAndShowWebView() {
        // Delay the splash screen fade-out to make it more seamless
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Fade out the splash screen
            UIView.animate(withDuration: 0.5, animations: {
                self.splashScreenImageView.alpha = 0
            }) { _ in
                // Remove splash screen after fade-out completes
                self.splashScreenImageView.removeFromSuperview()
            }
            
            // Fade in WebView after splash screen fades out
            UIView.animate(withDuration: 0.5) {
                self.webView.alpha = 1
            }
        }
    }
}

extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Hide splash screen and show WebView after page finishes loading
        hideSplashScreenAndShowWebView()
        
        guard let host = webView.url?.host else { return }
        navigationItem.title = host
    }
}

extension ViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        guard navigationAction.targetFrame == nil, let url = navigationAction.request.url else { return nil }
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
