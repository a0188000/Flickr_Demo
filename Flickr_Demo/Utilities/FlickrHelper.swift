//
//  FlickrHelper.swift
//  Flickr_Demo
//
//  Created by EVERTRUST on 2020/4/8.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import UIKit
import FlickrKit

class FlickrHelper {
    static let shared = FlickrHelper()
    
    private(set) var apiKey = "89cb47912f249904cedef56a36c1f3f5"
    private(set) var secret = "1dff3b8b1b4e4871"
    
    var isAuthorized: Bool {
        return FlickrKit.shared().isAuthorized
    }
    var completetAuthOp: FKDUNetworkOperation?
    var checkAuthOp: FKDUNetworkOperation?
    
    func initialize() {
        FlickrKit.shared().initialize(withAPIKey: apiKey, sharedSecret: secret)
        checkAuthoriation()
    }
    
    func beginAuth(callbackURL url: URL, permission: FKPermission = .delete, completion: @escaping FKAPIAuthBeginCompletion) {
        FlickrKit.shared().beginAuth(withCallbackURL: url, permission: permission, completion: completion)
    }
    
    func checkAuthentication(url: URL, complection: @escaping FKAPIAuthCompletion) {
        completetAuthOp = FlickrKit.shared().completeAuth(with: url, completion: complection)
    }
    
    func checkAuthoriation() {
        checkAuthOp = FlickrKit.shared().checkAuthorization(onCompletion: { (userName, userId, fullName, error) in
            if let error = error {
                print("尚未驗證")
            } else {
                print("check auth success.")
            }
        })
    }
    
    func search(_ text: String, page: String, completionHandler: @escaping (_ photoURLs: [Photo]) -> Void) {
        FlickrKit.shared().call("flickr.photos.search", args: ["text": "\(text)", "per_page": "\(page)"]) { (response, error) in
            guard
                let response = response,
                let photos = response["photos"] as? [String: Any],
                let photoArr = photos["photo"] as? [[String: Any]]
            else { return }
            
            let photo = photoArr.map { Photo(dictionary: $0) }
            DispatchQueue.main.async {
                completionHandler(photo)
            }
        }
    }
}
