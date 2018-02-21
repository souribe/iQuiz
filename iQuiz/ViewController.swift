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
 
    var fromUrl = "https://tednewardsandbox.site44.com/questions.json"
    var isOn = false
    var downloadErr = false
    
    
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
    
    func checkJsonData() {
        isOn = checkReachability()
        getData()
    }
    
    @IBAction func SettingsPressed(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Settings", message: "Download JSON", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let action1 = UIAlertAction(title: "Check Now", style: .default) { (action) in
            self.checkJsonData()
            
            var network = ""
            //var dErr = ""
            if self.isOn == true {
                network = "Network is available"
            } else {
                network = "Network not available"
            }
//            if self.downloadErr {
//                dErr = "Download Failed"
//            } else {
//                dErr = "File Downloaded"
//            }
            
            let alertController2 = UIAlertController(title: "Network Availability", message: network, preferredStyle: .alert)
            let action2 = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController2.addAction(action2)
            self.present(alertController2, animated: true, completion: nil)
        }
        alertController.addAction(defaultAction)
        alertController.addAction(action1)
        present(alertController, animated: true, completion: nil)
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
    
    var didGetData = false
    
    @objc func getData() {
        appdata.topics.removeAll()
        let url = URL(string: fromUrl)
        if checkReachability() {
            let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
                if error != nil {
                    print("ERROR")
                    self.loadLocalJSONFile(filename: "questions")
                } else {
                    if let content = data {
                        do {
                            let myJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                            UserDefaults.standard.set(myJson, forKey: "QuestionsJSON")
                            let data = UserDefaults.standard.object(forKey: "QuestionsJSON") as! NSArray
                            self.showQuizInformation(JSONResult: data)
                            
                            self.saveDataOnDisk(jsonData: data)
                            
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
    
    func saveDataOnDisk(jsonData:NSArray) {
        let documentsDirectoryPathString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let documentsDirectoryPath = NSURL(string: documentsDirectoryPathString)!
        
        let jsonFilePath = documentsDirectoryPath.appendingPathComponent("questions.json")

        
        let fileManager = FileManager.default
        var isDirectory: ObjCBool = false
        
        // creating a .json file in the Documents folder
        if !fileManager.fileExists(atPath: (jsonFilePath?.absoluteString)!, isDirectory: &isDirectory) {
            let created = fileManager.createFile(atPath: (jsonFilePath?.absoluteString)!, contents: nil, attributes: nil)
            if created {
                print("File created ")
            } else {
                print("Couldn't create file for some reason")
            }
        } else {
            print("File already exists")
        }
        
        // creating an array of test data
        var dataList = [NSArray]()
        //let names = ["Anna", "Alex", "Brian", "Jack"]
        
        dataList.append(jsonData)
        
     
        
        // creating JSON out of the above array
        var jsonData: NSData!
        do {
            jsonData = try JSONSerialization.data(withJSONObject: dataList, options: JSONSerialization.WritingOptions()) as NSData
            _ = String(data: jsonData as Data, encoding: String.Encoding.utf8)
            //print(jsonString)
        } catch let error as NSError {
            print("Array to JSON conversion failed: \(error.localizedDescription)")
        }
        
        // Write that JSON to the file created earlier
        _ = documentsDirectoryPath.appendingPathComponent("questions.json")
        do {
            let file = try FileHandle(forWritingTo: jsonFilePath!)
            file.write(jsonData as Data)
            print("JSON data was written to the file successfully!")
        } catch let error as NSError {
            print("Couldn't write to file: \(error.localizedDescription)")
        }
    }
    
//    func getDocumentsDirectory() -> URL {
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        return paths[0]
//    }
    
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

