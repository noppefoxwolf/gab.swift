//
//  Gab.swift
//  Gab
//
//  Created by Tomoya Hirano on 2018/08/28.
//

import Foundation

public class Gab: NSObject {
  internal let username: String
  internal let password: String
  internal var allHeaderFields: [String : String]? = nil
  internal let configuration = URLSessionConfiguration.ephemeral
  
  public init(username: String, password: String) {
    self.username = username
    self.password = password
    super.init()
  }
  
  public var authorized: Bool {
    //TODO: check expired
    return allHeaderFields != nil
  }
}
