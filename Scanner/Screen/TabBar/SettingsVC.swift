//
//  SettingsVC.swift
//  Scanner
//
//  Created by Sona on 25.12.23.
//

import UIKit

class SettingsVC: UIViewController {
    
    var imgArr:[String] = ["settings.premium","settings.feedback","settings.rate","settings.share","settings.privacy"]
    let privacyURL = "https://sites.google.com/view/privacypolicy-luxescan?pli=1"

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
        switch indexPath.row {
        case 0:
            let vc = PaywallViewController(from: .main)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        case 4:
            let vc = WebViewController()
            self.present(vc, animated: true)
            vc.showUrl(link: privacyURL)
        default:
            return
        }
    }
}
