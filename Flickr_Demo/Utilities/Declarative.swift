//
//  Declarative.swift
//  Flickr_Demo
//
//  Created by EVERTRUST on 2020/4/8.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import UIKit

protocol Declarative {
    init()
}

extension NSObject: Declarative { }

extension Declarative where Self: NSObject {
    init(_ completionHandler: (Self) -> Void) {
        self.init()
        completionHandler(self)
    }
}

extension Declarative where Self: UIButton {
    init(type: UIButton.ButtonType, _ completionHandler: (Self) -> Void) {
        self.init(type: type)
        completionHandler(self)
    }
}

extension Declarative where Self: UICollectionView {
    init(layout: UICollectionViewFlowLayout, _ completionHandler: (Self) -> Void) {
        self.init(frame: .zero, collectionViewLayout: layout)
        completionHandler(self)
    }
}
