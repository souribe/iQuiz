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
var qCount = 0

var questionArray = [Question(answer: "", answers: [""], text: "" )] // array of questions
var topic : Topic = Topic(title: "", desc: "", img: "", questions: questionArray) //

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
    
    var topicObj : Topic = Topic(title: "", desc: "", img: "", questions: []) // get Topic object
    var questionObj : Question = Question(answer: "", answers: [""], text: "")
    
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
        //print(currentTag)
        submitButton.isEnabled = true
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        newQuestion()
    }
    
    // function that displays new question
    func newQuestion() {
        qCount += 1
        
        topicObj = appdata.topics[myIndex]
        pageTitle.title = topicObj.title
        questionArray = topicObj.questions
        print("below is the q number")
        print(appdata.topics[myIndex].questions.count - 1)
        print("below is currentQ number")
        print(currentQuestion)
        
        
        print("qCount = ")
        print(qCount)
        let singleQuestion = questionArray[currentQuestion]
        answers = [singleQuestion.answers]
        question.text = singleQuestion.text
        
        
        
        currentA = questionArray[currentQuestion].answer // store correct answer
        currentQ = singleQuestion.text //store question
        //question.text = currentQ
        
        rightAnswerPlacement = arc4random_uniform(4) + 1

        
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
                button.setTitle(singleQuestion.answers[x - 1], for: .normal)
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
        if (currentQuestion < appdata.topics[myIndex].questions.count - 1) {
            newQuestion()
  
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
