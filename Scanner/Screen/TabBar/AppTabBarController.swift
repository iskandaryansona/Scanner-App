//
//  AppTabBarController.swift
//  Scanner
//
//  Created by Sona on 25.12.23.
//

import Foundation
import UIKit


class AppTabBarController: UITabBarController, UITabBarControllerDelegate{
    
    var titleText: [String] = ["Scan", "History", "Settings"]
        
    var itemWidth : CGFloat {
        return (self.view.bounds.width - 30) / 3
    }
    
    
    var scanVC_ : ScanVC!
    var scanVC: ScanVC! {
        set {
            if newValue != scanVC_ {
                scanVC_ = newValue
            }
        }
        
        get {
            if scanVC_ == nil {
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let NC = storyboard.instantiateViewController(withIdentifier: "ScanVC") as? ScanVC
                
                let scanTb = UITabBarItem.init(title: "Scan",
                                                    image: UIImage.init(named: "scan"),
                                                    tag: 0)

//                homeTb.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.montserratFont(ofSize: 14.0)], for: .normal)

                NC!.tabBarItem = scanTb
                
                scanVC_ = NC
            }
            return scanVC_
        }
    }
  
    var historyVC_ : HistoryVC!
    var historyVC : HistoryVC! {
        set {
            if newValue != historyVC_ {
                historyVC_ = newValue
            }
        }
        get {
            if historyVC_ == nil {
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let NC = storyboard.instantiateViewController(withIdentifier: "HistoryVC") as? HistoryVC
                let tb = UITabBarItem.init(title: "History",
                                                    image: UIImage.init(named: "history"),
                                                    tag: 2)
//                tb.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.montserratFont(ofSize: 14.0)], for: .normal)
                NC!.tabBarItem = tb
                historyVC_ = NC
            }
            return historyVC_
        }
    }
    
    
    var settingsVC_ : SettingsVC!
    var settingsVC : SettingsVC! {
        set {
            if newValue != settingsVC_ {
                settingsVC_ = newValue
            }
        }
        get {
            if settingsVC_ == nil {
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let NC = storyboard.instantiateViewController(withIdentifier: "SettingsVC") as? SettingsVC
                let tb = UITabBarItem.init(title: "Settings",
                                                    image: UIImage.init(named: "settings"),
                                                    tag: 2)
//                tb.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.montserratFont(ofSize: 14.0)], for: .normal)
                NC!.tabBarItem = tb
                settingsVC_ = NC
            }
            return settingsVC_
        }
    }
    
    var tabBarVSs : [UIViewController] {
        get {
            
            return [scanVC,
                    historyVC,
                    settingsVC
            ]
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.bounds = self.tabBar.bounds.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        self.tabBar.frame.size.width = 100
        
        let elipse = UIView(frame: CGRect(x: 25, y: -8, width: self.view.bounds.width - 50, height: view.bounds.height / 12.5))
        elipse.backgroundColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1)
        elipse.layer.cornerRadius = 16
        
        self.tabBar.addSubview(elipse)
        
        self.tabBar.bounds = self.tabBar.bounds.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: -10, right: 0))
        
        //           self.view.addSubview(backgroundView)
        
        delegate = self
        
        tabBar.barTintColor = UIColor.white
        tabBar.barStyle = .default
        
        self.viewControllers = self.tabBarVSs
        selectedViewController = scanVC
        self.tabBarController?.delegate = self
        
        tabBar.tintColor = UIColor(red: 13/255, green: 76/255, blue: 146/255, alpha: 1)
        
        tabBar.itemPositioning = .centered
        tabBar.itemWidth = (UIScreen.main.bounds.width - 40) / 3
        tabBar.itemSpacing = 1
    }
}
