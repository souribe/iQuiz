//
//  CongratsViewController.swift
//  iQuiz
//
//  Created by Benny on 2/11/18.
//  Copyright © 2018 Benny Souriyadeth. All rights reserved.
//

import UIKit

class CongratsViewController: UIViewController {

    @IBOutlet weak var score: UILabel!
    var appdata = AppData.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        if points / questions.count == 1 {
            score.text = "Perfect! You got \(points)/\(questions.count)"
        } else {
            score.text = "Almost! You got \(points)/\(questions.count)"
        }
        points = 0
    }

    @IBAction func nextPressed(_ sender: Any) {
                performSegue(withIdentifier: "congratsHome", sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
