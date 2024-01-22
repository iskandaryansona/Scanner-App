//
//  ScanVC.swift
//  Scanner
//
//  Created by Sona on 25.12.23.
//

import UIKit
import GoogleSignIn
import GoogleAPIClientForREST
import GTMSessionFetcher

class ScanVC: UIViewController {
    
    @IBOutlet weak var menuCollection: UICollectionView!
    
    
    var imgArr:[String] = ["menu.camera","menu.gallery","menu.drive"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func fetchFiles(_ user: GIDGoogleUser) {
        guard let vc = self.storyboard?.instantiateViewController(identifier: "CloudFilesVC") as? CloudFilesVC else {
            return
        }
        vc.service.authorizer = user.fetcherAuthorizer
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showPaywall() {
        let vc = PaywallViewController(from: .main)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
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
        if isSubscribed {
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
                if let user = GIDSignIn.sharedInstance.currentUser {
                    fetchFiles(user)
                }else{
                    GIDSignIn.sharedInstance.signIn(withPresenting: self){user, error in
                        if let error = error {
                            Alert.show(message: error.localizedDescription)
                        }else{
                            if let user = user {
                                self.fetchFiles(user.user)
                            }
                        }
                    }
                }
            }
        } else {
            showPaywall()
        }
        return
    }
}

extension ScanVC: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let url = info[UIImagePickerController.InfoKey.imageURL] as! NSURL
        let name = url.lastPathComponent!

        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let img = image.fixedOrientation()
            let vc = EditViewController()
            vc.img = img
            vc.name = name
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
