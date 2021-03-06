//
//  ConfigurationModel.swift
//  serika
//
//  Created by maverick on 2018/8/24.
//  Copyright © 2018 maverick. All rights reserved.
//

import UIKit

class ConfigurationModel: NSObject, NSCoding {
    
    var delegate:AppDelegate? = nil
    var rpcServer:String? = nil
    var cookieString:String? = nil
    var username:String? = nil
    var password:String? = nil
    
    func encode(with aCoder: NSCoder) {
        if let _rpcServer = rpcServer {
            aCoder.encode(_rpcServer, forKey: "rpcServer")
        }
        if let _cookieString = cookieString {
            aCoder.encode(_cookieString, forKey: "cookieString")
        }
        if let _username = username {
            aCoder.encode(_username, forKey:"username")
        }
        if let _password = password {
            aCoder.encode(_password, forKey: "password")
        }
    }
    
    override init() {
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        self.rpcServer = aDecoder.decodeObject(forKey: "rpcServer") as? String
        self.cookieString = aDecoder.decodeObject(forKey: "cookieString") as? String
        self.username = aDecoder.decodeObject(forKey: "username") as? String
        self.password = aDecoder.decodeObject(forKey: "password") as? String
    }
    
    static func create(_ delegate:AppDelegate) ->  ConfigurationModel{
        let configuration = NSKeyedUnarchiver.unarchiveObject(withFile: delegate.appRoot + "/configuration.obj") as? ConfigurationModel ?? ConfigurationModel()
        configuration.delegate = delegate
        configuration.save()
        return configuration
    }
    
    func save() {
        NSKeyedArchiver.archiveRootObject(self, toFile: delegate!.appRoot + "/configuration.obj")
    }
}
