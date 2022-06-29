//
//  ViewController.swift
//  TeamsManager
//
//  Created by Sergey Vysotsky on 09.06.2022.
//

import UIKit
import CoreData

class TeamsViewController: UIViewController {

    // MARK: - Properties
    var dataStoreManager = DataStoreManager()
    var data: [Group] = []
    var isNoResult = false
    
    // MARK: - Visual Component
    private lazy var tableView = makeTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        view.addSubview(tableView)
        
        fetch()
    }
    
    func fetch() {

        self.dataStoreManager.fetchGroup() { result in
            switch result {
            case .success(let data):
                print("Success Team")

                //Data = [0]
                guard !data.isEmpty else {
                    
                    self.view = NoResultView(view: self.view).configureNoResult()
                    self.isNoResult = true
                    return
                }

                //Data = [...]
                if self.isNoResult {
                    let stackView = self.view.viewWithTag(100)
                    stackView?.removeFromSuperview()
                    self.isNoResult = false
                }

                data.forEach { print("Fetch Team: \($0.name)") }
                self.data = data

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }

            case .failure(let error):
                print("Failed with error: \(error)")
            }
        }
    }

    private func add(_ name: String) {
        dataStoreManager.add(name)
        dataStoreManager.saveContext()
        fetch()
    }

    private func insert(_ obj: Group) {
        dataStoreManager.insert(obj)
        dataStoreManager.saveContext()
        fetch()
    }

    private func delete(_ obj: Group) {
        dataStoreManager.delete(obj)
        dataStoreManager.saveContext()
        fetch()
    }
    
    private func deleteAll() {
        dataStoreManager.deleteAll()
        dataStoreManager.saveContext()
        fetch()
    }

    // MARK: - IBAction
    @IBAction func addGroupBarButton(_ sender: Any) {
        present(makeAlertController(), animated: true, completion: nil)
    }
    @IBAction func deleteAllGroupBarButton(_ sender: Any) {
        deleteAll()
    }
    @IBAction func editBarButton(_ sender: Any) {
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
}

// MARK: - Factory
extension TeamsViewController {

    func makeAlertController() -> UIAlertController {
        let alertController = UIAlertController(title: "Add team", message: nil, preferredStyle: .alert)

        let confirmAction = UIAlertAction(title: "Create", style: .default) { (_) in
            if let txtField = alertController.textFields?.first,
               let text = txtField.text {
                self.add(text)
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

    func makeTableView() -> UITableView {
        let table = UITableView(frame: CGRect.zero, style: .insetGrouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        table.sectionFooterHeight = 0               //---

        let nib = UINib(nibName: "TeamCell", bundle: nil)
        table.register(nib, forCellReuseIdentifier: Constants.teamCellIdentifier)

        return table
    }
}

// MARK: - TableView DataSource
extension TeamsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.teamCellIdentifier, for: indexPath) as? TeamCell else { fatalError("Xib doesn't exist - Unexpected Index Path") }
 
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        let team = data[indexPath.section]
        cell.nameTeam.text = team.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            tableView.beginUpdates()

            let selectGroup = data[indexPath.section]
            delete(selectGroup)
            print("Delete section: \(indexPath.section)")
            
            tableView.deleteSections(IndexSet(integer: indexPath.section), with: .top)
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = data[sourceIndexPath.section]
        
//        dataStoreManager.delete(itemToMove)
//        dataStoreManager.insert(itemToMove)

        data.remove(at: sourceIndexPath.section)
        data.insert(itemToMove, at: destinationIndexPath.section)
    }
}

// MARK: - TableView Delegate
extension TeamsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 10))
    }
}
