//
//  ViewController.swift
//  iQuiz
//
//  Created by Benny on 2/9/18.
//  Copyright © 2018 Benny Souriyadeth. All rights reserved.
//

import UIKit

var myIndex = 0
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var appdata = AppData.shared
 
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appdata.topics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewControllerTableViewCell
        let topicObj = appdata.topics[indexPath.row]
        cell.myImage.image = UIImage(named: "\(topicObj.img)")
        cell.myTitle.text = "\(topicObj.title)"
        cell.desc.text = "\(topicObj.desc)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        performSegue(withIdentifier: "segue", sender: self)
    }
    
    @IBAction func SettingsPressed(_ sender: UIBarButtonItem) {
        _ = checkReachability()
        getData()
//        let alertController = UIAlertController(title: "Settings", message: "Settings go here", preferredStyle: .alert)
//        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alertController.addAction(defaultAction)
//        present(alertController, animated: true, completion: nil)
    }


    var refresher: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(ViewController.getData), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresher)
        //        let path = Bundle.main.path(forResource: "questions", ofType: "json")
        //        print(path!)
        //        let url = URL(fileURLWithPath: path!)
        //        print(url)
        getData()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func checkReachability() -> Bool {
        if currentReachabilityStatus == .reachableViaWiFi {
            print("User is connected to the internet via wifi.")
        }else if currentReachabilityStatus == .reachableViaWWAN{
            print("User is connected to the internet via WWAN.")
        } else {
            print("There is no internet connection")
        }
        if currentReachabilityStatus == .reachableViaWiFi || currentReachabilityStatus == .reachableViaWWAN {
            return true
        } else {
            return false
        }
    }
    
    @objc func getData() {
        appdata.topics.removeAll()
        let url = URL(string: "https://tednewardsandbox.site44.com/questions.json")
        if checkReachability() {
            let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
                if error != nil {
                    print("ERROR")
                    self.loadLocalJSONFile(filename: "questions")
                } else {
                    if let content = data {
                        do {
                            let myJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                            //                        let path = Bundle.main.path(forResource: "questions", ofType: "json")
                            //                        print(path!)
                            //                        let url = URL(fileURLWithPath: path!)
                            //                        print(url)
                            //                        let encodedData = try? JSONEncoder().encode(myJson)
                            UserDefaults.standard.set(myJson, forKey: "QuestionsJSON")
                            let data = UserDefaults.standard.object(forKey: "QuestionsJSON") as! NSArray
                            var idx = 0
                            for i in data {
                                let object = i as AnyObject
                                let title = object["title"] as! String
                                let desc = object["desc"] as! String
                                let tempQuestions = object["questions"] as! NSArray
                                var questions: [Question] = []
                                for questionObject in tempQuestions {
                                    let q = questionObject as AnyObject
                                    let answer = q["answer"] as! String
                                    let answers = q["answers"] as! [String]
                                    let text = q["text"] as! String
                                    let question = Question(answer: answer, answers: answers, text: text)
                                    questions.append(question)
                                }
                                let topic: Topic = Topic(title: title, desc: desc, img: self.appdata.images[idx], questions: questions)
                                self.appdata.topics.append(topic)
                                idx += 1
                            }
                        } catch {
                            print("Catch")
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    } else {
                        print("Error")
                    }
                }
            }
            task.resume()
        } else {
            self.loadLocalJSONFile(filename: "questions")
        }
        refresher.endRefreshing()
        tableView.reloadData()
    }
    
    func showQuizInformation(JSONResult: NSArray) {
        UserDefaults.standard.set(JSONResult, forKey: "QuestionsJSON")
        let data = UserDefaults.standard.object(forKey: "QuestionsJSON") as! NSArray
        var idx = 0
        for i in data {
            let object = i as AnyObject
            let title = object["title"] as! String
            let desc = object["desc"] as! String
            let tempQuestions = object["questions"] as! NSArray
            var questions: [Question] = []
            for questionObject in tempQuestions {
                let q = questionObject as AnyObject
                let answer = q["answer"] as! String
                let answers = q["answers"] as! [String]
                let text = q["text"] as! String
                let question = Question(answer: answer, answers: answers, text: text)
                questions.append(question)
            }
            let topic: Topic = Topic(title: title, desc: desc, img: self.appdata.images[idx], questions: questions)
            self.appdata.topics.append(topic)
            idx += 1
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func loadLocalJSONFile(filename: String) {
        if let path = Bundle.main.path(forResource: "\(filename)", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                UserDefaults.standard.set(jsonResult, forKey: "QuestionsJSON")
                self.showQuizInformation(JSONResult: jsonResult as! NSArray)
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        } else {
            print("Invalid filename/path.")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

