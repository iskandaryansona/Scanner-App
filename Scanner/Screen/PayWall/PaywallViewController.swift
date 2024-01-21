//
//  PaywallViewController.swift
//  Scanner
//
//  Created by Petros Gabrielyan on 09.01.24.
//

import UIKit
import StoreKit

enum PaywallFrom {
    case onboarding
    case main
}

class PaywallViewController: UIViewController {

    @IBOutlet weak var termsOfUseButton: UIButton!
    @IBOutlet weak var privacePolicyButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var moreInfoLabel: UILabel!
    
    let termsURL = "https://sites.google.com/view/luxescan-terms-of-use"
    let privacyURL = "https://sites.google.com/view/privacypolicy-luxescan?pli=1"
    
    let from: PaywallFrom?

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        IAPService.shared.getProducts()
    }
    
    init(from: PaywallFrom) {
        self.from = from
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI(){
        let colorTop =  UIColor(red: 13.0/255.0, green: 76.0/255.0, blue: 146.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 63.0/255.0, green: 153.0/255.0, blue: 174.0/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradientLayer, at:0)
        
        termsOfUseButton.underLine(text: "Term of use")
        privacePolicyButton.underLine(text: "Privacy policy")
        priceLabel.underLine(text: "after $9.99 / week (auto-renewal)")
//        priceLabel.font = UIFont(name: "KaiseiOpti-Regular", size: 13)
        moreInfoLabel.underLine(text: "1240 people have used the 7-day Trial in the past 24 hours")
//        moreInfoLabel.font = UIFont(name: "KaiseiOpti-Regular", size: 12)
    }
    
    @IBAction func closeAction(_ sender: UIButton){
        if from == .onboarding {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AppTabBarController") as! AppTabBarController
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func restore(_ sender: UIButton){
        IAPService.shared.restorPurchases()
    }
    
    @IBAction func subScribe(_ sender: UIButton){
        IAPService.shared.purChase()
    }
    
    @IBAction func termOfUse(_ sender: UIButton){
        let vc = WebViewController()
        self.present(vc, animated: true)
        vc.showUrl(link: termsURL)
    }

    @IBAction func privacyPolicy(_ sender: UIButton){
        let vc = WebViewController()
        self.present(vc, animated: true)
        vc.showUrl(link: privacyURL)
    }

}
