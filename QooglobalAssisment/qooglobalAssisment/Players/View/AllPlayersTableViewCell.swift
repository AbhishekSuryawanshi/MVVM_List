//
//  AllPlayersTableViewCell.swift
//  qooglobalAssisment
//
//  Created by Abhishek Suryawanshi on 22/03/23.
//

import UIKit

class AllPlayersTableViewCell: UITableViewCell {

    @IBOutlet weak var listBackView: UIView!
    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var positionNameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        listBackView.layer.shadowColor = UIColor.lightGray.cgColor
        listBackView.layer.shadowOpacity = 0.5
        listBackView.layer.shadowRadius = 2
        listBackView.layer.shadowOffset = CGSize(width: 1, height: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
