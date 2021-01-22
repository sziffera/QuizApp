//
//  Question.swift
//  QuizApp
//
//  Created by Andras Sziffer on 2021. 01. 20..
//  Copyright © 2021. Andras Sziffer. All rights reserved.
//

import Foundation
import RealmSwift

class Question: Object {
    
    @objc dynamic private(set) var question: String = ""
    
    private(set) var answers = List<Answer>()
    
    override init() {
        //skip
    }
    
    init(question: String, answers: List<Answer>) {
        self.question = question
        self.answers = answers
    }
    
}


