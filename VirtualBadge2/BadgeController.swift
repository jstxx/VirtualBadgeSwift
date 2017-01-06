//
//  BadgeController.swift
//  VirtualBadge2
//
//  Created by Justin Savory on 12/8/16.
//  Copyright © 2016 Pathfinders. All rights reserved.
//

import UIKit
import Gloss
import EZSwipeController
import Cache

// Sets up child views for a swipeable interface
class BadgeController: EZSwipeController {
    
    
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
    
    override func setupView() {
        datasource = self
        navigationBarShouldNotExist = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    
        for someview in self.pageViewController.view.subviews {
            if someview is UIScrollView {
                let scrollview = someview as! UIScrollView
                scrollview.delegate = self
            }
        }
    }
    
   
    
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded view")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension BadgeController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.currentVCIndex == 0 && (scrollView.contentOffset.x < scrollView.bounds.size.width) {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0)
        } else if self.currentVCIndex == self.stackVC.count - 1 && (scrollView.contentOffset.x > scrollView.bounds.size.width) {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0)
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if self.currentVCIndex == 0 && (scrollView.contentOffset.x < scrollView.bounds.size.width) {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0)
        } else if self.currentVCIndex == self.stackVC.count - 1 && (scrollView.contentOffset.x > scrollView.bounds.size.width) {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0)
        }
    }
}

extension BadgeView: StoryboardInstantiable {
    static var storyboardName: String { return "badgeview" }
    static var storyboardIdentifier: String? { return "thebadge" }
}

extension MasterFormViewController: StoryboardInstantiable {
    static var storyboardName: String { return "formtable" }
    static var storyboardIdentifier: String? { return "formtable" }
}


extension BadgeController: EZSwipeControllerDataSource {
    func viewControllerData() -> [UIViewController] {
        
        let redVC = BadgeView.instantiate()
       // redVC.view.backgroundColor = UIColor.red
        
        let blueVC = MasterFormViewController.instantiate()
    //    blueVC.view.backgroundColor = UIColor.blue
        
        let greenVC = UIViewController()
     //   greenVC.view.backgroundColor = UIColor.green
        
        return [redVC, blueVC, greenVC]
    }
}
