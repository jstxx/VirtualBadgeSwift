//
//  Environment.swift
//  VirtualBadge2
//
//  Created by Justin Savory on 12/8/16.
//  Copyright © 2016 Pathfinders. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let environmentDidChange = Notification.Name(rawValue: "environmentDidChange")
}

/// An enumeration of possible development / production environments.
enum Environment:String {
    
    static func changeCurrentEnvironment(to newEnvironment: Environment) {
        currentEnvironment = newEnvironment
        NotificationCenter.default.post(name: Notification.Name.environmentDidChange, object: nil)
    }
    
    #if DEBUG
    static var currentEnvironment: Environment = .staging
    #else
    static var currentEnvironment: Environment = .production
    #endif
    
    
    case production
    case staging
    
    var url: String {
        switch self {
        case .production: return "https://www.virtualbadge.com"
        case .staging: return "https://dev.virtualbadge.com"
        }
    }
    
    var Secret: String {
        switch self {
        case .production: return ""
        case .staging: return ""
        }
    }
}
