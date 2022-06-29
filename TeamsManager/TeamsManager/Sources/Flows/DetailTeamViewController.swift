//
//  DetailTeamViewController.swift
//  TeamsManager
//
//  Created by Sergey Vysotsky on 20.06.2022.
//

import UIKit

class DetailTeamViewController: UIViewController {
    
    // MARK: - Properties
    internal var delegate: DetailTeamDelegate?
    
    var dataStoreManager = DataStoreManager()
    var data: [Employee] = []
    var isNoResult = false
    
    // MARK: - Visual Component
    private lazy var tableView = makeTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        moreBarButtonItem()
        addTableView()
        fetch()


//        start()
    }
    
//    func start() {
//        var service = EmployeeService()
//        service.source = data
//        service.filterPosition()
//        dataTableView = service.employees
//    }

    
    
    
    func fetch() {
        self.dataStoreManager.fetchEmployee() { result in
            switch result {
            case .success(let data):
                print("Success Detail")

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

                data.forEach { print("Fetch Employee: \($0.firstName) + group \($0.group)") }
                self.data = data

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }

            case .failure(let error):
                print("Failed with error: \(error)")
            }
        }
    }
}

// MARK: - Factory
extension DetailTeamViewController {

    func makeAlertController() -> UIAlertController {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let editAction = UIAlertAction(title: "Edit", style: .default, handler: { (_) in
            print("tap edit")
        })
        
        let addProfileAction = UIAlertAction(title: "Add profile", style: .default, handler: { (_) in
            print("tap add profile")
        })
        
        let cacelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            print("tap cancel")
        })

        alertController.addAction(editAction)
        alertController.addAction(addProfileAction)
        alertController.addAction(cacelAction)
        
        return alertController
    }
    
    func makeTableView() -> UITableView {
        let table = UITableView(frame: CGRect.zero, style: .insetGrouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        table.sectionFooterHeight = 0               //---

        let nib = UINib(nibName: "EmployeeCell", bundle: nil)
        table.register(nib, forCellReuseIdentifier: Constants.employeeCellIdentifier)

        return table
    }
}

// MARK: - TableView
extension DetailTeamViewController {

    func addTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.frame = view.bounds
        view.addSubview(tableView)
    }
    
    func configureCell(_ cell: EmployeeCell, _ indexPath: IndexPath) {
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        let employee = data[indexPath.section]
        cell.name.text = employee.firstName
        cell.detail.text = employee.lastName
    }
}

// MARK: - TableView DataSource
extension DetailTeamViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.employeeCellIdentifier, for: indexPath) as? EmployeeCell else { fatalError("Unexpected Index Path") }
 
        configureCell(cell, indexPath)
        return cell
    }
}

// MARK: - TableView Delegate
extension DetailTeamViewController: UITableViewDelegate {

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

// MARK: - BarButtonItem
private extension DetailTeamViewController {
    func moreBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self,
                                                            action: #selector(moreActionButton(sender:)))
    }

    @objc
    func moreActionButton(sender: UIBarButtonItem) {
        
        dataStoreManager.addDefault()
        dataStoreManager.saveContext()
        fetch()
        
        //self.present(makeAlertController(), animated: true, completion: nil)
    }
}
