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
        
        TaskModel.shared.sessionStart()
        TaskModel.shared.taskStart(viewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
            cell.uploadSpeedLabel.text = humanReadableSpeed(bytePerSecond: _torrent["rateUpload"].int ?? 0)
            cell.downloadSpeedLabel.text = humanReadableSpeed(bytePerSecond: _torrent["rateDownload"].int ?? 0)
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        presentDetail(indexPath: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailSegue" {
            if let viewController = segue.destination as? DetailViewController {
                guard let indexPath = sender as? IndexPath else{
                    return
                }
                viewController.torrentInformation = TaskModel.shared.taskInformation?[indexPath.row]
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let cell = tableView.cellForRow(at: indexPath) as! DownloadItemTableViewCell
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Remove") { (action, indexPath) in
            // TODO
            
        }
        deleteAction.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        
        var stateChangeAction: UITableViewRowAction?
        switch cell.status {
        case .completed, .stopped, .error:
            stateChangeAction = UITableViewRowAction(style: .normal, title: "Resume", handler: { (action, indexPath) in
                // TODO
                
            })
            stateChangeAction!.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        default:
            stateChangeAction = UITableViewRowAction(style: .normal, title: "Pause", handler: { (action, indexPath) in
                // TODO
                
            })
            stateChangeAction!.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        }
        
        let detailAction = UITableViewRowAction(style: .normal, title: "Detail") { (action, indexPath) in
            self.presentDetail(indexPath: indexPath)
        }
        detailAction.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        
        return [detailAction, stateChangeAction!, deleteAction]
    }

    
    func humanReadableSpeed(bytePerSecond: Int) -> String {
        var holder = 0.0
        if bytePerSecond == 0 {
            return "0"
        }
        if (Double(bytePerSecond) / 1024.0 < 1) {
            return String(bytePerSecond) + "B/s"
        }
        holder = Double(bytePerSecond) / 1024.0
        if ( (holder / 1024.0)  < 1){
            return String(format: "%.01fKB/s", holder)
        }
        holder = holder / 1024.0
        if ( (holder / 1024.0)  < 1){
            return String(format: "%.01fMB/s", holder)
        }
        holder = holder / 1024.0
        return String(format: "%.01fGB/s", holder)
    }
    
    func presentDetail(indexPath: IndexPath){
        self.performSegue(withIdentifier: "ShowDetailSegue", sender: indexPath)
    }

}
