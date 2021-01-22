//
//  Utils.swift
//  QuizApp
//
//  Created by Andras Sziffer on 2021. 01. 20..
//  Copyright © 2021. Andras Sziffer. All rights reserved.
//

import Foundation
import UIKit
/**
 Displays an alert message to the user
 - Parameters:
    - title: The title of the alert message.
    - userMessage: the message to be shown to the user.
    - vc: the holder ViewController
 */
func displayMyAlertMessage(title: String, userMessage: String, vc: UIViewController){
    
    let myAlert = UIAlertController(title: title, message: userMessage, preferredStyle: UIAlertController.Style.alert)
    let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
    myAlert.addAction(okAction)
    vc.present(myAlert, animated: true, completion: nil)
}

// MARK:-Notification
extension Notification.Name {
    static let questionsUpdated = Notification.Name("questionsDidChange")
}
