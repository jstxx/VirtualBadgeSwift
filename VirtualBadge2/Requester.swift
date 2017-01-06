//
//  Requester.swift
//  VirtualBadge2
//
//  Created by Justin Savory on 12/9/16.
//  Copyright © 2016 Pathfinders. All rights reserved.
//

import Gloss
import Cache

final class Requester {
    
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
    
    fileprivate let networkClient: NetworkClient
    fileprivate let requestType: String
    
    init(networkClient: NetworkClient = NetworkClient(), requestType: String) {
        self.networkClient = networkClient
        self.requestType = requestType
    }
    
    @discardableResult
    func requestObject<T: Decodable>(_ request: NetworkRequest, completionHandler: @escaping (Result<T>) -> Void) -> Cancellable? {
        return networkClient.requestData(request) { result in
            var downloadResult: Result<T>
          //  print("download",result)
            
            switch result {
            case let .success(response):
                guard let data = response.data else {
                    downloadResult = .failure(nil, Requester.noDataError)
                    break
                }
             //   print("which requestType?", self.requestType)
                
             //   print("********",data)
                // Cache the raw data so we can parse it from the user model on demand
                
                    self.cache.add("user", object: data)
                    print("login********",data)
                    
                    guard let JSONObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
                        let json = JSONObject as? Gloss.JSON,
                        let object = T(json: json) else {
                            downloadResult = .failure(nil, Requester.unparseableError)
                            break
                    }
                    downloadResult = .success(object)
                    completionHandler(downloadResult)

                
                    do {
                        //create json object from data
                        if let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSArray {
                            print("theGoods",json)
                            
                            downloadResult = .formSuccess(json)
                            
                            let theData = json[0]
                          
                        //    downloadResult = .success(json)

                            completionHandler(downloadResult)

                            
                            // handle json...
                        }
                        
                    } catch let error {
                        print("prob",error.localizedDescription)
                    }
                    
                    

               
                
//           
//            case .formSuccess: {
//                downloadResult = .formSuccess(nil)
//            }

            case let .failure(data, error):
                print(error, data)
                downloadResult = .failure(data, error)
            default: return
            }
          
            
        }
    }
}

// MARK: - Errors
// Could be made a protocol like "Error Provider" or something.
extension Requester {
    
    static var unparseableError: NSError {
        let userInfo = [
            NSLocalizedDescriptionKey: "The JSON for this request was not parsable."
        ]
        return NSError(code: ErrorCode.parsingError, userInfo: userInfo)
    }
    
    static var noDataError: NSError {
        let userInfo = [
            NSLocalizedDescriptionKey: "The data for this request was nil."
        ]
        return NSError(code: ErrorCode.noDataError, userInfo: userInfo)
    }
    
}

