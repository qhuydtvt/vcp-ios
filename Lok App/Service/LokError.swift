//
//  LokError.swift
//  Lok App
//
//  Created by Vũ Kiên on 13/03/2018.
//  Copyright © 2018 LOK. All rights reserved.
//

import Foundation

enum LokServiceError<Text, Number> {
    case client(Text, Number)
    case server(Text, Number)
    case other(Text)
}

extension LokServiceError: Error  {
    var localizedDescription: String {
        switch self {
        case .client(let message, let status):
            return "Lok error \(status): \(message)"
        case .server(let message, let status):
            return "Lok error \(status): \(message)"
        case .other(let message):
            return "Lok error: \(message)"
        }
    }
}
