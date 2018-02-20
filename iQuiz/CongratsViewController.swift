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
        print("points = \(points)")
        print("questionCount = \(qCount)")
        if points / qCount == 1 {
            score.text = "Perfect! You got \(points)/\(qCount)"
        } else if points != 0 {
            score.text = "Not bad, You got \(points)/\(qCount)"
        } else {
            score.text = "Oooooh sorry mate, You got \(points)/\(qCount)"
        }
        points = 0
        qCount = 0
    }

    @IBAction func nextPressed(_ sender: Any) {
        performSegue(withIdentifier: "congratsHome", sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
