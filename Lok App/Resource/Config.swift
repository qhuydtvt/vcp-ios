//
//  Config.swift
//  Lok App
//
//  Created by Vũ Kiên on 13/03/2018.
//  Copyright © 2018 LOK. All rights reserved.
//

import Foundation

struct Config {
    static let `default` = Config()
    
    fileprivate init() {}
    
    fileprivate func dictionary() -> NSDictionary {
        let path = Bundle.main.path(forResource: "Config", ofType: "plist")
        return NSDictionary(contentsOfFile: path!)!
    }
    
    func getUrl() -> String {
        let dictionary = self.dictionary()
        return dictionary.object(forKey: "base_url") as! String
    }
    
    func get<T>(key: String) -> T {
        let dictionary = self.dictionary()
        return dictionary.object(forKey: key) as! T
    }
}
