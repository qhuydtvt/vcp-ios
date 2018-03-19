//
//  VideoService.swift
//  Lok App
//
//  Created by Vũ Kiên on 16/03/2018.
//  Copyright © 2018 LOK. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import SwiftyJSON

extension Service {
    struct Video {
        static func videos(with page: Int) -> Observable<Video> {
            return Service
                .shared
                .setPathUrl(path: "")
                .withParameters(key: "page", value: page)
                .request()
                .flatMap({ (json) -> Observable<Video> in
                    return Observable.empty()
                })
        }
    }
}
