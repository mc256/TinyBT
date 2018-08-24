//
//  DownloadItemTableViewCell.swift
//  serika
//
//  Created by maverick on 2018/8/24.
//  Copyright © 2018 maverick. All rights reserved.
//

import UIKit
import FontAwesome_swift

class DownloadItemTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressIndicator: UIProgressView!
    
    @IBOutlet weak var downloadIcon: UILabel!
    @IBOutlet weak var uploadIcon: UILabel!
    @IBOutlet weak var statusIcon: UILabel!
    
    @IBOutlet weak var downloadSpeedLabel: UILabel!
    @IBOutlet weak var uploadSpeedLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        downloadIcon.font = UIFont.fontAwesome(ofSize: 12.0)
        downloadIcon.text = String.fontAwesomeIcon(name: .arrowCircleDown)
        uploadIcon.font = UIFont.fontAwesome(ofSize: 12.0)
        uploadIcon.text = String.fontAwesomeIcon(name: .arrowCircleUp)
        statusIcon.font = UIFont.fontAwesome(ofSize: 12.0)
        statusIcon.text = String.fontAwesomeIcon(name: .refresh)
        downloadSpeedLabel.text = "---"
        uploadSpeedLabel.text = "---"
        titleLabel.text = "--------"
        progressIndicator.progress = 0.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
}

public enum DownloadStatusCase: Int{
    case pending = 0
    case downloading = 1
    case finished = 2
    case completed = 3
}
