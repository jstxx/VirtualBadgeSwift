//
//  NetworkClient.swift
//  VirtualBadge2
//
//  Created by Justin Savory on 12/9/16.
//  Copyright © 2016 Pathfinders. All rights reserved.
//

import Foundation
/// A network client that is used by the application to reach network resouces.
final class NetworkClient {
    
    typealias RequestCompletion = (Result<NetworkResponse>) -> Void
    
    fileprivate let URLSession: URLSession
    
    /**
     Initializes a `NetworkClient` with a `NSURLSession` which is uses to perform network operations.
     
     - parameter URLSession: The underlying session to use.
     
     - returns: A fully configured `NetworkClient`
     */
    init(URLSession: URLSession = NetworkClient.defaultSession()) {
        self.URLSession = URLSession
    }
    
    fileprivate static func defaultSession() -> URLSession {
        let session = Foundation.URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue.main)
        return session
    }
    
    /**
     Asynchronously requests some data from the network and calls a completion closure upon success or failure.
     
     - parameter request:           The request to send.
     - parameter completionHandler: The completion handler that’s executed when the request completes. Executed on the `URLSession`’s `delegateQueue`.
     */
    func requestData(_ request: NetworkRequest, completionHandler: @escaping RequestCompletion) -> Cancellable? {
        guard let task = task(request, completionHandler: completionHandler) else {
            completionHandler(Result.failure(nil, badRequestError(request)))
            return nil
        }
        
        task.resume()
        
        return task
    }
    
    fileprivate func task(_ request: NetworkRequest, completionHandler: @escaping RequestCompletion) -> URLSessionTask? {
        guard let URLRequest = request.URLRequest else { return nil }
        return URLSession.dataTask(with: URLRequest, completionHandler: taskCompletionHandler(completionHandler))
    }
    
    fileprivate func taskCompletionHandler(_ completionHandler: @escaping RequestCompletion) -> (Data?, URLResponse?, Error?) -> Void {
        return { data, response, error in
            var result: Result<NetworkResponse>
            
            if let error = error {
                result = Result.failure(data, error)
            } else {
                result = Result.success(DataResponse(data: data, response: response))
            }
            
            completionHandler(result)
            self.URLSession.finishTasksAndInvalidate()
        }
    }
    
    fileprivate func badRequestError(_ request: NetworkRequest) -> Error {
        let userInfo = [
            NSLocalizedDescriptionKey: "An NSURLRequest could not be generated from the NetworkRequest \(request).",
        ]
        return NSError(code: ErrorCode.requestConstructionError, userInfo: userInfo)
    }
}
