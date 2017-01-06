//
//  URL+Data.swift
//  VirtualBadge2
//
//  Created by Justin Savory on 12/9/16.
//  Copyright © 2016 Pathfinders. All rights reserved.
//
import Foundation
/// An extension on `URL` to support Data URIs.
extension URL {
    
    /// `true` if the receiver is a Data URI. See https://en.wikipedia.org/wiki/Data_URI_scheme.
    var dataURI: Bool {
        return scheme == "data"
    }
    
    /// Extracts the base 64 data string from the receiver if it is a Data URI. Otherwise or if there is no data, returns `nil`.
    var base64EncodedDataString: String? {
        guard dataURI else { return nil }
        
        let components = absoluteString.components(separatedBy: ";base64,")
        return components.last
    }
    
    /// Extracts the data from the receiver if it is a Data URI. Otherwise or if there is no data, returns `nil`.
    var base64DecodedData: Data? {
        guard let string = base64EncodedDataString else { return nil }
        
        // Ignore whitespace because "Data URIs encoded in Base64 may contain whitespace for human readability."
        
        return Data(base64Encoded: string, options: .ignoreUnknownCharacters)
    }
}
