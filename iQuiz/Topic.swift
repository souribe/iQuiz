//
//  Topic.swift
//  iQuiz
//
//  Created by Benny on 2/18/18.
//  Copyright © 2018 Benny Souriyadeth. All rights reserved.
//

import Foundation

class Topic {
    var title: String
    var desc: String
    var img: String
    var questions: [Question]
    
    init(title: String, desc: String, img: String, questions: [Question]) {
        self.title = title
        self.desc = desc
        self.img = img
        self.questions = questions
    }
    
    var description : String {
        return "Title: \(self.title), Description: \(self.desc), ImageName: \(self.img)"
    }
}
