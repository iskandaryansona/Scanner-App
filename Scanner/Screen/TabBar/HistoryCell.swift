//
//  HistoryCell.swift
//  Scanner
//
//  Created by Petros Gabrielyan on 17.01.24.
//

import UIKit

class HistoryCell: UICollectionViewCell {
    
    static let id = "HistoryCell"
    static let nibName = "HistoryCell"

    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red: 123/255, green: 155/255, blue: 190/255, alpha: 1).cgColor
        self.layer.cornerRadius = 16
    }
    
    @IBAction func editButtonAction(_ sender: Any) {
        
    }
}
