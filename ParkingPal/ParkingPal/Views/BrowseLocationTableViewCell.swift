//
//  BrowseLocationTableViewCell.swift
//  ParkingPal
//
//  Created by Eric Robertson on 5/2/18.
//  Copyright © 2018 Eric Robertson. All rights reserved.
//

import UIKit

class BrowseLocationTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
