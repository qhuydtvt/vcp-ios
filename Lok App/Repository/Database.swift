//
//  Database.swift
//  Lok App
//
//  Created by Vũ Kiên on 13/03/2018.
//  Copyright © 2018 LOK. All rights reserved.
//

import Foundation
import RealmSwift

class Database {
    
    var realm: Realm?
    
    init() {
        do {
            self.realm = try Realm()
        } catch {
            print("error: \(error.localizedDescription)")
        }
        print(Realm.Configuration.defaultConfiguration.fileURL?.path ?? "")
    }
}
