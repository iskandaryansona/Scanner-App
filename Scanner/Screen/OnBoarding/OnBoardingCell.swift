//
//  OnBoardingCell.swift
//  Scanner
//
//  Created by Sona on 22.12.23.
//

import UIKit

class OnBoardingCell: UICollectionViewCell {
    
    static let id = String(describing: OnBoardingCell.self)
    
    @IBOutlet weak var onboardingImg: UIImageView!
    
    func setUp(_ slide: OnBoardingSlide){
        onboardingImg.image = slide.img
    }
    
}
