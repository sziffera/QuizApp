//
//  AddQuizViewController.swift
//  QuizApp
//
//  Created by Andras Sziffer on 2021. 01. 21..
//  Copyright © 2021. Andras Sziffer. All rights reserved.
//

import UIKit
import M13Checkbox
import RealmSwift

class AddQuizViewController: UIViewController {
    
    
    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet var questionTextFields: [UITextField]!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet var checkBoxViews: [UIView]!
    
    private var checkedCheckBoxTag = -1
    
    private var checkBoxes: [M13Checkbox] = [M13Checkbox]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.layer.cornerRadius = 5
        
        questionTextField.attributedPlaceholder = NSAttributedString(string: "Add the question",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        
        /// setting the checkBoxes
        for (index, textView) in questionTextFields.enumerated() {
            
            textView.attributedPlaceholder = NSAttributedString(string: "Answer \(index)",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
            
            let checkbox = M13Checkbox(frame: CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50.0))
            checkBoxViews[index].addSubview(checkbox)
            checkbox.tag = index
            checkbox.addTarget(self, action: #selector(self.checkboxValueChanged(_:)), for: .valueChanged)
            checkBoxes.append(checkbox)
            
        }
    }
    
   
    /**
     Checks whether all of the required fields are filled and saves the new Question into Realm DB
     */
    @IBAction func addButtonPressed(_ sender: Any) {
        
        let alertTitle = "Can't save Question"
        
        if questionTextField.text?.isEmpty ?? true {
            displayMyAlertMessage(title: alertTitle, userMessage: "Please add the question", vc: self)
            return
        }
        
        if checkedCheckBoxTag == -1 {
            displayMyAlertMessage(title: alertTitle, userMessage: "Please select the correct answer", vc: self)
            return
        }
        
        
        let answers = List<Answer>()
        
        for textField in questionTextFields {
            if textField.text?.isEmpty ?? true {
                displayMyAlertMessage(title: alertTitle, userMessage: "Please fill all the answers", vc: self)
                return
            } else {
                answers.append(Answer(text: textField.text!, correct: false))
            }
        }
        
        /// setting the correct answer based on the selected checkbox tag
        answers[checkedCheckBoxTag].setCorrect()
        
        
        
        let question = Question(question: questionTextField.text!, answers: answers)
        
        QuizManager.shared.addQuestion(question)
        
        NotificationCenter.default.post(name: .questionsUpdated, object: nil)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    /**
     Listens to checkBox value updates. Unchecks the previously selected checkBox if the user selects a new one.
     */
    @objc func checkboxValueChanged(_ sender: M13Checkbox) {
        
        if checkedCheckBoxTag == -1 {
            checkedCheckBoxTag = sender.tag
        } else {
            if sender.checkState == .checked {
                checkBoxes[checkedCheckBoxTag].setCheckState(.unchecked, animated: true)
                checkedCheckBoxTag = sender.tag
            } else {
                checkedCheckBoxTag = -1
            }
        }
    }
}

