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

    let token: String?
    let displayName: String?
    let email: String?
    let firstName: String?
    let lastName: String?
    let badgeImage: String?
    
    init?(json: Gloss.JSON) {
        self.token = "token" <~~ json
        self.lastName = "employee.user.last_name" <~~ json
        self.firstName = "employee.user.first_name" <~~ json
        self.email = "employee.user.email" <~~ json
        self.displayName = "employee.user.display_name" <~~ json
        self.badgeImage = "employee.badge.badge_authority.primary_company.logo_square_url" <~~ json

    }
}
