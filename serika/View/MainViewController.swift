//
//  MainViewController.swift
//  serika
//
//  Created by maverick on 2018/8/24.
//  Copyright © 2018 maverick. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        TaskModel.shared.taskStart(viewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return TaskModel.shared.taskInformation?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DownloadItemCell", for: indexPath) as! DownloadItemTableViewCell

        if let _torrent = TaskModel.shared.taskInformation?[indexPath.row] {
            cell.titleLabel.text = _torrent["name"].string
            cell.progressIndicator.progress = _torrent["percentDone"].floatValue
            cell.status = DownloadStatusCase(rawValue: _torrent["status"].int ?? 0)!
            if (cell.status == .stopped){
                if (_torrent["error"].int != 0){
                    cell.status = .error
                }else if (_torrent["isFinished"].bool == true) {
                    cell.status = .completed
                }
            }
            
        }

        return cell
    }

    
    func humanReadableSpeed(bytePerSecond: Int) -> String {
        var holder = 0.0
        if bytePerSecond == 0 {
            return "0"
        }
        holder = bytePerSecond.
        
        
        
    }

}
