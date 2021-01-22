//
//  ViewController.swift
//  QuizApp
//
//  Created by Andras Sziffer on 2021. 01. 19..
//  Copyright © 2021. Andras Sziffer. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    @IBOutlet weak var startQuizButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    
     private lazy var realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startQuizButton.layer.cornerRadius = 5
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "Please add your name",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
       
    }
    /**
     Checks whether the Questions are empty or not and the user typed their name or not
     */
    @IBAction func startQuizButtonPressed(_ sender: Any) {
        let generator = UINotificationFeedbackGenerator()
        if usernameTextField.text?.isEmpty ?? true {
            displayMyAlertMessage(title: "Can't start Quiz", userMessage: "Please add your name!", vc: self)
            generator.notificationOccurred(.warning)
            return
            
        }
        
        if realm.objects(Question.self).count < 1 {
            displayMyAlertMessage(title: "No Questions added", userMessage: "Please add a few questions!", vc: self)
            generator.notificationOccurred(.error)
            return
        }
        
        self.performSegue(withIdentifier: K.Segues.game, sender: nil)
    }
    
}

