//
//  MainViewModel.swift
//  Flickr_Demo
//
//  Created by EVERTRUST on 2020/4/8.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import UIKit

class MainViewModel {
    var searchButtonEnableObservable = { (_ enable: Bool) -> Void in }
    
    var contentText: String = "" {
        didSet {
            updateSearchButtonEnableStatus()
        }
    }
    
    var pageText: String = "" {
        didSet {
            updateSearchButtonEnableStatus()
        }
    }
    
    private func updateSearchButtonEnableStatus() {
        searchButtonEnableObservable(!contentText.isEmpty && contentText != "" && !pageText.isEmpty && pageText != "")
    }
}

