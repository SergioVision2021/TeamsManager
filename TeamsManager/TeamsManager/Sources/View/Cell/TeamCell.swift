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
    @IBOutlet weak var shadowLayer: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
//        backgroundColor = .clear
//
//        self.containerView.layer.borderWidth = 1
//        self.containerView.layer.cornerRadius = 10
//        self.containerView.layer.borderColor = UIColor.clear.cgColor
//        self.containerView.layer.masksToBounds = true
//
//        self.layer.shadowOpacity = 0.18
//        self.layer.shadowOffset = CGSize(width: 0, height: 2)
//        self.layer.shadowRadius = 2
//        self.layer.shadowColor = UIColor.black.cgColor
//        self.layer.masksToBounds = false
        
//        backgroundColor = .clear
//
//        self.layer.cornerRadius = 20
//        self.layer.borderColor = UIColor.clear.cgColor
//        self.layer.masksToBounds = true
//
//        self.shadowLayer.layer.shadowOpacity = 0.18
//        self.shadowLayer.layer.shadowOffset = CGSize(width: 0, height: 2)
//        self.shadowLayer.layer.shadowRadius = 2
//        self.shadowLayer.layer.shadowColor = UIColor.black.cgColor
//        self.shadowLayer.layer.masksToBounds = false
        
        self.shadowLayer.backgroundColor = .clear
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.systemGray4.cgColor
    }
}
