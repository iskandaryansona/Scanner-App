//
//  PayWallVC.swift
//  Scanner
//
//  Created by Sona on 23.12.23.
//

import UIKit

class PayWallVC: UIViewController {
    
    @IBOutlet weak var termofUseButton: UIButton!
    @IBOutlet weak var privacePolicyButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
    }
    
    private func configUI(){
        let colorTop =  UIColor(red: 13.0/255.0, green: 76.0/255.0, blue: 146.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 63.0/255.0, green: 153.0/255.0, blue: 174.0/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradientLayer, at:0)
        
        termofUseButton.underLine(text: "Term of use")
        privacePolicyButton.underLine(text: "Privacy policy")
    }
    
    @IBAction func closeAction(_ sender: UIButton){
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AppTabBarController") as! AppTabBarController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func restore(_ sender: UIButton){
        
    }
    
    @IBAction func subScribe(_ sender: UIButton){
        
    }
    
    @IBAction func termOfUse(_ sender: UIButton){
        
    }

    @IBAction func privacyPolicy(_ sender: UIButton){
        
    }
}
