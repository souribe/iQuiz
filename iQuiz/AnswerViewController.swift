//
//  AnswerViewController.swift
//  iQuiz
//
//  Created by Benny on 2/12/18.
//  Copyright © 2018 Benny Souriyadeth. All rights reserved.
//

import UIKit

// takes in: moreQs, currentQ, currentA, isItRight

class AnswerViewController: UIViewController {

    var appdata = AppData.shared
    
    @IBOutlet weak var curQuestion: UILabel!
    @IBOutlet weak var curAnswer: UILabel!
    @IBOutlet weak var gotItRight: UILabel!
    
    @IBAction func nextPressed(_ sender: Any) {
        if moreQs == true {
            performSegue(withIdentifier: "answerToQuestion", sender: self)
        } else {
            performSegue(withIdentifier: "answerToCongrats", sender: self)
        }
    }
    
    @IBAction func answerToHome(_ sender: Any) {
        performSegue(withIdentifier: "answerToHome", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        curQuestion.text = currentQ
        curAnswer.text = currentA
        
        if isItRight == true {
            gotItRight.text = "Congrats mate! You got it right :)"
        } else {
            gotItRight.text = "Sorry mate, got it wrong :("
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
