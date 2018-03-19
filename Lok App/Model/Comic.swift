//
//  Comic.swift
//  Lok App
//
//  Created by Vũ Kiên on 13/03/2018.
//  Copyright © 2018 LOK. All rights reserved.
//

import Foundation
import RealmSwift

class Comic {
    var id: Int = -1
    var title: String = ""
    var images: [String] = []
    var createDate: Date = Date()
    
    init(id: Int, title: String, images: [String]) {
        self.id = id
        self.title = title
        self.images = images
    }
    
    init() {
    }
}

extension Comic: ObjectConvertable {
    typealias Object = ComicObject
    
    func asObject() -> ComicObject {
        return ComicObject.build({ [weak self] (object) in
            guard let comic = self else {
                return
            }
            object.id = comic.id
            object.title = comic.title
            comic.images.forEach({object.images.append($0)})
            object.createDate = comic.createDate
        })
    }
}

class ComicObject: Object {
    @objc dynamic var id: Int = -1
    @objc dynamic var title: String = ""
    let images: List<String> = List<String>()
    @objc dynamic var createDate: Date = Date()
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

extension ComicObject: ModelConvertable {
    typealias Model = Comic
    
    func asDomain() -> Comic {
        let commic = Comic()
        commic.id = self.id
        commic.title = self.title
        self.images.forEach({commic.images.append($0)})
        commic.createDate = self.createDate
        return commic
    }
}
