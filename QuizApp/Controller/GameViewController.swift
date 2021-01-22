//
//  GameViewController.swift
//  QuizApp
//
//  Created by Andras Sziffer on 2021. 01. 20..
//  Copyright © 2021. Andras Sziffer. All rights reserved.
//

import UIKit
import Cheers

class GameViewController: UIViewController {

    @IBOutlet var answerButtons: [UIButton]!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    private var questionAndAnswers: (String?, [String]?)
    private var finished: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressView.progress = 0
        nextButton.layer.cornerRadius = 5
        
        let question = QuizManager.shared.startGame()
        
        questionLabel.text = question.0
        
        for (index, button) in answerButtons.enumerated() {
            button.tag = index
            button.addTarget(self, action: #selector(answerButtonPressed(_:)), for: .touchUpInside)
            button.setTitle(question.1[index], for: .normal)
        }
    }
    
    /**
     Handles nextButton press. If the game is finished, performs segue to the start Screen, if not, loads the next question.
     */
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        
        if finished {
            self.performSegue(withIdentifier: K.Segues.gameFinished, sender: nil)
            return
        }
        
        nextButton.isEnabled = false
        
        setAnswerButtons(enabled: true)
        progressView.progress = QuizManager.shared.progress
        questionLabel.text = questionAndAnswers.0
        
        setAnswers(questionAndAnswers.1!)
        
    }
    
    /**
     Sends the user's answer to the manager, updates the UI accordingly
     */
    @objc func answerButtonPressed(_ button: UIButton) {
        
        let answerResult = QuizManager.shared.checkAnswer(button.tag)
        
        if answerResult.0 {
            button.backgroundColor = .green
        } else {
            answerButtons[answerResult.1].backgroundColor = .green
            button.backgroundColor = .red
        }
        
        setAnswerButtons(enabled: false)
        
        questionAndAnswers = QuizManager.shared.nextQuestion()
        
        scoreLabel.text = "Score: \(QuizManager.shared.score)"
       
                
        guard questionAndAnswers.0 != nil else {
            finish()
            return
        }
        
        nextButton.isEnabled = true
    }
    
    /**
     Called when the Quiz is finished. Displays a confetti rain for 2 secs and sets the nextButton text to done.
     */
    private func finish() {
        
        let cheerView = CheerView()
        view.addSubview(cheerView)
        cheerView.config.particle = .confetti(allowedShapes: Particle.ConfettiShape.all)
        cheerView.start()
        nextButton.isEnabled = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            cheerView.stop()
        }
        
        finished = true
        
        progressView.progress = 1
        nextButton.setTitle("Done", for: .normal)
    }
    /**
     updates the answer buttons based on the new answers
     - Parameter answers: the new answers in a string array
     */
    private func setAnswers(_ answers: [String]) {
        for (index, button) in answerButtons.enumerated() {
            button.setTitle(answers[index], for: .normal)
            button.backgroundColor = .white
        }
    }
    /**
     Changes the answer buttons' enabled state
     */
    private func setAnswerButtons(enabled: Bool) {
        for button in answerButtons {
            button.isEnabled = enabled
        }
    }
    
}
