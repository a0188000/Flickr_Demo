//
//  MainViewController.swift
//  Flickr_Demo
//
//  Created by EVERTRUST on 2020/4/8.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    private var vStackView = UIStackView {
        $0.axis = .vertical
        $0.spacing = 16
    }
    
    private lazy var pageTextField = UITextField {
        $0.borderStyle = .roundedRect
        $0.placeholder = "每頁呈現數量"
        $0.keyboardType = .numberPad
        $0.addTarget(self, action: #selector(textFieldEditChanged(_:)), for: .editingChanged)
    }
    
    private lazy var contentTextField = UITextField {
        $0.borderStyle = .roundedRect
        $0.placeholder = "欲搜尋內容"
        $0.addTarget(self, action: #selector(textFieldEditChanged(_:)), for: .editingChanged)
    }
    
    private lazy var searchButton = UIButton {
        $0.setTitle("搜尋", for: .normal)
        $0.backgroundColor = .blue
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(searchButtonPressed(_:)), for: .touchUpInside)
        $0.setBackgroundImage(GeneralHelper.getImage(.blue, size: .init(width: 1, height: 34)), for: .normal)
        $0.setBackgroundImage(GeneralHelper.getImage(.lightGray, size: .init(width: 1, height: 34)), for: .disabled)
    }
    
    private let vm = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "搜尋輸入頁"
        view.backgroundColor = .white
        configureUI()
        binding()
    }

    private func configureUI() {
        vStackView.addArrangedSubview(contentTextField)
        vStackView.addArrangedSubview(pageTextField)
        vStackView.addArrangedSubview(searchButton)
        
        view.addSubview(vStackView)
        vStackView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.equalTo(16)
            make.right.equalTo(-16)
        }
    }
    
    private func binding() {
        vm.searchButtonEnableObservable = { [weak self] enable in
            self?.searchButton.isEnabled = enable
        }
    }

    private func presentToAuthViewCtrl() {
        let authViewCtrl = AuthViewController()
        authViewCtrl.authorizationCallback = { [weak self] in
            self?.askAuthorization()
        }
        present(authViewCtrl, animated: true, completion: nil)
    }
    
    @objc private func textFieldEditChanged(_ textField: UITextField) {
        switch textField {
        case contentTextField:  vm.contentText = textField.text ?? ""
        case pageTextField:     vm.pageText = textField.text ?? ""
        default: return
        }
    }
    
    @objc private func searchButtonPressed(_ sender: UIButton) {
        view.endEditing(false)
        askAuthorization()
    }
}

extension MainViewController {
    private func askAuthorization() {
        if FlickrHelper.shared.isAuthorized {
            let photoListViewCtrl = PhotoListViewController(text: vm.contentText, page: vm.pageText)
            photoListViewCtrl.haveNewPhotoIntoDatabaseCallback = {
                
            }
            navigationController?.pushViewController(photoListViewCtrl, animated: true)
        } else {
            presentToAuthViewCtrl()
        }
    }
}
