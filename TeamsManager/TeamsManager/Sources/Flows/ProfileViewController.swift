//
//  ProfileViewController.swift
//  TeamsManager
//
//  Created by Sergey Vysotsky on 21.06.2022.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var lbName: UILabel!
    
    var profile: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbName.text = profile
    }
}
