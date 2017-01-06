//
//  FormViewController.swift
//  VirtualBadge2
//
//  Created by Justin Savory on 12/14/16.
//  Copyright © 2016 Pathfinders. All rights reserved.
//

import UIKit
import Cache
import Gloss

class MasterFormViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var items: [String] = []
    
    var valueToPass:String!
    var AllForms = [Form]()
    
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
    
    @IBOutlet var tableView: UITableView!
    
    func doInitialFormGrab(cachedToken: String) {
        // prepare json data
        let urlComponents = NSURLComponents(string: "https://dev.virtualbadge.com/form_templates.json")!
        
        urlComponents.queryItems = [
            URLQueryItem(name: "auth_token", value: cachedToken),
            URLQueryItem(name: "filter", value: "[{\"property\":\"status\",\"value\":\"approved\"}]")
        ]
        
        //create the session object
        let session = URLSession.shared
        
        //now create the NSMutableRequest object using the url object
        let request = NSMutableURLRequest(url: urlComponents.url!)
        request.httpMethod = "GET" //set http method as POST
        
        request.timeoutInterval = 120;
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSArray {
                    //  let theData = json[0]
                    for theData in json {
                        if let formProps = Form(json: theData as! Gloss.JSON) {
                         //   print("YOLO", formProps)
                            
                            self.AllForms.append(formProps)
                            // Override the items array with the fetched data
                            //          self.items.append(formProps.name! + " - " + formProps.displayName!)
                            
                            if let nameArray = formProps.name {
                                
                                if let name = nameArray as? String {
                                    // access individual value in dictionary
                                    self.items.append(name)
                                }
                                
                            }
                            
                            if let array = formProps.content as? [Any] {
                                
                                for firstObject in array {
                                    if let dictionary = firstObject as? [String: Any] {
                                        
                                        if let fieldType = dictionary["type"] as? String,
                                            let fieldLabel = dictionary["label"] as? String  {
                                            // access individual value in dictionary
                                            self.valueToPass = fieldType
                                            print("FORMTYPE",fieldType)
                                        }
                                        
                                        for (key, value) in dictionary {
                                            
                                            print(key, value)
                                            // access all key / value pairs in dictionary
                                        }
                                        //
                                        //                                    if let nestedDictionary = dictionary["anotherKey"] as? [String: Any] {
                                        //                                        // access nested dictionary values by key
                                        //                                    }
                                    }
                                }
                            }
                            
                        }
                    }
                }
                
            } catch let error {
                print("prob",error.localizedDescription)
            }
            
        })
        
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        cache.object("token") { (token: String?) in
            if token != nil && token != ""  {
                self.doInitialFormGrab(cachedToken: token!)
            }
            else {
                self.viewPresenter(identifier: "loginviewinitial")
                
                // TODO: Take back to login screen
            }
        }
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        cell.textLabel?.text = self.items[indexPath.row]
        
        return cell
    }
    
    
    let formSegueIdentifier = "formdetail"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == formSegueIdentifier,
            let destination = segue.destination as? FormConstructorController,
            let idx = tableView.indexPathForSelectedRow?.row
        {
            print("doing a segue and such")
            destination.formName = idx
            destination.passedValue = self.valueToPass
            destination.forms = AllForms
        }
    }
    
    // MARK: - Navigation
    
    func tableView(_ tableView: UITableView, didSelectRowAt
        indexPath: IndexPath){
        
        
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        
        //   valueToPass = currentCell.textLabel?.text
        
        
        self.performSegue(withIdentifier: "formdetail", sender: self);
        
        print(indexPath)
    }
}
