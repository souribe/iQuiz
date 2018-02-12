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
    open var descriptions: [String] = ["You do not study mathematics because it helps you build a bridge. You study mathematics because it is the poetry of the universe", "We protec, we attac, we are a counter-terrorism and intelligence agency.", "Science rules!"]
    
    open var mathQuestions = [
        "What is the Pythagorean Theorem?",
        "What is 1 + 1?"
    ]
    open var mathAnswers = [
        ["a2 + b2 = c2", "c2 + b2 = a2", "I don't know bruh", "E = MC2"],
        ["Rick James", "1", "2", "3"]
    ]
    
    open var shieldQuestions = [
        "Who was Shield formerly run by?"
    ]
    open var shieldAnswers = [
        ["Nick Fury", "Sif", "List", "Jasper Sitwell"]
    ]
    
    open var scienceQuestions = [
        "Why Is Water Wet"
    ]
    
    open var scienceAnswers = [
        ["Water is polar", "The feeling of wetness is actually coldness", "It isn't", "Because it's water"]
    ]
    
    
    func getQuizzes() -> [String] {
        return quiz
    }
}
