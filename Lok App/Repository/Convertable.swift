//
//  Convertable.swift
//  Lok App
//
//  Created by Vũ Kiên on 13/03/2018.
//  Copyright © 2018 LOK. All rights reserved.
//

import Foundation
protocol ModelConvertable: class {
    associatedtype Model
    
    func asDomain() -> Model
}

protocol ObjectConvertable: class {
    associatedtype Object
    
    func asObject() -> Object
}
