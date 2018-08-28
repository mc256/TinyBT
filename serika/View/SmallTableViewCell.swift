//
//  SmallTableViewCell.swift
//  serika
//
//  Created by maverick on 2018/8/27.
//  Copyright © 2018 maverick. All rights reserved.
//

import UIKit

class SmallTableViewCell: UITableViewCell {

    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
