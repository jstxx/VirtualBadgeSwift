//
//  Error+Path.swift
//  VirtualBadge2
//
//  Created by Justin Savory on 12/9/16.
//  Copyright © 2016 Pathfinders. All rights reserved.
//

import Foundation

let errorDomain = "com.pathfinders.error"

enum ErrorCode: Int {
    case noDataError = 101
    case parsingError = 102
    case requestConstructionError = 103
}

extension NSError {
    convenience init(code: ErrorCode, userInfo: [AnyHashable: Any]?) {
        self.init(domain: errorDomain, code: code.rawValue, userInfo: userInfo)
    }
}
