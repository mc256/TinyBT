//
//  SettingsViewController.swift
//  serika
//
//  Created by maverick on 2018/8/24.
//  Copyright © 2018 maverick. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var rpcServerText: UITextField!
    @IBOutlet weak var loginCookieText: UITextField!
    
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rpcServerText.text = delegate.configuration?.rpcServer
        loginCookieText.text = delegate.configuration?.cookieString
        userNameText.text = delegate.configuration?.username
        passwordText.text = delegate.configuration?.password
        
    }
    @IBAction func cancelButtonClick(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func saveButtonClick(_ sender: UIBarButtonItem) {
        delegate.configuration?.rpcServer = rpcServerText.text
        delegate.configuration?.cookieString = loginCookieText.text
        delegate.configuration?.username = userNameText.text
        delegate.configuration?.password = passwordText.text
        
        delegate.configuration?.save()
        TaskModel.shared.sessionStart()
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }


}
