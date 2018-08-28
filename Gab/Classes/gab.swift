//
//  Gab.swift
//  Gab
//
//  Created by Tomoya Hirano on 2018/08/28.
//

import Foundation

public struct Signature {
  public let allHeaderFields: [String : String]
}


public class Gab: NSObject {
  internal let username: String
  internal let password: String
  internal var signature: Signature? = nil
  internal let configuration = URLSessionConfiguration.ephemeral
  
  public init(username: String, password: String) {
    self.username = username
    self.password = password
    super.init()
  }
  
  public init(username: String, password: String, signature: Signature) {
    self.username = username
    self.password = password
    self.signature = signature
    super.init()
  }
  
  public var authorized: Bool {
    //TODO: check expired
    return signature != nil
  }
}
