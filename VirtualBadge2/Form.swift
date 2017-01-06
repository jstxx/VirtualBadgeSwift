//
//  Form.swift
//  VirtualBadge2
//
//  Created by Justin Savory on 12/14/16.
//  Copyright © 2016 Pathfinders. All rights reserved.
//

import Gloss

struct FormContainer: Glossy {
    let formss: [Form]?
    
    let forms: [AnyObject]?
    
    // introduce JSON array initializer that creates JSON with a custom key
    init?(jsonArray: [AnyObject]) {
        let jsonDictionary = ["forms" : jsonArray]
        self.init(json: jsonDictionary)
    }

    
    init?(json: JSON) {
        
        guard let forms: [AnyObject] = "forms" <~~ json else {
            return nil
        }
        
        self.forms = forms
        
        if let itemsArray: [JSON] = "forms" <~~ json {
            formss = [Form].from(jsonArray: itemsArray)
        } else {
            formss = nil
        }
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "forms" ~~> self.forms
            ])
    }
    
}

struct Form: Decodable {
    
    var id: Int?
    var name: String?
    var displayName: String?
    var content:  NSArray?
    var formtype: String?
    var contentType: AnyObject?

    init(id: Int?, name: String?, displayName: String?, content: NSArray?, contentType: AnyObject?) {
        self.id = id
        self.name = name
        self.content = content
        self.displayName = displayName
        self.contentType = contentType
        
    }
    
    init?(json: JSON) {
      //  print("Whats the data",json)
        
        self.init(
            id: "id" <~~ json,
            name: "name" <~~ json,
            displayName: "user.display_name" <~~ json,
            content: "content" <~~ json,
            contentType: "content.type" <~~ json
        )
    }
}
