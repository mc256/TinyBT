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
    
    var status: DownloadStatusCase = .empty {
        didSet{
            switch status {
            case .stopped:
                statusIcon.textColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
                statusIcon.text = String.fontAwesomeIcon(name: .pause)
            case .completed:
                statusIcon.textColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
                statusIcon.text = String.fontAwesomeIcon(name: .check)
            case .error:
                statusIcon.textColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
                statusIcon.text = String.fontAwesomeIcon(name: .timesCircle)
            case .checkWait:
                statusIcon.textColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
                statusIcon.text = String.fontAwesomeIcon(name: .clock)
            case .check:
                statusIcon.textColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
                statusIcon.text = String.fontAwesomeIcon(name: .search)
            case .downloadWait:
                statusIcon.textColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
                statusIcon.text = String.fontAwesomeIcon(name: .clock)
            case .downloading:
                statusIcon.textColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
                statusIcon.text = String.fontAwesomeIcon(name: .sync)
            case .seedingWait:
                statusIcon.textColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
                statusIcon.text = String.fontAwesomeIcon(name: .clock)
            case .seeding:
                statusIcon.textColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
                statusIcon.text = String.fontAwesomeIcon(name: .sync)
            default:
                statusIcon.text = ""
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        downloadIcon.font = UIFont.fontAwesome(ofSize: 12.0, style: .solid)
        downloadIcon.text = String.fontAwesomeIcon(name: .arrowCircleDown)
        uploadIcon.font = UIFont.fontAwesome(ofSize: 12.0, style: .solid)
        uploadIcon.text = String.fontAwesomeIcon(name: .arrowCircleUp)
        statusIcon.font = UIFont.fontAwesome(ofSize: 12.0, style: .solid)
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
    case empty = -1
    
    //TR_STATUS_STOPPED = 0, /* Torrent is stopped */
    case stopped = 0
    case completed = 10
    case error = 20
    
    //TR_STATUS_CHECK_WAIT = 1, /* Queued to check files */
    case checkWait = 1
    
    //TR_STATUS_CHECK = 2, /* Checking files */
    case check = 2
    
    //TR_STATUS_DOWNLOAD_WAIT = 3, /* Queued to download */
    case downloadWait = 3
    
    //TR_STATUS_DOWNLOAD = 4, /* Downloading */
    case downloading = 4
    
    //TR_STATUS_SEED_WAIT = 5, /* Queued to seed */
    case seedingWait = 5
    
    //TR_STATUS_SEED = 6 /* Seeding */
    case seeding = 6

}
