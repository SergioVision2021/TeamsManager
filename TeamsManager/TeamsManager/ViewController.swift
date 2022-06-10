//
//  ViewController.swift
//  TeamsManager
//
//  Created by Sergey Vysotsky on 09.06.2022.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var addGroupButton: UIButton!
    
    var dataStoreManager = DataStoreManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBAction
    @IBAction func addGroupButton(_ sender: UIButton) {
        showAlertWithTextField()
    }
}

// MARK: - UIAlertController
extension ViewController {
    func showAlertWithTextField() {
        let alertController = UIAlertController(title: "Add new group", message: nil, preferredStyle: .alert)

        let confirmAction = UIAlertAction(title: "Save", style: .default) { (_) in
            if let txtField = alertController.textFields?.first, let text = txtField.text {

                self.dataStoreManager.add(name: text)
                self.dataStoreManager.save()
                self.dataStoreManager.fetchGroup() { result in
                    switch result {
                    case .success(let data):
                        print("Success")
                        data.forEach { print($0.name) }
                    case .failure(let error):
                        print("Failed with error: \(error)")
                    }
                }
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        alertController.addTextField { (textField) in
            textField.placeholder = "Group name"
        }

        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

