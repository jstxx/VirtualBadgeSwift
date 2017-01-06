//
//  ViewSwitcher.swift
//  VirtualBadge2
//
//  Created by Justin Savory on 12/9/16.
//  Copyright © 2016 Pathfinders. All rights reserved.
//

import UIKit
import EZSwipeController

extension UIViewController {
    func viewInstantiator(identifier:UIViewController){
//        let storyBoard = UIStoryboard(name: identifier, bundle: nil)
//        let badgeViewController = storyBoard.instantiateViewController(withIdentifier: identifier)
        
        self.navigationController?.pushViewController(identifier, animated: true)

      //  self.present(badgeViewController, animated: true, completion: nil)
    }
    func viewPresenter(identifier:String) {
        performSegue(withIdentifier: identifier, sender: self)
    }
}
