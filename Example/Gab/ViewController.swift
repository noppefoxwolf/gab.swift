//
//  ViewController.swift
//  Gab
//
//  Created by noppefoxwolf on 08/28/2018.
//  Copyright (c) 2018 noppefoxwolf. All rights reserved.
//

import UIKit
import gab_swift

class ViewController: UITableViewController {
  let gab = Gab(username: "", password: "")
  private var feed: Feed? = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()
    gab.authorize(success: {
      print("authorized!")
    }) { (error) in
      print(error)
    }
    
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(pullToRefreshed), for: .valueChanged)
    tableView.refreshControl = refreshControl
    
    let right = UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(rightBarButtonTapped))
    navigationItem.rightBarButtonItem = right
  }
  
  @objc private func pullToRefreshed(_ sender: UIRefreshControl) {
    gab.getFeed(success: { [weak self] (feed) in
      self?.feed = feed
      DispatchQueue.main.async { [weak self] in
        self?.tableView.reloadData()
        self?.tableView.refreshControl?.endRefreshing()
      }
    }) { [weak self] (error) in
      print(error)
      DispatchQueue.main.async { [weak self] in
        self?.tableView.refreshControl?.endRefreshing()
      }
    }
  }
  
  @objc private func rightBarButtonTapped(_ sender: UIBarButtonItem) {
    let alert = UIAlertController(title: "Post", message: nil, preferredStyle: .alert)
    alert.addTextField { (_) in
      
    }
    alert.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
    alert.addAction(.init(title: "Send", style: .default, handler: { [weak self] (_) in
      guard let text = alert.textFields?.first?.text else { return }
      self?.gab.postPosts(body: text)
    }))
    present(alert, animated: true, completion: nil)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return feed?.data.count ?? 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = feed?.data[indexPath.row].post.body
    return cell
  }
}

