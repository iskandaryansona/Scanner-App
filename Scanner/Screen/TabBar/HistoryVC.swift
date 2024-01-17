//
//  HistoryVC.swift
//  Scanner
//
//  Created by Sona on 25.12.23.
//

import UIKit

class HistoryVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: HistoryCell.nibName, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: HistoryCell.id)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        searchView.layer.borderWidth = 1
        searchView.layer.borderColor = UIColor(red: 123/255, green: 155/255, blue: 190/255, alpha: 1).cgColor
        searchView.layer.cornerRadius = 14
    }
    
}

extension HistoryVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HistoryCell.id, for: indexPath)
        return cell
    }
    
    
}
