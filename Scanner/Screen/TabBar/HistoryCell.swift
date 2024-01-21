//
//  HistoryCell.swift
//  Scanner
//
//  Created by Petros Gabrielyan on 17.01.24.
//

import UIKit

protocol HistoryCellDelegate: AnyObject {
    func delete(item: SavedFiles)
    func showRename(for cell: HistoryCell)
    func didTapButton(cell: HistoryCell)
}

class HistoryCell: UICollectionViewCell {
    
    static let id = "HistoryCell"
    static let nibName = "HistoryCell"
    
    
    var item: SavedFiles!
    weak var delegate: HistoryCellDelegate?

    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var actionsMenu: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red: 123/255, green: 155/255, blue: 190/255, alpha: 1).cgColor
        self.layer.cornerRadius = 16
        
        actionsMenu.layer.borderWidth = 1
        actionsMenu.layer.borderColor = UIColor(red: 123/255, green: 155/255, blue: 190/255, alpha: 1).cgColor
        actionsMenu.layer.cornerRadius = 10
    }
    
    @IBAction func editButtonAction(_ sender: Any) {
        delegate?.didTapButton(cell: self)
    }
    
    @IBAction func renameButtonAction(_ sender: Any) {
        showRenameAlert()
        delegate?.didTapButton(cell: self)
    }
    
    @IBAction func deleteButtonAction(_ sender: Any) {
        delegate?.delete(item: item)
        delegate?.didTapButton(cell: self)
    }
    
    func showRenameAlert() {
        delegate?.showRename(for: self)
    }
}
