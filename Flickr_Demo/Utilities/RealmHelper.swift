//
//  RealmHelper.swift
//  Flickr_Demo
//
//  Created by EVERTRUST on 2020/4/8.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import RealmSwift

typealias RealmCompletionHandler = (() -> Void)?
typealias RealmFailedHandler = ((Error) -> Void)?

protocol RealmManageable {
    var realm: Realm? { get }
    func fetch<T: Object>(type: T.Type) -> [T]
    func update<T: Object>(object: T,
                           completionHandler: RealmCompletionHandler,
                           failedHandler: RealmFailedHandler)
    func delete<T: Object>(type: T.Type,
                           primaryKey: Any,
                           completionHandler: RealmCompletionHandler,
                           failedHandler: RealmFailedHandler)
}

class RealmHelper: RealmManageable {
    static let shared = RealmHelper()
    
    var realm: Realm?
    
    private init() {
        var conf = Realm.Configuration()
        conf.fileURL = conf.fileURL?.deletingLastPathComponent().appendingPathComponent("flickr.realm")
        Realm.Configuration.defaultConfiguration = conf
        
        do {
            try self.realm = Realm()
        } catch {
            print("Create realm db failed: \(error.localizedDescription)")
        }
    }
    
    private func execute(_ block: () -> Void, failedHandler: RealmFailedHandler = nil) {
        do {
            try self.realm?.write { block() }
        } catch {
            failedHandler?(error)
        }
    }
    
    func fetch<T: Object>(type: T.Type) -> [T] {
        guard let objects = self.realm?.objects(type) else { return [] }
        return Array(objects).map { $0.unmanagedCopy() }
    }
    
    func update<T: Object>(object: T,
                           completionHandler: RealmCompletionHandler,
                           failedHandler: RealmFailedHandler) {
        self.execute({
            self.realm?.add(object, update: .all)
            completionHandler?()
        }, failedHandler: failedHandler)
    }
    
    func delete<T: Object>(type: T.Type,
                           primaryKey: Any,
                           completionHandler: RealmCompletionHandler,
                           failedHandler: RealmFailedHandler) {
        guard let object = self.realm?.object(ofType: type, forPrimaryKey: primaryKey) else { return }
        self.execute({
            self.realm?.delete(object)
            completionHandler?()
        }, failedHandler: failedHandler)
    }
}

protocol UnmanagedCopy {
    func unmanagedCopy() -> Self
}

extension Object: UnmanagedCopy {
    func unmanagedCopy() -> Self {
        let o = type(of: self).init()
        for p in objectSchema.properties {
            let value = self.value(forKey: p.name)
            switch p.type {
            case .linkingObjects: break
            default:
                o.setValue(value, forKey: p.name)
            }
        }
        return o
    }
}
