//
//  ScanVC.swift
//  Scanner
//
//  Created by Sona on 25.12.23.
//

import UIKit

class ScanVC: UIViewController {
    
    @IBOutlet weak var menuCollection: UICollectionView!
    
    var imgArr:[String] = ["menu.camera","menu.gallery","menu.drive"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

extension ScanVC: UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath as IndexPath) as! MenuCell
        cell.configUI(imgName: imgArr[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            let vc = CameraViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = UIImagePickerController()
            vc.sourceType = .photoLibrary
            vc.delegate = self
            vc.allowsEditing = false
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        default:
            return
        }
    }
}

extension ScanVC: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let url = info[UIImagePickerController.InfoKey.imageURL] as! NSURL
        let name = url.lastPathComponent!

        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let img = image.fixedOrientation()
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
