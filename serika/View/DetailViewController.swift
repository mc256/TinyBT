//
//  DetailViewController.swift
//  serika
//
//  Created by maverick on 2018/8/26.
//  Copyright © 2018 maverick. All rights reserved.
//

import UIKit
import SwiftyJSON

class DetailViewController: UITableViewController {
    // MARK: - Connections
    
    var torrentInformation: JSON? = nil
    
    let sectionHeader:[String?] = [
        "    Torrent",
        "    Transfer",
        "    Control",
        nil
    ]
    let rowStyle:[[TableViewCellStyle]] = [
        [.large, .large, .small, .small, .small],
        [.small, .small, .small, .small, .small],
        [.button, .button, .buttonRed, .buttonRed]
    ]
    let rowTitle:[[String]] = [
        ["Torrent Name", "Location", "Added Time", "Size", "Status"],
        ["Progress", "Upload", "Download", "Peers", "Upload Ratio"],
        ["Pause", "Resume", "Delete", "Delete and Remove"]
    ]
    let rowDataSource:[[String]] = [
        ["name", "downloadDir", "_addedDate", "_size", "_status"],
        ["_progress", "_uploadSpeed", "_downloadSpeed", "_peers", "_uploadRatio"],
        ["","","",""]
    ]
    let rowAction:[[((Int)->Bool)?]] = [
        [nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil],
        [
            {(id) in
                TaskModel.shared.torrentPause(id: id)
                return false},
            {(id) in
                TaskModel.shared.torrentResume(id: id)
                return false
            },
            {(id) in
                TaskModel.shared.torrentRemove(id: id, removeFile: false)
                return true
            },
            {(id) in
                TaskModel.shared.torrentRemove(id: id, removeFile: true)
                return true
            },
        ]
    ]
    
    // MARK: - View Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateInformation()
        if let _id = torrentInformation?["id"].intValue {
            TaskModel.shared.detailStart(viewController: self, id: _id)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        TaskModel.shared.detailInactivative()
    }
    
    func updateInformation(){
        if torrentInformation == nil {
            return
        }
        if let _addedDate = torrentInformation!["addedDate"].int {
            torrentInformation!["_addedDate"].string = TaskModel.unixTimestampToLocalTime(time: Double(_addedDate))
        }
        if let _totalSize = torrentInformation!["totalSize"].int {
            torrentInformation!["_size"].string = TaskModel.humanReadableSize(bytes: _totalSize)
        }
        if let _status = torrentInformation!["status"].int {
            var itemStatus = DownloadStatusCase(rawValue: _status)!
            if (itemStatus == .stopped){
                if (torrentInformation!["error"].int != 0){
                    itemStatus = .error
                }else if (torrentInformation!["isFinished"].bool == true) {
                    itemStatus = .completed
                }
            }
            
            switch (itemStatus) {
            case .check:
                torrentInformation!["_status"].string = "Checking"
            case .checkWait:
                torrentInformation!["_status"].string = "Checking (Queued)"
            case .completed:
                torrentInformation!["_status"].string = "Completed"
            case .downloading:
                torrentInformation!["_status"].string = "Downloading"
            case .downloadWait:
                torrentInformation!["_status"].string = "Downloading (Queued)"
            case .empty:
                torrentInformation!["_status"].string = "Unknown"
            case .error:
                torrentInformation!["_status"].string = "Error"
            case .seeding:
                torrentInformation!["_status"].string = "Seeding"
            case .seedingWait:
                torrentInformation!["_status"].string = "Seeding (Queued)"
            case .stopped:
                torrentInformation!["_status"].string = "Paused"
            }
            
        }
        if let _progress = torrentInformation!["percentDone"].double {
            torrentInformation!["_progress"].string = TaskModel.percentageToString(percentage: _progress)
        }
        if let _speed = torrentInformation!["rateUpload"].int {
            torrentInformation!["_uploadSpeed"].string = TaskModel.humanReadableSpeed(bytesPerSecond: _speed)
        }
        if let _speed = torrentInformation!["rateDownload"].int {
            torrentInformation!["_downloadSpeed"].string = TaskModel.humanReadableSpeed(bytesPerSecond: _speed)
        }
        if  let _peerConnected = torrentInformation!["peersConnected"].int,
            let _peerGetting = torrentInformation!["peersGettingFromUs"].int,
            let _peerSending = torrentInformation!["peersSendingToUs"].int{
            torrentInformation!["_peers"].string = String(format: "%d (UP:%d, DOWN:%d)", _peerConnected, _peerGetting, _peerSending)
        }
        
        if let _uploadRatio = torrentInformation!["uploadRatio"].double {
            torrentInformation!["_uploadRatio"].string = String(format: "%0.2f", _uploadRatio)
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return rowStyle.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowStyle[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = nil
        switch rowStyle[indexPath.section][indexPath.row] {
        case .small:
            let _cell = tableView.dequeueReusableCell(withIdentifier: "SmallLabelCell", for: indexPath) as! SmallTableViewCell
            _cell.keyLabel.text = rowTitle[indexPath.section][indexPath.row]
            _cell.valueLabel.text = torrentInformation?[rowDataSource[indexPath.section][indexPath.row]].string ?? "---"
            cell = _cell
        case .large:
            let _cell = tableView.dequeueReusableCell(withIdentifier: "LargeLabelCell", for: indexPath) as! LargeTableViewCell
            _cell.keyLabel.text = rowTitle[indexPath.section][indexPath.row]
            _cell.valueLabel.text = torrentInformation?[rowDataSource[indexPath.section][indexPath.row]].string ?? "---"
            cell = _cell
        case .button:
            let _cell = tableView.dequeueReusableCell(withIdentifier: "NormalButtonCell", for: indexPath) as! ButtonTableViewCell
            _cell.buttonLabel.text = rowTitle[indexPath.section][indexPath.row]
            cell = _cell
        case .buttonRed:
            let _cell = tableView.dequeueReusableCell(withIdentifier: "AlertButtonCell", for: indexPath) as! ButtonRedTableViewCell
            _cell.buttonLabel.text = rowTitle[indexPath.section][indexPath.row]
            cell = _cell
        }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if rowAction[indexPath.section][indexPath.row]?(torrentInformation!["id"].intValue) == true {
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeader[section]
    }

    
    public enum TableViewCellStyle: Int{
        case small = 1
        case large = 2
        case button = 3
        case buttonRed = 4
    }
}


