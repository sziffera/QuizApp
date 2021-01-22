//
//  QuestionHandlerViewController.swift
//  QuizApp
//
//  Created by Andras Sziffer on 2021. 01. 20..
//  Copyright © 2021. Andras Sziffer. All rights reserved.
//

import UIKit
import SwipeCellKit

class QuestionHandlerViewController: UIViewController, UITableViewDelegate {
    
    private var questions = Array<Question>()
    
    private let defaults = UserDefaults.standard

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        /// notiftication listener for new Question inserts
        NotificationCenter.default.addObserver(self, selector: #selector(questionsUpdated(_:)), name: .questionsUpdated, object: nil)
        questions = QuizManager.shared.getQuestions()
    }
    /**
     Handles Question inserts, reloads the tableView
     */
    @objc func questionsUpdated(_ sender: NSNotification) {
        questions = QuizManager.shared.getQuestions()
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if questions.count > 0 && !defaults.bool(forKey: K.swipeShowed) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                 let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! SwipeTableViewCell
                 cell.showSwipe(orientation: .right, animated: true, completion: nil)
                self.defaults.set(true, forKey: K.swipeShowed)
            }
        }
    }
    
}
// MARK:- UITableViewDataSource
extension QuestionHandlerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.myCell, for: indexPath) as! SwipeTableViewCell
        
        cell.textLabel?.text = questions[indexPath.row].question
        cell.contentView.backgroundColor = .clear
                
        cell.delegate = self
        
        return cell
    }
    
    
}
// MARK:- SwipeTableViewCellDelegate
extension QuestionHandlerViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            /// handle action by updating model with deletion
            let question = self.questions[indexPath.row]
            QuizManager.shared.deleteQuestion(question)
            self.questions.remove(at: indexPath.row)
            
            ///haptic feedback
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            self.tableView.reloadData()
        }

        // customize the action appearance
        deleteAction.image = UIImage(systemName: "trash")
        return [deleteAction]
    }
}
