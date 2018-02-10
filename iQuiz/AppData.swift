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
    
    func getQuizzes() -> [String] {
        return quiz
    }
}
