//
//  ScanVC.swift
//  Scanner
//
//  Created by Sona on 25.12.23.
//

import UIKit

class ScanVC: UIViewController {
    
    @IBOutlet weak var menuCollection: UICollectionView!
    
    var imgArr:[String] = ["menu.camera","menu.gallery","menu.drive","menu.convert"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

extension ScanVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath as IndexPath) as! MenuCell
        cell.configUI(imgName: imgArr[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            let vc = CameraViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
