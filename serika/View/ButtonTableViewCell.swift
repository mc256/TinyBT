//
//  ButtonTableViewCell.swift
//  serika
//
//  Created by maverick on 2018/8/27.
//  Copyright © 2018 maverick. All rights reserved.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {

    var actionDelegation:((Any)->Void)? = nil
    
    @IBOutlet weak var cellButton: UIButton!
    @IBAction func buttonClick(_ sender: Any) {
        actionDelegation?(sender)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
