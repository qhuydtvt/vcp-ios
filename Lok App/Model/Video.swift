//
//  Video.swift
//  Lok App
//
//  Created by Vũ Kiên on 15/03/2018.
//  Copyright © 2018 LOK. All rights reserved.
//

import Foundation
import RealmSwift

class Video {
    var id: Int = -1
    var title: String = ""
    var link: String = ""
    var duration: Double = 0.0
    var uploadDate: Date = Date()
    var videoId: Int = -1
    var views: Int = 0
    var thumbnail: String = ""
    var description: String = ""
    var author: String = ""
}

extension Video: ObjectConvertable {
    typealias Object = VideoObject
    
    func asObject() -> VideoObject {
        return Object.build({ [weak self] (object) in
            guard let video = self else {
                return
            }
            object.id = video.id
            object.title = video.title
            object.link = video.link
            object.duration = video.duration
            object.uploadDate = video.uploadDate
            object.videoId = video.videoId
            object.views = video.views
            object.thumbnail = video.thumbnail
            object.descriptionVideo = video.description
            object.author = video.author
        })
    }
}

class VideoObject: Object {
    @objc dynamic var id: Int = -1
    @objc dynamic var title: String = ""
    @objc dynamic var link: String = ""
    @objc dynamic var duration: Double = 0.0
    @objc dynamic var uploadDate: Date = Date()
    @objc dynamic var videoId: Int = -1
    @objc dynamic var views: Int = 0
    @objc dynamic var thumbnail: String = ""
    @objc dynamic var descriptionVideo: String = ""
    @objc dynamic var author: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

extension VideoObject: ModelConvertable {
    typealias Model = Video
    
    func asDomain() -> Video {
        let video = Video()
        video.id = self.id
        video.title = self.title
        video.link = self.link
        video.duration = self.duration
        video.uploadDate = self.uploadDate
        video.videoId = self.videoId
        video.views = self.views
        video.thumbnail = self.thumbnail
        video.description = self.descriptionVideo
        video.author = self.author
        return video
    }
}
