//
//  ViewController.swift
//  VirtualBadge2
//
//  Created by Justin Savory on 12/8/16.
//  Copyright © 2016 Pathfinders. All rights reserved.
//

import UIKit
import Cache
import Gloss

class LoginViewController: UIViewController {
    typealias RequestCompletion = (Result<NetworkResponse>) -> Void
    
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
    
    @IBAction func printToken(_ sender: AnyObject) {
        cache.object("token") { (token: String?) in
            print(token)
        }
    }
    
    @IBAction func doLogin(_ sender: AnyObject) {
        doInitialLogin()
    }
    
    func doInitialLogin() {
        //TODO: Grab from form fields
        
        let jsonString = [
            "email" : "tcbadge1@pathfinders.cc",
            "password" : "test",
            "domain" : "tc2"
            ] as NSDictionary
        
        Requester(requestType: "Login").requestObject(LoginRequest( queryItems: [], parameters:jsonString)) {(result: Result<User>) in
            guard case let .success(AccountOwner) = result else {
                return
            }
            // Cache the token separately for easier programmatic invalidation
            if let token = AccountOwner.token {
                self.cache.add("token", object: token)
                self.viewInstantiator(identifier:BadgeController())
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
