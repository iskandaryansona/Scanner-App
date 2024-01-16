//
//  FilterCell.swift
//  Scanner
//
//  Created by Petros Gabrielyan on 16.01.24.
//

import UIKit

class FilterCell: UICollectionViewCell {
    
    static let id = "FilterCell"
    static let nibname = "FilterCell"

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
