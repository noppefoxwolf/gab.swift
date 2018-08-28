//
//  gab+post.swift
//  gab.swift
//
//  Created by Tomoya Hirano on 2018/08/28.
//

import UIKit

extension Gab {
  public func postPosts(body: String,
                        success: (() -> Void)? = nil,
                        failure: ((Error) -> Void)? = nil) {
    post(url: "https://gab.ai/posts",
         params: ["body" : body],
         success: success,
         failure: failure)
  }
}
