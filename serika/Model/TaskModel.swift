//
//  TaskModel.swift
//  serika
//
//  Created by maverick on 2018/8/25.
//  Copyright © 2018 maverick. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TaskModel: NSObject {

    static let shared: TaskModel = TaskModel()
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    var sessionId: String? = nil
    var sessionTimer: Timer? = nil
    var sessionInformation: JSON? = nil
    var taskTimer: Timer? = nil
    var taskInformation: [JSON]? = nil

    var viewController: UITableViewController? = nil
    
    var operationQueue = DispatchQueue(label: "me.masterchan.serika.tasks")
    
    // MARK: - Session
    func sessionStart(){
        sessionTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            if self?.sessionInformation != nil {
                self?.sessionTimer?.invalidate()
                return
            }
            TaskModel.shared.sessionRequest()
        }
    }
    
    func sessionRequest(){
        guard let _rpcServer = delegate.configuration?.rpcServer else {
            return
        }
        
        // Add Headers
        let headers = [
            "Content-Type":"application/json; charset=utf-8",
            "X-Transmission-Session-Id":sessionId ?? "",
            "Cookie":delegate.configuration?.cookieString ?? "",
            ]
        
        // JSON Body
        let body: [String : Any] = [
            "method": "session-get"
        ]
        
        // Fetch Request
        if let _username = delegate.configuration?.username {
            Alamofire.request(_rpcServer, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
                .authenticate(user: _username, password: delegate.configuration?.password ?? "")
                .validate(statusCode: 200...200)
                .responseJSON(queue: operationQueue, completionHandler: self.sessionComplete)
        }else{
            Alamofire.request(_rpcServer, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200...200)
                .responseJSON(queue: operationQueue, completionHandler: self.sessionComplete)
        }
        
    }
    
    func sessionComplete(response:DataResponse<Any>){
        switch response.result {
        case .success:
            let data = try? JSON(data: response.data ?? Data())
            if let _data = data {
                if _data["result"] == "success" {
                    sessionInformation = _data["arguments"]
                }
            }
        case .failure:
            sessionId = response.response?.allHeaderFields["X-Transmission-Session-Id"] as? String ?? sessionId
        }
    }
    
    // MARK: - Task List
    
    func taskStart(viewController: UITableViewController){
        self.viewController = viewController
        taskTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
            TaskModel.shared.taskRequest()
        }
    }
    
    func taskRequest(){
        guard let _rpcServer = delegate.configuration?.rpcServer else {
            return
        }
        
        // Add Headers
        let headers = [
            "Content-Type":"application/json; charset=utf-8",
            "X-Transmission-Session-Id":sessionId ?? "",
            "Cookie":delegate.configuration?.cookieString ?? "",
            ]
        
        // JSON Body
        let body: [String : Any] = [
            "method": "torrent-get",
            "arguments": [
                "fields": [
                    "id",
                    "name",
                    "error",
                    "errorString",
                    "isFinished",
                    "percentDone",
                    "rateDownload",
                    "rateUpload",
                    "status"
                ]
            ]
        ]
        
        // Fetch Request
        if let _username = delegate.configuration?.username {
            Alamofire.request(_rpcServer, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
                .authenticate(user: _username, password: delegate.configuration?.password ?? "")
                .validate(statusCode: 200...200)
                .responseJSON(queue: operationQueue, completionHandler: self.taskComplete)
        }else{
            Alamofire.request(_rpcServer, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200...200)
                .responseJSON(queue: operationQueue, completionHandler: self.taskComplete)
        }
        
    }
    
    func taskComplete(response:DataResponse<Any>){
        switch response.result {
        case .success:
            let data = try? JSON(data: response.data ?? Data())
            if let _data = data {
                if _data["result"] == "success" {
                    var buffer = _data["arguments"]["torrents"].array!
                    buffer.sort(by: {$0["name"] < $1["name"]})
                    DispatchQueue.main.sync {
                        if viewController?.tableView.isEditing ?? true == true {
                            return
                        }
                        taskInformation = buffer
                        viewController?.tableView.reloadData()
                    }
                }
            }
        case .failure:
            sessionId = response.response?.allHeaderFields["X-Transmission-Session-Id"] as? String ?? sessionId
        }
    }
    
    // MARK: - Detail Informatino
    
    func detailRequest(id: Int){
        guard let _rpcServer = delegate.configuration?.rpcServer else {
            return
        }
        
        // Add Headers
        let headers = [
            "Content-Type":"application/json; charset=utf-8",
            "X-Transmission-Session-Id":sessionId ?? "",
            "Cookie":delegate.configuration?.cookieString ?? "",
            ]
        
        // JSON Body
        let body: [String : Any] = [
            "method": "torrent-get",
            "arguments": [
                "ids": [
                    61
                ],
                "fields": [
                    "id",
                    "addedDate",
                    "name",
                    "totalSize",
                    "error",
                    "errorString",
                    "eta",
                    "isFinished",
                    "isStalled",
                    "leftUntilDone",
                    "metadataPercentComplete",
                    "peersConnected",
                    "peersGettingFromUs",
                    "peersSendingToUs",
                    "percentDone",
                    "queuePosition",
                    "rateDownload",
                    "rateUpload",
                    "recheckProgress",
                    "seedRatioMode",
                    "seedRatioLimit",
                    "sizeWhenDone",
                    "status",
                    "trackers",
                    "downloadDir",
                    "uploadedEver",
                    "uploadRatio",
                    "webseedsSendingToUs"
                ]
            ]
        ]
        
        // Fetch Request
        if let _username = delegate.configuration?.username {
            Alamofire.request(_rpcServer, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
                .authenticate(user: _username, password: delegate.configuration?.password ?? "")
                .validate(statusCode: 200...200)
                .responseJSON(queue: operationQueue, completionHandler: self.detailComplete)
        }else{
            Alamofire.request(_rpcServer, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200...200)
                .responseJSON(queue: operationQueue, completionHandler: self.detailComplete)
        }
    

    }
    
    func detailComplete(response:DataResponse<Any>){
        switch response.result {
        case .success:
            let data = try? JSON(data: response.data ?? Data())
            if let _data = data {
                if _data["result"] == "success" {
                    var buffer = _data["arguments"]["torrents"].array!
                    buffer.sort(by: {$0["name"] < $1["name"]})
                    DispatchQueue.main.sync {
                        if viewController?.tableView.isEditing ?? true == true {
                            return
                        }
                        taskInformation = buffer
                        viewController?.tableView.reloadData()
                    }
                }
            }
        case .failure:
            sessionId = response.response?.allHeaderFields["X-Transmission-Session-Id"] as? String ?? sessionId
        }
    }
    
    // MARK: - Singleton
    
    private override init() {
        super.init()
    }
    
}
