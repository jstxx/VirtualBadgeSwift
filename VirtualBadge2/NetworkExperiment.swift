//
//  NetworkExperiment.swift
//  VirtualBadge2
//
//  Created by Justin Savory on 12/16/16.
//  Copyright © 2016 Pathfinders. All rights reserved.
//
/*
import Foundation


func performFormRequest(cachedToken: String) {
    let jsonString = [:]
        as NSDictionary
    
    let queryItems = [
        URLQueryItem(name: "auth_token", value: cachedToken),
        URLQueryItem(name: "filter", value: "[{\"property\":\"status\",\"value\":\"approved\"}]")
    ]
    
    Requester(requestType: "Form").requestObject(FormRequest(parameters:jsonString, queryItems:queryItems)) {
        
        (result: Result<FormContainer>) in
        
        print("form result", result)
        
        guard case let .success(Form) = result else {
            print("unexpected type")
            return
        }
        
        
        
        self.cache.object("form") { (json:  JSONType?) in
            /// MARK - Decode User
            
            
            guard let user = FormContainer(json: json?.object as! Gloss.JSON) else {
                return
                // TODO: Show an error message
                // handle decoding failure here
            }
            let formData = user.toJSON()
            
            print("the cached forms",formData)
            
            
            //            guard let form = FormContainer(json: json?.object as! Gloss.JSON) else {
            //                return
            //                // TODO: Show an error message
            //                // handle decoding failure here
            //            }
            //  let form = FormContainer(jsonArray: json?.object)
            
            
            //            let myJSON: [String]? = form?.toJSON()?["form"] as? [String]
            //
            //            print("ze form", myJSON)
            //
            //            if let forms = form?.urls {
            //                print("all the forms")
            //                print(forms)
            //            }
            
        }
        
        print("raw form",Form)
        
        if let theform = Form.forms {
            print("WASSUP", theform)
        }
        
        
        //            if let token = Form.urls {
        //               print("found those urls..")
        //                let test = FormContainer(jsonArray: token as [AnyObject])
        //
        //                print(test?.urls)
        //
        //                // use the custom key to retrieve array
        //                let myJSON: [String]? = test?.toJSON()?["form"] as? [String]
        //
        //                print(myJSON)
        //
        //            }
        
        
        
        
        //  print("doing form request", result)
        // Cache the token separately for easier programmatic invalidation
        //            if let forms = Form.forms {
        //
        //
        //           //     self.cache.add("token", object: token)
        //                print("************************",forms,"************************")
        //
        //            }
    }
}




func submitNetworkRequestFromModule(module: String, method: String, parameters: NSDictionary, completion: @escaping (AnyObject?, NSError?) -> ()) -> URLSessionTask? {
    
    print("inside network call")
    
    let session = URLSession.shared
    let url = NSURL(string: "https://dev.virtualbadge.com/")!.appendingPathComponent(module)
    let request = NSMutableURLRequest(url: url!)
    request.httpMethod = method
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let requestDictionary = parameters
    
    request.httpBody = try! JSONSerialization.data(withJSONObject: requestDictionary, options: [])
    
    let task = session.dataTask(with: request as URLRequest) { data, response, error in
        
        // handle fundamental network errors (e.g. no connectivity)
        
        guard error == nil && data != nil else {
            completion(data as AnyObject?, error as NSError?)
            return
        }
        
        // check that http status code was 200
        
        if let httpResponse = response as? HTTPURLResponse , httpResponse.statusCode != 200 {
            completion(String(data: data!, encoding: String.Encoding.utf8) as AnyObject?, nil)
        }
        
        // parse the JSON response using native serialization
        
        //TODO: Could make a gloss factory
        do {
            let responseObject = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
            completion(responseObject, nil)
        } catch let error as NSError {
            completion(String(data: data!, encoding: String.Encoding.utf8) as AnyObject?, error)
        }
    }
    task.resume()
    
    return task
}
   */ 
