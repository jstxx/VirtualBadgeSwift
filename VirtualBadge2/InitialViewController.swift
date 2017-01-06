//
//  InitialViewController.swift
//  VirtualBadge2
//
//  Created by Justin Savory on 12/8/16.
//  Copyright © 2016 Pathfinders. All rights reserved.
//

import UIKit
import Cache

class InitialViewController: UIViewController {
    
    let cache = HybridCache(name: "customcache", config:  Config(
        // Your front cache type
        frontKind: .memory,
        // Your back cache type
        backKind: .disk,
        // Expiry date that will be applied by default for every added object
        // if it's not overridden in the add(key: object: expiry: completion:) method
        expiry: .date(Date().addingTimeInterval(100000)),
        // Maximum size of your cache storage
        maxSize: 10000))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cache.object("token") { (token: String?) in
            if token != nil {
                print("have token")
                DispatchQueue.main.async {
                     self.viewInstantiator(identifier:BadgeController())
                }
                return
            }
            self.viewPresenter(identifier: "loginviewinitial")
            return
        }
    }
}
