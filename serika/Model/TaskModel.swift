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
    var detailTimer: Timer? = nil
    var detailInformation: JSON? = nil


    var mainViewController: UITableViewController? = nil
    var detailViewController: DetailViewController? = nil
    
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
        self.mainViewController = viewController
        taskTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { _ in
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
                        if mainViewController?.tableView.isEditing ?? true == true {
                            return
                        }
                        taskInformation = buffer
                        mainViewController?.tableView.reloadData()
                    }
                }
            }
        case .failure:
            sessionId = response.response?.allHeaderFields["X-Transmission-Session-Id"] as? String ?? sessionId
        }
    }
    
    // MARK: - Detail Information
    
    func detailStart(viewController: DetailViewController, id: Int){
        self.detailViewController = viewController
        detailTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            TaskModel.shared.detailRequest(id: id)
        }
    }
    
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
                    id
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
                    let buffer = _data["arguments"]["torrents"][0]
                    DispatchQueue.main.sync {
                        detailViewController?.torrentInformation = buffer
                        detailViewController?.updateInformation()
                    }
                }
            }
        case .failure:
            sessionId = response.response?.allHeaderFields["X-Transmission-Session-Id"] as? String ?? sessionId
        }
    }
    
    func detailInactivative(){
        detailViewController = nil
        detailTimer?.invalidate()
    }
    
    // MARK: - Action
    
    func torrentPause(id: Int){
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
            "method": "torrent-stop",
            "arguments": [
                "ids": [
                    id
                ]
            ]
        ]
        
        // Fetch Request
        if let _username = delegate.configuration?.username {
            Alamofire.request(_rpcServer, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
                .authenticate(user: _username, password: delegate.configuration?.password ?? "")
                .validate(statusCode: 200...200)
        }else{
            Alamofire.request(_rpcServer, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200...200)
        }
    }
    
    func torrentResume(id: Int){
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
            "method": "torrent-start",
            "arguments": [
                "ids": [
                    id
                ]
            ]
        ]
        
        // Fetch Request
        if let _username = delegate.configuration?.username {
            Alamofire.request(_rpcServer, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
                .authenticate(user: _username, password: delegate.configuration?.password ?? "")
                .validate(statusCode: 200...200)
        }else{
            Alamofire.request(_rpcServer, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200...200)
        }
    }
    
    func torrentRemove(id: Int, removeFile: Bool = false){
        
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
            "method": "torrent-remove",
            "arguments": [
                "ids": [
                    id
                ],
                "delete-local-data": removeFile
            ]
        ]
        
        // Fetch Request
        if let _username = delegate.configuration?.username {
            Alamofire.request(_rpcServer, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
                .authenticate(user: _username, password: delegate.configuration?.password ?? "")
                .validate(statusCode: 200...200)
        }else{
            Alamofire.request(_rpcServer, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200...200)
        }
    }
    
    func torrentAdd(torrent: String, path:String){
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
            "method": "torrent-add",
            "arguments": [
                "download-dir": path,
                "filename": torrent,
                "paused": "false"
            ]
        ]
        
        // Fetch Request
        if let _username = delegate.configuration?.username {
            Alamofire.request(_rpcServer, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
                .authenticate(user: _username, password: delegate.configuration?.password ?? "")
                .validate(statusCode: 200...200)
        }else{
            Alamofire.request(_rpcServer, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200...200)
        }
        
    }
    
    // MARK: - Utility
    
    static func humanReadableSize(bytes: Int) -> String {
        var holder = 0.0
        if bytes == 0 {
            return "0"
        }
        if (Double(bytes) / 1024.0 < 1) {
            return String(bytes) + "B"
        }
        holder = Double(bytes) / 1024.0
        if ( (holder / 1024.0)  < 1){
            return String(format: "%.01fKB", holder)
        }
        holder = holder / 1024.0
        if ( (holder / 1024.0)  < 1){
            return String(format: "%.01fMB", holder)
        }
        holder = holder / 1024.0
        return String(format: "%.01fGB", holder)
    }
    
    static func humanReadableSpeed(bytesPerSecond: Int) -> String {
        if bytesPerSecond == 0 {
            return "0"
        }
        return humanReadableSize(bytes:bytesPerSecond) + "/s"
    }
    
    static func unixTimestampToLocalTime(time: Double) -> String {
        let date = Date(timeIntervalSince1970: time)
        
        let formatter = DateFormatter()
        formatter.formatterBehavior = .behavior10_4
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        
        return formatter.string(from: date)
    }
    
    static func percentageToString(percentage: Double) -> String {
        return String(format: "%0.2f%%", percentage * 100.0)
    }
    
    // MARK: - Singleton
    
    private override init() {
        super.init()
    }
    
}
