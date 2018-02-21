//
//  AppData.swift
//  iQuiz
//
//  Created by Benny on 2/10/18.
//  Copyright © 2018 Benny Souriyadeth. All rights reserved.
//

import UIKit
import Foundation

class AppData: NSObject {
    static let shared = AppData()

    open var images : [String] = ["cube.png", "shield.png", "chem.png"]
    
    open var topics: [Topic] = []

}
