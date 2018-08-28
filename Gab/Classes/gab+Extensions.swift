//
//  gab+Extensions.swift
//  gab.swift
//
//  Created by Tomoya Hirano on 2018/08/28.
//

import Foundation

extension Gab {
  @available(iOS 10.0, *)
  internal func get<T: Decodable>(url: String,
                                  params: [String : Any],
                                  success: ((T) -> Void)? = nil,
                                  failure: ((Error) -> Void)? = nil) {
    let url = URL(string: url)!
    var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
    components.queryItems = params.map({ URLQueryItem(name: $0.key, value: String(describing: $0.value)) })
    var request = URLRequest(url: components.url!)
    request.httpMethod = "GET"
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
      guard let data = data else {
        failure?(NSError())
        return
      }
      do {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let obj = try decoder.decode(T.self, from: data)
        success?(obj)
      } catch {
        failure?(error)
      }
    }).resume()
  }
  
  internal func post(url: String,
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
