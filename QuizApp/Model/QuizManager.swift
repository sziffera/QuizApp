//
//  QuizManager.swift
//  QuizApp
//
//  Created by Andras Sziffer on 2021. 01. 20..
//  Copyright © 2021. Andras Sziffer. All rights reserved.
//

import Foundation
import RealmSwift

class QuizManager {
    
    static let shared = QuizManager()
    
    private lazy var realm = try! Realm()
    
    private var counter: Int = 0
    private(set) var questionsNumber: Int = 0
    
    private var questions = [Question]()
    
    private(set) var currentQuestion: Question?
    private(set) var score = 0
    
    var progress: Float {
        get {
           
            return Float(counter) / Float(questionsNumber)
        }
    }
    
    private init() {
        
        questions = Array(realm.objects(Question.self)).shuffled()
        questionsNumber = questions.count
    }
    /**
     Called when the game is starting. Sets back the variables to the initial state and shuffles the questions
     - Returns: A pair with the question and the answers in a string array.
     */
    func startGame() -> (String, [String]) {
        questions = Array(realm.objects(Question.self)).shuffled()
        questionsNumber = questions.count
        counter = 0
        score = 0
        var answers = [String]()
        for answer in questions[counter].answers {
            answers.append(answer.text)
        }
        return (questions[0].question, answers)
    }
    
    /**
     Checks the user's answer
     - Parameter index: the index of the answer based on the buttons
     - Returns: With a new pair containing the answer (correct or not) and the correct answer's index.
     */
    func checkAnswer(_ index: Int) -> (Bool, Int) {
        
        if questions[counter].answers[index].isCorrect() {
            score += 1
            return (true, 0)
        } else {
            for (index, answer) in questions[counter].answers.enumerated() {
                if answer.isCorrect() {
                    return (false, index)
                }
            }
        }
        return (false, 0)
    }
    
    /**
     Sets the new Question
     - Returns: A new pair with the question and the answers array, null if no more question remained
     */
    func nextQuestion() -> (String?, [String]?) {
        if counter < questionsNumber - 1 {
            counter += 1
            var answers = [String]()
            for answer in questions[counter].answers {
                answers.append(answer.text)
            }
            return (questions[counter].question, answers)
        } else {
            return (nil, nil)
        }
    }
    /**
     - Returns: a new array from Questions in Realm DB
     */
    func getQuestions() -> [Question] {
        return Array(realm.objects(Question.self))
    }
    
    /**
     Saves a new Question into Realm
     - Parameter question: the question to be saved
     */
    func addQuestion(_ question: Question) {
        do {
            try realm.write{
                realm.add(question)
                questionsNumber += 1
            }
        } catch {
            print(error)
        }
    }
    /**
    Deletes a Question from the Realm DB
    - Parameter question: the question to be deleted
    */
    func deleteQuestion(_ question: Question) {
        do {
            try realm.write{
                realm.delete(question)
                questionsNumber -= 1
            }
        } catch {
            print(error)
        }
    }
}
