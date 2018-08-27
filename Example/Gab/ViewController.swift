//
//  ViewController.swift
//  Gab
//
//  Created by noppefoxwolf on 08/28/2018.
//  Copyright (c) 2018 noppefoxwolf. All rights reserved.
//

import UIKit
import Gab

class ViewController: UIViewController {
  let gab = Gab(username: "username", password: "password")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    gab.fetch(success: {
      print("authorized!")
      self.gab.postPosts(body: "Hello world!!")
    }) { (error) in
      print(error)
    }
  }
}

