//
//  Gab.swift
//  Gab
//
//  Created by Tomoya Hirano on 2018/08/28.
//

import Foundation

public class Gab: NSObject {
  private let username: String
  private let password: String
  private var allHeaderFields: [String : String]? = nil
  private let configuration = URLSessionConfiguration.ephemeral
  
  public init(username: String, password: String) {
    self.username = username
    self.password = password
    super.init()
  }
  
  public var authorized: Bool {
    //TODO: check expired
    return allHeaderFields != nil
  }
  
  public func fetch(success: (() -> Void)? = nil,
                    failure: ((Error) -> Void)? = nil) {
    let username = self.username
    let password = self.password
    let url = URL(string: "https://gab.ai/auth/login")!
    URLSession(configuration: configuration).dataTask(with: url) { [weak self] (data, response, error) in
      if let error = error {
        failure?(error)
        return
      }
      guard let response = response as? HTTPURLResponse else {
        //TODO: return custom error
        failure?(NSError())
        return
      }
      guard response.statusCode == 200 else {
        failure?(NSError())
        return
      }
      guard let data = data, let body = String(data: data, encoding: .utf8), let token = body.token else {
        //TODO: return custom error
        failure?(NSError())
        return
      }
      
      guard let allHeaderFields = response.allHeaderFields as? [String : String] else {
        failure?(NSError())
        return
      }
      self?.login(token: token, username: username, password: password, allHeaderFields: allHeaderFields, success: success, failure: failure)
      }.resume()
  }
  
  private func login(token: String,
                     username: String,
                     password: String,
                     allHeaderFields: [String : String],
                     success: (() -> Void)? = nil,
                     failure: ((Error) -> Void)? = nil) {
    let url = URL(string: "https://gab.ai/auth/login")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = allHeaderFields
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.httpBody = "_token=\(token)&password=\(password)&username=\(username)".data(using: .utf8)!
    URLSession(configuration: configuration).dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
      guard let response = response as? HTTPURLResponse else {
        //TODO: return custom error
        failure?(NSError())
        return
      }
      guard response.statusCode == 200 else {
        failure?(NSError())
        return
      }
      guard let allHeaderFields = response.allHeaderFields as? [String : String] else {
        failure?(NSError())
        return
      }
      self?.allHeaderFields = allHeaderFields
      success?()
    }).resume()
  }
  
  public func postPosts(body: String,
                        success: (() -> Void)? = nil,
                        failure: ((Error) -> Void)? = nil) {
    post(url: "https://gab.ai/posts",
         params: ["body" : body],
         success: success,
         failure: failure)
  }
  
  private func post(url: String,
                    params: [String : Any],
                    success: (() -> Void)? = nil,
                    failure: ((Error) -> Void)? = nil) {
    let url = URL(string: url)!
    var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
    components.queryItems = params.map({ URLQueryItem(name: $0.key, value: String(describing: $0.value)) })
    var request = URLRequest(url: components.url!)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = allHeaderFields
    URLSession(configuration: configuration).dataTask(with: request, completionHandler: { (data, response, error) in
      guard let response = response as? HTTPURLResponse else {
        //TODO: return custom error
        failure?(NSError())
        return
      }
      guard response.statusCode == 200 else {
        failure?(NSError())
        return
      }
      success?()
    }).resume()
  }
}

extension String {
  fileprivate var token: String? {
    guard let regex = try? NSRegularExpression(pattern: "name=\"_token\" value=\"(.*)\"") else { return nil }
    guard let match = regex.firstMatch(in: self, options: .init(), range: NSRange(location: 0, length: count)) else { return nil }
    return (self as NSString).substring(with: match.range(at: 1))
  }
}
