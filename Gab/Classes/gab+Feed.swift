//
//  gab+feed.swift
//  gab.swift
//
//  Created by Tomoya Hirano on 2018/08/28.
//

extension Gab {
  public func getFeed(success: ((Feed) -> Void)? = nil,
                      failure: ((Error) -> Void)? = nil) {
    get(url: "https://gab.ai/feed",
        params: [:],
        success: success,
        failure: failure)
  }
}
