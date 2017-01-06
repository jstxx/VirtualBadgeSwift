//
//  User.swift
//  VirtualBadge2
//
//  Created by Justin Savory on 12/8/16.
//  Copyright © 2016 Pathfinders. All rights reserved.
//

import Gloss
import Cache

struct User: Decodable {
    
  //  typealias CacheType = User
    
    
    let token: String?
    let displayName: String?
    let email: String?
    let firstName: String?
    let lastName: String?
    let badgeImage: String?
    
    
//    static func decode(_ data: Data) -> CacheType? {
//        var object: User?
//        
//        do {
//            object = try DefaultCacheConverter<User>().decode(data)
//        } catch {}
//        
//        // Decode your object from data
//        
//        return object
//    }
//    
//    func encode() -> Data? {
//        var data: Data?
//        
//        do {
//            data = try DefaultCacheConverter<User>().encode(self)
//        } catch {}
//        // Encode your object to data
//        
//        return data
//    }

    // MARK: - Deserialization
    
    init?(json: Gloss.JSON) {
        self.token = "token" <~~ json
        self.lastName = "employee.user.last_name" <~~ json
        self.firstName = "employee.user.first_name" <~~ json
        self.email = "employee.user.email" <~~ json
        self.displayName = "employee.user.display_name" <~~ json
        self.badgeImage = "employee.badge.badge_authority.primary_company.logo_square_url" <~~ json

    }
}
