//
//  GeneralHelper.swift
//  Flickr_Demo
//
//  Created by EVERTRUST on 2020/4/8.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import UIKit

class GeneralHelper {
    static func getImage(_ color: UIColor, size: CGSize) -> UIImage? {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let output = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return output
    }
}
