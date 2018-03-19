//
//  Color.swift
//  Lok App
//
//  Created by Vũ Kiên on 13/03/2018.
//  Copyright © 2018 LOK. All rights reserved.
//

import Foundation
import UIKit

extension Lok.Color {
    struct Home {
        struct TabBar {}
    }
}

extension Lok.Color.Home {
    static let MENU_TINT = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
}

extension Lok.Color.Home.TabBar {
    static let SELECTED = #colorLiteral(red: 0.3368579447, green: 0.8516452909, blue: 0.8836043477, alpha: 1)
    static let DESELECTED = #colorLiteral(red: 0.6922486424, green: 0.6922651529, blue: 0.6922562718, alpha: 1)
}
