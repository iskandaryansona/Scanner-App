//
//  OnBoardingVC.swift
//  Scanner
//
//  Created by Sona on 22.12.23.
//

import Foundation
import UIKit
import ImageSlideshow

class OnBoardingVC: UIViewController {
    
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var slideShow: ImageSlideshow!
            
    let slides = [ImageSource(image: UIImage(named: "onboarding1")!),ImageSource(image: UIImage(named: "onboarding2")!),ImageSource(image: UIImage(named: "onboarding3")!)]

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    private func configUI(){
        slideShow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        slideShow.contentScaleMode = UIViewContentMode.scaleAspectFit
        slideShow.activityIndicator = DefaultActivityIndicator()
        slideShow.delegate = self
        slideShow.setImageInputs(slides)
        slideShow.circular = false
    }
    
    
    @IBAction func nextPage(_ sender: UIButton){
        slideShow.setCurrentPage(slideShow.currentPage + 1, animated: true)
        if slideShow.currentPage == 3 {
            closeOnBoarding()
        }
    }
    
    @IBAction func skipPage(_ sender: UIButton){
        closeOnBoarding()
    }
    
    private func closeOnBoarding(){
        UserDefaults.standard.set(true, forKey: "showOnboarding")
        let vc = PaywallViewController(from: .onboarding)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension OnBoardingVC: ImageSlideshowDelegate {
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {}
}
