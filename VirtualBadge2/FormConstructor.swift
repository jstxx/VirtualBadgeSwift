//
//  FormConstructorController.swift
//  VirtualBadge2
//
//  Created by Justin Savory on 12/16/16.
//  Copyright © 2016 Pathfinders. All rights reserved.
//

import UIKit
import EZSwipeController
import Eureka
import Cache

class FormConstructorController: FormViewController {
    
    @IBAction func submitForm(_ sender: AnyObject) {
        submitForm()
    }
    var forms = [Form]()
    var formName = Int()
    var passedValue = String()
    
    /*
     @param - form: The Master Eurka Form
     @param - forms: Dictionary of form properties from Form model
     */

    /// MARK - Form Mapper
    func formMapper(form: Eureka.Form, forms: Dictionary<String, AnyObject>) {
        guard let formtype = forms["type"] as! String? else {
            return
        }
        
        let mappings: NSDictionary = [
            "textfield":TextRow(){
                //TODO: Dynamic Validation Settings
                var rules = RuleSet<String>()
                rules.add(rule: RuleRequired())
                rules.add(rule: RuleEmail())
                
                $0.title = forms["label"] as! String?
                $0.add(ruleSet: rules)
                $0.tag = forms["id"] as! String?
                $0.validationOptions = .validatesOnChangeAfterBlurred
            },
            "photo": ImageRow(){
                $0.title = forms["label"] as! String?
                $0.tag = forms["id"] as! String?
            },
            "boolean":  SwitchRow() {
                $0.title = forms["label"] as! String?
                $0.value = false
                $0.tag = forms["id"] as! String?
            },
            "singleselect":   PickerInlineRow<String>(forms["label"] as? String){ (row : PickerInlineRow<String>) -> Void in
                guard let options = forms["options"] as! Array<AnyObject>? else {
                    return
                }
                row.title = forms["label"] as? String
                row.options = options as! [String]
                row.value = row.options[0]
                row.tag = forms["id"] as! String?
            }
        ]
        
        func constructBaseRow() {
            let thisSection = Section(forms["label"] as! String)
            let row = mappings["\(formtype)"]
            thisSection.append(row as! BaseRow)
            form.append(thisSection)
        }
        
        switch(formtype) {
        case "boolean", "textfield", "singleselect", "photo":
            constructBaseRow()
        default:
            return
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func submitForm() {
        let valuesDictionary = form.values()
        let alertController = AlertType.submitForm.alert
        alertController.addAction(UIAlertAction(title: ButtonTitle.OK, style: .default, handler: .none))
        alertController.addAction(UIAlertAction(title: ButtonTitle.Cancel, style: .default, handler: .none))
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ImageRow.defaultCellUpdate = { cell, row in
            cell.accessoryView?.layer.cornerRadius = 17
            cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        }
        
        let formsection = form as Eureka.Form
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        var formObject = Dictionary<String, AnyObject>()
        
        /// MARK Main Loop
        
        for (index, form) in forms.enumerated() where index == formName {
            // Set the title of the form
            if let formtitle = form.name {
                if let name = formtitle as? String {
                    self.title = name
                }
            }
            
            if let array = form.content as? [Any] {
                for firstObject in array {
                    if let dictionary = firstObject as? [String: Any] {
                        if let fieldType = dictionary["type"],
                            let fieldLabel = dictionary["label"],
                            let fieldID = dictionary["id"]{
                            formObject["label"] = fieldLabel as AnyObject?
                            formObject["type"] = fieldType as AnyObject?
                            formObject["id"] = fieldID as AnyObject?

                            if let richOptions = dictionary["rich_options"] {
                                formObject["richOptions"] = richOptions as AnyObject?
                            }
                            
                            if let options = dictionary["options"] {
                                formObject["options"] = options as AnyObject?
                            }
                            
                            formMapper(form: formsection, forms: formObject)
                        }
                    }
                }
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
