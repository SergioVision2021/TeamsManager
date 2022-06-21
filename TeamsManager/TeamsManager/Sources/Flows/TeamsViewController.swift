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
    var localData: [Group] = []
    var isNoResult = false
    
    // MARK: - Visual Component
    private lazy var tableView = makeTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTableView()
        fetch()
    }
    
    func fetch() {

        self.dataStoreManager.fetchGroup() { result in
            switch result {
            case .success(let data):
                print("Success")

                //Data = [0]
                guard !data.isEmpty else {
                    self.configureNoResult()
                    self.isNoResult = true
                    return
                }

                //Data = [...]
                if self.isNoResult {
                    let stackView = self.view.viewWithTag(100)
                    stackView?.removeFromSuperview()
                    self.isNoResult = false
                }

                data.forEach { print("Fetch: \($0.name)") }
                self.localData = data

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }

            case .failure(let error):
                print("Failed with error: \(error)")
            }
        }
    }

    func add(name: String) {
        dataStoreManager.add(name)
        dataStoreManager.save()
        fetch()
    }

    private func delete(_ group: Group) {
        dataStoreManager.delete(group)
        dataStoreManager.save()
        fetch()
    }
    
    private func insert(_ group: Group) {
        dataStoreManager.insert(group)
        dataStoreManager.save()
        fetch()
    }

    func configureNoResult() {
        let viewResult = makeView()
        view.addSubview(viewResult)

        let stackView = makeStackView()
        stackView.addArrangedSubview(makeLabel())
        stackView.addArrangedSubview(makeImageView())
        stackView.translatesAutoresizingMaskIntoConstraints = false
        viewResult.addSubview(stackView)

        //Constraints
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }

    // MARK: - IBAction
    @IBAction func addGroupBarButton(_ sender: Any) {
        present(makeAlertController(), animated: true, completion: nil)
    }

    @IBAction func editBarButton(_ sender: Any) {
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
}

// MARK: - Factory
extension TeamsViewController {

    func makeAlertController() -> UIAlertController {
        let alertController = UIAlertController(title: "Add new group", message: nil, preferredStyle: .alert)

        let confirmAction = UIAlertAction(title: "Save", style: .default) { (_) in
            if let txtField = alertController.textFields?.first,
               let text = txtField.text {
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

    func makeView() -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        view.backgroundColor = .white
        view.tag = 100
        return view
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

// MARK: - TableView
extension TeamsViewController {

    func addTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.frame = view.bounds
        view.addSubview(tableView)
    }
    
    func configureCell(_ cell: TeamCell, _ indexPath: IndexPath) {
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        let team = localData[indexPath.section]
        cell.nameTeam.text = team.name
    }
}

// MARK: - TableView DataSource
extension TeamsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return localData.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.teamCellIdentifier, for: indexPath) as? TeamCell else { fatalError("Unexpected Index Path") }
 
        configureCell(cell, indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            tableView.beginUpdates()

            let selectGroup = localData[indexPath.section]
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
        let itemToMove = localData[sourceIndexPath.section]
        
        localData.remove(at: sourceIndexPath.section)
        localData.insert(itemToMove, at: destinationIndexPath.section)
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

