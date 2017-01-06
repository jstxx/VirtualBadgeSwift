//
//  NetworkResponse.swift
//  VirtualBadge2
//
//  Created by Justin Savory on 12/9/16.
//  Copyright © 2016 Pathfinders. All rights reserved.
//

import Foundation
/**
 *  A protocol describing a response from the network.
 */
protocol NetworkResponse {
    var data: Data? { get }
    var response: URLResponse? { get }
}

/**
 *  A concrete implementation of `NetworkResponse`.
 */
struct DataResponse: NetworkResponse {
    var data: Data?
    var response: URLResponse?
}
