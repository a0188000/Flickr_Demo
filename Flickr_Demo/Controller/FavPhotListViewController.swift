//
//  FavPhotListViewController.swift
//  Flickr_Demo
//
//  Created by EVERTRUST on 2020/4/8.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import UIKit

class FavPhotListViewController: PhotoListViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 1)
        fetchPhoto()
    }
    
    private func fetchPhoto() {
        photos = RealmHelper.shared.fetch(type: Photo.self)
        collectionView?.reloadData()
    }
    
    func reloadData() {
        self.fetchPhoto()
    }
}
