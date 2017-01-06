//
//  Result.swift
//  VirtualBadge2
//
//  Created by Justin Savory on 12/9/16.
//  Copyright © 2016 Pathfinders. All rights reserved.
//

import Foundation
/**
 Used to represent whether a request was successful or encountered an error.
 
 - Success: The request and all post processing operations were successful resulting in the serialization of the
 provided associated value.
 - Failure: The request encountered an error resulting in a failure. The associated values are the original data
 provided by the server as well as the error that caused the failure.
 */
enum Result<Value> {
    case success(Value)
    case formSuccess(NSArray?)
    case failure(Data?, Error)
    
    /// Returns `true` if the result is a success, `false` otherwise.
    var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .formSuccess:
            return true
        case .failure:
            return false
        }
    }
    
    /// Returns `true` if the result is a failure, `false` otherwise.
    var isFailure: Bool {
        return !isSuccess
    }
    
    /// Returns the associated value if the result is a success, `nil` otherwise.
    var value: Value? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        default:
            return nil
        }
        
    }
    
    
    /// Returns the associated data value if the result is a failure, `nil` otherwise.
    var data: Data? {
        switch self {
        case .success:
            return nil
        case .failure(let data, _):
            return data
        default:
            return nil
        }
  
    }
    
    /// Returns the associated error value if the result is a failure, `nil` otherwise.
    var error: Error? {
        switch self {
        case .success:
            return nil
        case .failure(_, let error):
            return error
        default:
            return nil
        }
    }
}

// MARK: - CustomStringConvertible

extension Result: CustomStringConvertible {
    var description: String {
        switch self {
        case .success, .formSuccess:
            return "SUCCESS"
        case .failure:
            return "FAILURE"
        }
    }
}

// MARK: - CustomDebugStringConvertible

extension Result: CustomDebugStringConvertible {
    var debugDescription: String {
        switch self {
        case .formSuccess(let value):
            return "SUCCESS: \(value)"
        case .success(let value):
            return "SUCCESS: \(value)"
        case .failure(let data, let error):
            if let
                data = data,
                let utf8Data = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                return "FAILURE: \(error) \(utf8Data)"
            } else {
                return "FAILURE with Error: \(error)"
            }
        }
    }
}
