//
//  BadgeView.swift
//  VirtualBadge2
//
//  Created by Justin Savory on 12/9/16.
//  Copyright © 2016 Pathfinders. All rights reserved.
//

import Cache
import Gloss
import UIKit

// Initial swipeable view
// Displays the users profile data from a warmed cache

class BadgeView: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    
    let cache = HybridCache(name: "customcache", config:  Config(
        // Your front cache type
        frontKind: .disk,
        // Your back cache type
        backKind: .disk,
        // Expiry date that will be applied by default for every added object
        // if it's not overridden in the add(key: object: expiry: completion:) method
        expiry: .date(Date().addingTimeInterval(100000)),
        // Maximum size of your cache storage
        maxSize: 10000))
    
    
    @IBOutlet weak var emailLabel: UILabel!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cache.object("user") { (json:  JSONType?) in
            /// MARK - Decode User
            
            guard let user = User(json: json?.object as! Gloss.JSON) else {
                return
                // TODO: Show an error message
                // handle decoding failure here
            }
            if let userBadge = user.badgeImage {
                
                let imageurl = URL(string: Environment.currentEnvironment.url + userBadge)
                
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: imageurl!)
                    DispatchQueue.main.async {
                        self.avatar?.image = UIImage(data: data!)
                    }
                }
            }
            
            self.emailLabel?.text = user.email
            self.nameLabel?.text = user.firstName
        }
    }
}
