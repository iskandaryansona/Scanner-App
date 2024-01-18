//
//  Alert.swift
//  Scanner
//
//  Created by Sona on 18.01.24.
//

import Foundation
import UIKit

struct Alert {
    
    static func topMostVC() -> UIViewController? {
        return UIApplication.shared.windows.first?.rootViewController?.presentedViewController
    }
    
    static func show(title: String? = "Whoops!", message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction.init(title: "OK", style: .default) { (_) in}
        alertController.addAction(alertAction)
        if let vc = topMostVC() {
            vc.present(alertController, animated: true, completion: nil)
        }
    }
}
