//
//  gab+UI.swift
//  gab.swift
//
//  Created by Tomoya Hirano on 2018/08/28.
//

import UIKit
import WebKit

final public class AuthorizeViewController: UIViewController, WKNavigationDelegate {
  private lazy var webView: WKWebView = .init(frame: view.bounds)
  private lazy var successHandler: ((Signature) -> Void)? = nil
  private lazy var failureHandler: ((Error?) -> Void)? = nil
  
  public static func authorize(_ viewController: UIViewController,
                        success: ((Signature) -> Void)? = nil,
                        failure: ((Error?) -> Void)? = nil) {
    let vc = AuthorizeViewController()
    let nc = UINavigationController(rootViewController: vc)
    vc.successHandler = success
    vc.failureHandler = failure
    viewController.present(nc, animated: true, completion: nil)
  }
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(webView)
    
    let url = URL(string: "https://gab.ai/auth/login")!
    let request = URLRequest(url: url)
    webView.load(request)
    webView.navigationDelegate = self
    
    let left = UIBarButtonItem(barButtonSystemItem: .cancel,
                               target: self,
                               action: #selector(leftButtonTapped))
    navigationItem.leftBarButtonItem = left
  }
  
  public func webView(_ webView: WKWebView,
                      decidePolicyFor navigationResponse: WKNavigationResponse,
                      decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
    let response = navigationResponse.response as! HTTPURLResponse
    let allHeaderFields = response.allHeaderFields as! [String : String]
    if allHeaderFields["Set-Cookie"] != nil {
      dismiss(animated: true) { [weak self] in
        self?.successHandler?(Signature(allHeaderFields: allHeaderFields))
      }
    }
    decisionHandler(.allow)
  }
  
  @objc private func leftButtonTapped(_ sender: UIBarButtonItem) {
    failureHandler?(nil)
  }
}
