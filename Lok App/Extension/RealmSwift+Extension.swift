//
//  RealmSwift+Extension.swift
//  Lok App
//
//  Created by Vũ Kiên on 13/03/2018.
//  Copyright © 2018 LOK. All rights reserved.
//

import Foundation
import RealmSwift

extension Object {
    static func build<O: Object>(_ builder: (O) -> ()) -> O {
        let object = O()
        builder(object)
        return object
    }
}
