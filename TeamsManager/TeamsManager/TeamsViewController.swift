//
//  ViewController.swift
//  TeamsManager
//
//  Created by Sergey Vysotsky on 09.06.2022.
//

import UIKit
import CoreData

class TeamsViewController: UIViewController {

    var dataStoreManager = DataStoreManager()
    
    var localData: [Group] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetch()
    }
    
    func fetch() {
       
        self.dataStoreManager.fetchGroup() { result in
            switch result {
            case .success(let data):
                print("Success")
                
                guard !data.isEmpty else {
                    self.configureNoResult()
                    return
                }
                
                guard let stackView = self.view.viewWithTag(100) else  {
                    return
                }
                
                stackView.removeFromSuperview()
                
                data.forEach { print($0.name) }
                self.localData = data
            case .failure(let error):
                print("Failed with error: \(error)")
            }
        }
    }
    
    func add(name: String) {
        self.dataStoreManager.add(name: name)
        self.dataStoreManager.save()
        fetch()
    }

    func configureNoResult() {
        let stackView = makeStackView()
        stackView.addArrangedSubview(makeLabel())
        stackView.addArrangedSubview(makeImageView())
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.tag = 100
        view.addSubview(stackView)

        //Constraints
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }

    // MARK: - IBAction
    @IBAction func addGroupBarButton(_ sender: Any) {
        self.present(makeAlertController(), animated: true, completion: nil)
    }
    
    @IBAction func deleteAllGroupBarButton(_ sender: Any) {
        self.dataStoreManager.delete()
    }
}

// MARK: - UIAlertController
extension TeamsViewController {
    func makeAlertController() -> UIAlertController {
        let alertController = UIAlertController(title: "Add new group", message: nil, preferredStyle: .alert)

        let confirmAction = UIAlertAction(title: "Save", style: .default) { (_) in
            if let txtField = alertController.textFields?.first, let text = txtField.text {
                self.add(name: text)
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        alertController.addTextField { (textField) in
            textField.placeholder = "Group name"
        }

        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        return alertController
    }

    func makeImageView() -> UIImageView {
        let imageView = UIImageView(image: UIImage(named: "Image.png"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }

    func makeLabel() -> UILabel {
        let label = UILabel()
        label.text = "No result"
        return label
    }

    func makeStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing = 16.0
        return stackView
    }
}



