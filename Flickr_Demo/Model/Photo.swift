//
//  Photo.swift
//  Flickr_Demo
//
//  Created by EVERTRUST on 2020/4/8.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import UIKit
import RealmSwift

@objcMembers
class Photo: Object {
    
    dynamic var id: String      = ""
    dynamic var farm: Int       = 66
    dynamic var secret: String  = ""
    dynamic var server: String  = ""
    dynamic var title: String   = ""
    
    var imageUrl: URL {
       return URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg")!
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    init(dictionary: [String: Any]) {
        self.farm = dictionary["farm"] as? Int ?? 66
        self.secret = dictionary["secret"] as? String ?? ""
        self.id = dictionary["id"] as? String ?? ""
        self.server = dictionary["server"] as? String ?? ""
        self.title = dictionary["title"] as? String ?? ""
    }
    
    required init() {
        
    }
}
