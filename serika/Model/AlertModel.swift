//
//  AlertModel.swift
//  serika
//
//  Created by maverick on 2018/8/28.
//  Copyright © 2018 maverick. All rights reserved.
//

import UIKit

class AlertModel: NSObject {
    
    static func showAlertMessage(title:String, message:String, cancel:String, complete:((UIAlertAction)->Void)?){
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            // topController should now be your topmost view controller
            let alert = UIAlertController(title: NSLocalizedString(title, comment: title), message: NSLocalizedString(message, comment: message), preferredStyle: .alert)
            let cancelButton = UIAlertAction(title: NSLocalizedString(cancel, comment: cancel), style: .default, handler: complete)
            alert.addAction(cancelButton)
            
            topController.present(alert, animated: true, completion: nil)
        }
        
    }
    
    static func showAlertChoice(title:String, message:String, yes:String, no:String, complete:@escaping ((Bool)->Void)){
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            let alert = UIAlertController(title: NSLocalizedString(title, comment: title), message: NSLocalizedString(message, comment: message), preferredStyle: .alert)
            let yesButton = UIAlertAction(title: NSLocalizedString(yes, comment: yes), style: .default, handler: { action in
                complete(true)
            })
            let noButton = UIAlertAction(title: NSLocalizedString(no, comment: no), style: .default, handler: { action in
                complete(false)
            })
            alert.addAction(noButton)
            alert.addAction(yesButton)
            
            topController.present(alert, animated: true, completion: nil)
        }
        
    }

}
