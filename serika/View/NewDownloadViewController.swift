//
//  NewDownloadViewController.swift
//  serika
//
//  Created by maverick on 2018/8/27.
//  Copyright © 2018 maverick. All rights reserved.
//

import UIKit

class NewDownloadViewController: UITableViewController {
    @IBOutlet weak var fileNameText: UITextField!
    @IBOutlet weak var pathText: UITextField!
    
    let rowList:[Int] = [2,1]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if pathText.text == nil || pathText.text == "" {
            pathText.text = TaskModel.shared.sessionInformation?["download-dir"].string ?? ""
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func submitClick(_ sender: Any) {
        TaskModel.shared.torrentAdd(torrent: fileNameText.text ?? "", path: pathText.text ?? "")
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return rowList.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowList[section]
    }


}
