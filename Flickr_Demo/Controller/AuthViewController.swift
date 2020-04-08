//
//  AuthViewController.swift
//  Flickr_Demo
//
//  Created by EVERTRUST on 2020/4/8.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {

    var authorizationCallback = { () -> Void in }
    
    private var webView: UIWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        configureUI()
        beginAuth()
        bindCheckAuthentication()
    }
    
    private func configureUI() {
        self.configureWebView()
    }
    
    private func configureWebView() {
        let webView = UIWebView {
            $0.delegate = self
        }
        self.webView = webView
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    private func beginAuth() {
        guard let callbackURL = URL(string: "flickr://auth") else { return }
        FlickrHelper.shared.beginAuth(callbackURL: callbackURL, permission: .delete, completion: { url, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("begin auth failed: \(error.localizedDescription)")
                } else {
                    self.loadURL(url)
                }
            }
        })
    }
    
    private func bindCheckAuthentication() {
        NotificationCenter.default.addObserver(forName: .init("UserAuthCallback"), object: nil, queue: .main, using: { notification in
            guard let callbackURL = notification.object as? URL else { return }
            FlickrHelper.shared.checkAuthentication(url: callbackURL) { (_, _, _, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        print("check atuentication failed: \(error.localizedDescription)")
                    } else {
                        self.authorizationCallback()
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        })
    }
    
    private func loadURL(_ url: URL?) {
        guard let url = url else { return }
        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
        webView?.loadRequest(request)
    }
}

extension AuthViewController: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        guard let url = request.url else { return true }
        if !(url.scheme == "http") && !(url.scheme == "https")  {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                return false
            }
        }
        print("url :\(url.absoluteString)")
        return true
    }
}
