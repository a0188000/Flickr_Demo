//
//  PhotoListViewController.swift
//  Flickr_Demo
//
//  Created by EVERTRUST on 2020/4/8.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import UIKit

class PhotoListViewController: UIViewController {

    var haveNewPhotoIntoDatabaseCallback = { () -> Void in }
    
    var collectionView: UICollectionView?
    var photos = [Photo]()
    
    convenience init(text: String, page: String) {
        self.init()
        search(text, page: page)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        configureUI()
    }

    private func configureUI() {
        self.configureCollectionView()
    }
    
    private func configureCollectionView() {
        let collectionView = UICollectionView(layout: UICollectionViewFlowLayout()) {
            $0.backgroundColor = .white
            $0.register(cellType: PhotoCollectionViewCell.self)
            $0.delegate = self
            $0.dataSource = self
        }
        
        self.collectionView = collectionView
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func search(_ text: String, page: String) {
        FlickrHelper.shared.search(text, page: page, completionHandler: { photos in
            self.photos = photos
            self.collectionView?.reloadData()
        })
    }
}

extension PhotoListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(cell: PhotoCollectionViewCell.self, forIndexPath: indexPath)
        cell.setContent(photo: photos[indexPath.row])
        cell.delegate = self
        return cell
    }
}

extension PhotoListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: (view.bounds.width - 4) / 2, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
}

extension PhotoListViewController: PhotoCollectionViewCellDelegate {
    func photoCollectionViewCell(_ cell: PhotoCollectionViewCell, favButtonPressedAt button: UIButton) {
        guard let row = collectionView?.indexPath(for: cell)?.row else { return }
        RealmHelper.shared.update(object: photos[row], completionHandler: {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            appDelegate.favPhotoListViewCtrl.reloadData()
        }, failedHandler: nil)
    }
}
