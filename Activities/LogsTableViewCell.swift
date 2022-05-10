//
//  LogsTableViewCell.swift
//  Activities
//
//  Created by José Mariano Portilla Landa on 09/05/22.
//

import UIKit

class LogsTableViewCell: UITableViewCell {

    @IBOutlet var LogsActivityNameLabel: UILabel!
    @IBOutlet var LogsActivityDurationLabel: UILabel!
    @IBOutlet var LogsActivityPercentageLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
