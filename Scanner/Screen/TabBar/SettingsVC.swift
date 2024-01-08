//
//  SettingsVC.swift
//  Scanner
//
//  Created by Sona on 25.12.23.
//

import UIKit

class SettingsVC: UIViewController {
    
    var imgArr:[String] = ["settings.premium","settings.feedback","settings.rate","settings.share","settings.privacy"]

    @IBOutlet weak var settingsCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SettingsVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath as IndexPath) as! MenuCell
        cell.configUI(imgName: imgArr[indexPath.row])
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = PayWallVC()
            self.present(vc, animated: true)
        }
    }
}
