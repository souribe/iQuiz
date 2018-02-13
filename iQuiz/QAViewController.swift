//
//  QAViewController.swift
//  iQuiz
//
//  Created by Benny on 2/10/18.
//  Copyright © 2018 Benny Souriyadeth. All rights reserved.
//

import UIKit

var points = 0
var questions : [String] = []
var currentQuestion = 0 // global to keep after changing views

// send to AnswerViewController
var currentA = ""
var currentQ = ""
var moreQs = false
var isItRight = false

class QAViewController: UIViewController {

    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var answer1: UIButton!
    @IBOutlet weak var answer2: UIButton!
    @IBOutlet weak var answer3: UIButton!
    @IBOutlet weak var answer4: UIButton!
    @IBOutlet weak var pageTitle: UINavigationItem!
    @IBOutlet weak var submitButton: UIButton!
    
    var appdata = AppData.shared
    
    //var currentQuestion = 0
    var rightAnswerPlacement:UInt32 = 0
    var beforeTag = -1
    var currentTag = -1
    var currentButton:UIButton = UIButton()
    var answers : [[String]] = []
    
    @IBAction func answerPressed(_ sender: Any) {
        if beforeTag == -1 {
            beforeTag = 0
            currentButton = sender as! UIButton
            currentButton.isSelected = true
        } else {
            currentButton.isSelected = false
            currentButton = sender as! UIButton
            currentButton.isSelected = true
        }
        currentTag = (sender as AnyObject).tag
        print(currentTag)
        submitButton.isEnabled = true
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        newQuestion()
    }
    
    // function that displays new question
    func newQuestion() {
        print("myindex: \(myIndex) ")
        switch(myIndex) {
        case 0 :
            questions = appdata.mathQuestions
            answers = appdata.mathAnswers
        case 1 :
            questions = appdata.shieldQuestions
            answers = appdata.shieldAnswers
        default:
            questions = appdata.scienceQuestions
            answers = appdata.scienceAnswers
        }
        
        print("currentQuestion: \(currentQuestion) ")
        print(questions)

        currentQ = questions[currentQuestion] //store question
        question.text = currentQ
        
        rightAnswerPlacement = arc4random_uniform(4) + 1
        currentA = answers[currentQuestion][0] // store correct answer
        
        // answer randomizer
        // Create a button
        var button:UIButton = UIButton()
        var x = 1
        
        for i in 1...4 {
            // Create a button
            button = view.viewWithTag(i) as! UIButton
            if (i == Int(rightAnswerPlacement)) { // if i button index is equal to rightAnswerPlacement
                button.setTitle(currentA, for: .normal)
            } else {
                button.setTitle(answers[currentQuestion][x], for: .normal)
                x += 1
            }
        }
        currentQuestion += 1
    }
    
    @IBAction func submitPressed(_ sender: Any) {
        if (currentTag == Int(rightAnswerPlacement)) {
            print ("Right!")
            isItRight = true
            points += 1
        } else {
            print("Wrong!")
            isItRight = false
        }
        
        // goes to new question
        if (currentQuestion != questions.count) {
            //newQuestion()
            currentButton.isSelected = false
            moreQs = true
            performSegue(withIdentifier: "qaToAnswer", sender: self)
        } else {
            moreQs = false
            currentQuestion = 0
            performSegue(withIdentifier: "qaToAnswer", sender: self)
        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        performSegue(withIdentifier: "backHome", sender: self)
        currentQuestion = 0
        points = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
