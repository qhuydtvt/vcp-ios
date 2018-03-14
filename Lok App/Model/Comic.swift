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
    var images: [String] = []
    
    init(id: Int, images: [String]) {
        self.id = id
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
            comic.images.forEach({object.images.append($0)})
        })
    }
}

class ComicObject: Object {
    @objc dynamic var id: Int = -1
    let images: List<String> = List<String>()
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

extension ComicObject: ModelConvertable {
    typealias Model = Comic
    
    func asDomain() -> Comic {
        let commic = Comic()
        commic.id = self.id
        self.images.forEach({commic.images.append($0)})
        return commic
    }
}
