//
//  ViewController.swift
//  TeamsManager
//
//  Created by Sergey Vysotsky on 09.06.2022.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var dataStoreManager = DataStoreManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        var employee = dataStoreManager.obtainMainEmployee()
        
        print(employee.location)
    }
    
}

