//
//  AppData.swift
//  iQuiz
//
//  Created by Benny on 2/10/18.
//  Copyright © 2018 Benny Souriyadeth. All rights reserved.
//

import UIKit

class AppData: NSObject {
    static let shared = AppData()
    open var quiz : [String] = ["Mathematics", "Shield", "Science"]
    open var images : [String] = ["cube.png", "shield.png", "chem.png"]
    open var descriptions: [String] = ["You do not study mathematics because it helps you build a bridge. You study mathematics because it is the poetry of the universe", "We protec, we attac, we are a counter-terrorism and intelligence agency formerly run by Nick Fury", "Science rules!"]
    
    
    open var mathQuestions = [
        "What is the Pythagorean Theorem?",
        "What is 1 + 1?"
    ]
    
    open var mathAnswers = [
        ["E = MC2", "a2 + b2 = c2", "c2 + b2 = a2", "I don't know bruh"],
        ["Rick James", "1", "2", "3"]
    ]
    
    open var shieldQuestions = [
        "Who is the front-runner MVP of the NBA right now?"
    ]
    
    open var shieldAnswers = [
        ["James Harden", "Steph Curry", "LeBron James", "Russell Westbrook"]
    ]
    
    
    
    func getQuizzes() -> [String] {
        return quiz
    }
}
