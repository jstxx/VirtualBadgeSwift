//
//  AlertType.swift
//  VirtualBadge2
//
//  Created by Justin Savory on 12/8/16.
//  Copyright © 2016 Pathfinders. All rights reserved.
//

import UIKit

struct ButtonTitle {
    static let Subscribe = "Subscribe"
    static let Cancel = "Cancel"
    static let OK = "OK"
    static let Back = "Back"
    static let Continue = "Continue"
    static let CreateAccount = "Create Account"
}

enum AlertType {
    case invalidLogin
    case blankLogin
    case serverProblem
    case submitForm
    
    var title: String {
        switch self {
        case .invalidLogin: return "Sorry"
        case .blankLogin: return "Sorry"
        case .submitForm: return "Attention"
        case .serverProblem: return "Check your internet connection"
        }
    }
    
    var message: String {
        switch self {
        case .invalidLogin: return "We did not recognize that login combination.  Please try again."
        case .submitForm: return "Would you like to submit the form?"
        case .blankLogin: return "Please enter the required fields."
        case .serverProblem: return "There was a problem, please try again"
        }
    }
    
    var alertTitle: String {
        switch self {
        case .invalidLogin, .blankLogin, .serverProblem: return  ButtonTitle.Cancel
        default: return ButtonTitle.OK
        }
    }
    
    var alert: UIAlertController {
        return UIAlertController(title: title, message: message, preferredStyle: .alert)
    }
}
