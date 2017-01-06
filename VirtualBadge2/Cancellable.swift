//
//  Cancellable.swift
//  VirtualBadge2
//
//  Created by Justin Savory on 12/9/16.
//  Copyright © 2016 Pathfinders. All rights reserved.
//

import Foundation

protocol Cancellable {
    func cancel()
}

extension URLSessionTask: Cancellable {
    
}
