//
//  ScanVC.swift
//  Scanner
//
//  Created by Sona on 25.12.23.
//

import UIKit

class ScanVC: UIViewController {
    
    @IBOutlet weak var menuCollection: UICollectionView!
    
    var imgArr:[String] = ["menu.camera","menu.gallery","menu.drive","menu.url","menu.convert"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

extension ScanVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath as IndexPath) as! MenuCell
        cell.configUI(imgName: imgArr[indexPath.row])
        return cell
    }
    
    
}
