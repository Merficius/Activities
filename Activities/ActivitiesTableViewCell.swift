//
//  ActivitiesTableViewCell.swift
//  Activities
//
//  Created by José Mariano Portilla Landa on 10/05/22.
//

import UIKit

class ActivitiesTableViewCell: UITableViewCell {

    @IBOutlet var ActivityNameLabel: UILabel!
    @IBOutlet var ActivityDurationLabel: UILabel!
    @IBOutlet var ActivityControlButton: UIButton!
    var firstTapControlButton = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
