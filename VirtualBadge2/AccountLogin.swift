//
//  AccountLogin.swift
//  VirtualBadge2
//
//  Created by Justin Savory on 12/8/16.
//  Copyright © 2016 Pathfinders. All rights reserved.
//

import Gloss

struct AccountOwner: Decodable {
    
    let token: String?
    
    // MARK: - Deserialization
    
    init?(json: JSON) {
        guard let token: String = "token" <~~ json else {
            return nil
        }
        
        self.token = token
    }
}
