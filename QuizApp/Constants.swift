//
//  Constants.swift
//  QuizApp
//
//  Created by Andras Sziffer on 2021. 01. 21..
//  Copyright © 2021. Andras Sziffer. All rights reserved.
//

import Foundation

/**
 Constants class for storing segues, cell identifiers etc
 */

struct K {
    
    static let myCell = "myCell"
    static let answerCell = "answerCell"
    
    static let swipeShowed = "swipeShowed"
    
    struct Segues {
        static let game = "startGame"
        static let gameFinished = "backToStartScreen"
    }
}
