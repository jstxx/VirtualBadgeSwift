//
//  NetworkRequest.swift
//  VirtualBadge2
//
//  Created by Justin Savory on 12/9/16.
//  Copyright © 2016 Pathfinders. All rights reserved.
//
import Foundation

struct FormRequest: NetworkRequest {
    /// The request's parameters, the empty array by default. Added to the `URL` in the default `URLRequest`.
    internal var parameters: NSDictionary
    
    /// The request's parameters, the empty array by default. Added to the `URL` in the default `URLRequest`.
    let method: HTTPMethod = .GET
    //MARK: - NetworkRequest
    
    internal var queryItems: [URLQueryItem]
    
    let path = "/form_templates.json"
}


struct LoginRequest: NetworkRequest {
    /// The configured query item
    internal var queryItems: [URLQueryItem]

    /// The request's parameters, the empty array by default. Added to the `URL` in the default `URLRequest`.
    internal var parameters: NSDictionary

    /// The request's parameters, the empty array by default. Added to the `URL` in the default `URLRequest`.
    let method: HTTPMethod = .POST
    //MARK: - NetworkRequest
    
    let path = "/vb/sign_in.json"
    
}

/// An HTTP verb.
enum HTTPMethod: String {
    case OPTIONS, GET, HEAD, POST, PUT, PATCH, DELETE, TRACE, CONNECT
}

/**
 *  A model protocol describing an HTTP network request.
 */
protocol NetworkRequest {
    
    /// The request's base URL.
    var baseURL: URL? { get }
    
    /// The request's parameters, the empty array by default. Added to the `URL` in the default `URLRequest`.
    var parameters: NSDictionary { get set }
    
    /// Supplies an HTTP Method for the default `URLRequest` implementation. `.GET` by default.
    var method: HTTPMethod { get }
    
    /// Supplies a path for the default `URLRequest` implementation. The empty string by default.
    var path: String { get }
    
    /// The configured URL request.
    var URLRequest: URLRequest? { get }
    
    /// The configured query item
    var queryItems: [URLQueryItem] { get set }

}

extension NetworkRequest {
    var parameters: NSDictionary {
        return [:]
    }
    
    var method: HTTPMethod {
        return .GET
    }
    
    var queryItems: [URLQueryItem] {
        return  [URLQueryItem(name: "", value: "")]
    }
    
    var path: String {
        return ""
    }
    
    var URLRequest: URLRequest? {
        guard let URL = baseURL else { return nil }
        
        guard var URLComponents = URLComponents(url: URL, resolvingAgainstBaseURL: false) else { return nil }
        
       
        URLComponents.queryItems = queryItems
        URLComponents.path = URLComponents.path + path 
        
        guard let cookedURL = URLComponents.url else { return nil }
        let request = NSMutableURLRequest(url: cookedURL)
        request.httpMethod = method.rawValue
        let requestDictionary = parameters
        request.timeoutInterval = 150
       
        request.httpBody = try! JSONSerialization.data(withJSONObject: requestDictionary, options: [])

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        return request as URLRequest
    }
}

/// An extension on `NetworkRequest` to provide default values.
extension NetworkRequest {
    
    /**
     Provides the base URL of a request.
     
     - returns: The currently-appropriate base URL
     */
    var baseURL: URL? {
        switch environment {
        case .production: return URL(string: "https://www.virtualbadge.com")
        case .staging: return URL(string: "https://dev.virtualbadge.com")
        }
    }
    
    var environment: Environment {
        return Environment.currentEnvironment
    }
}
