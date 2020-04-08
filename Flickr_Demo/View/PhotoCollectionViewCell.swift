//
//  PhotoCollectionViewCell.swift
//  Flickr_Demo
//
//  Created by EVERTRUST on 2020/4/8.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import UIKit
import SDWebImage

protocol PhotoCollectionViewCellDelegate: class {
    func photoCollectionViewCell(_ cell: PhotoCollectionViewCell, favButtonPressedAt button: UIButton)
}

class PhotoCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: PhotoCollectionViewCellDelegate?
    
    private var imageView = UIImageView {
        $0.clipsToBounds = true
    }
    
    private var titleLabel = UILabel {
        $0.textAlignment = .center
    }
    
    private lazy var favButton = UIButton(type: .system) {
        $0.setTitle("收藏", for: .normal)
        $0.isHidden = true
        $0.addTarget(self, action: #selector(favButtonPressed(_:)), for: .touchUpInside)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    private func configureUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(favButton)
        setConstraints()
    }
    
    private func setConstraints() {
        imageView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(150)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-8)
        }
        
        favButton.snp.makeConstraints { (make) in
            make.top.equalTo(4)
            make.right.equalTo(-4)
        }
    }
    
    func setContent(photo: Photo) {
        imageView.sd_setImage(with: photo.imageUrl, completed: nil)
        imageView.sd_setImage(with: photo.imageUrl) { (_, _, _, _) in
            self.favButton.isHidden = false
        }
        titleLabel.text = photo.title
    }
    
    @objc private func favButtonPressed(_ sender: UIButton) {
        delegate?.photoCollectionViewCell(self, favButtonPressedAt: sender)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
