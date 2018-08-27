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
    
    // MARK: - View Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateInformation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func updateInformation(){
        if let _torrentInformation = torrentInformation {
            //torrentNameLabel.text = _torrentInformation["name"].string
        }
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100.0;
        
        tableView.reloadData()
    }
    
    @IBAction func changeStateButtonClick(_ sender: UIButton, forEvent event: UIEvent) {
    
    }
    
    @IBAction func removeButtonClick(_ sender: UIButton) {
        
    }
    
    @IBAction func removeAndDeleteButtonClick(_ sender: UIButton) {
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 6
        case 1:
            return 5
        case 2:
            return 3
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LargeLabelCell", for: indexPath) as! LargeTableViewCell
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
