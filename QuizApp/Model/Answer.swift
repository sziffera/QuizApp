//
//  Answer.swift
//  QuizApp
//
//  Created by Andras Sziffer on 2021. 01. 20..
//  Copyright © 2021. Andras Sziffer. All rights reserved.
//

import Foundation
import RealmSwift

/**
 Answer class for storing the answers in the Realm DB
 */

class Answer: Object {
    
    @objc dynamic private(set) var text: String = ""
    @objc dynamic private(set) var correct: Bool = false
    
    private var parentQuestion = LinkingObjects(fromType: Question.self, property: "answers")
    
    override init() {
        //skip
    }
    
    init(text: String, correct: Bool) {
        self.text = text
        self.correct = correct
    }
    
    func isCorrect() -> Bool {
        return correct
    }
    
    func setCorrect() {
        correct = true
    }
    
}
