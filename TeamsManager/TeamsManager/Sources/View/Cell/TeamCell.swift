//
//  TeamCell.swift
//  TeamsManager
//
//  Created by Sergey Vysotsky on 17.06.2022.
//

import UIKit

class TeamCell: UITableViewCell {

    @IBOutlet weak var nameTeam: UILabel!
    @IBOutlet weak var countEmployees: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.systemGray4.cgColor
    }
}
