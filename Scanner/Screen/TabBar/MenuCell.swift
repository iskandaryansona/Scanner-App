//
//  MenuCell.swift
//  Scanner
//
//  Created by Sona on 06.01.24.
//

import UIKit

class MenuCell: UICollectionViewCell {
    
    @IBOutlet weak var iconImg: UIImageView!
    
    func configUI(imgName: String){
        iconImg.image = UIImage(named: imgName)
    }
    
}
