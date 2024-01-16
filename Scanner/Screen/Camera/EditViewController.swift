//
//  EditViewController.swift
//  Scanner
//
//  Created by Sona on 15.01.24.
//

import UIKit
import CropViewController

protocol ReadyImageDelegate: AnyObject {
    func save(_ image: UIImage)
}

class EditViewController: UIViewController {
    
    @IBOutlet weak var editImg: UIImageView!
    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    
    var collectionIsShown = false
    
    var data = [String]()
    
    var img: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        setupCollectionView()
        
        data = CIFilter.filterNames(inCategory: nil) // need 10 filters
    }
    
    private func configUI(){
        if let img = img{
            editImg.contentMode = .scaleAspectFit
            editImg.image = img
        }
        convertButton.layer.borderWidth = 1
        convertButton.layer.borderColor = UIColor(red: 123/255, green: 155/255, blue: 130/255, alpha: 1).cgColor
        convertButton.cornerRadius = 14
    }
    
    func setupCollectionView() {
        let nib = UINib(nibName: FilterCell.nibname, bundle: nil)
        filterCollectionView.register(nib, forCellWithReuseIdentifier: FilterCell.id)
        filterCollectionView.delegate = self
        filterCollectionView.dataSource = self
    }

    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func shareButtonAction(_ sender: Any) {
        let shareBtn = sender as! UIButton
        let shareSheet = UIActivityViewController(activityItems: [img], applicationActivities: nil)
        shareSheet.popoverPresentationController?.sourceView = self.view
        shareSheet.popoverPresentationController?.sourceRect = shareBtn.frame
        shareSheet.completionWithItemsHandler = { activity, success, items, error in
            // TODO save to history
        }
        present(shareSheet, animated: true)
    }
    
    
    @IBAction func saveButtonAction(_ sender: Any) {
        // TODO save to history
    }

    @IBAction func convertButtonAction(_ sender: Any) {
        
    }
    
    @IBAction func cropAction(_ sender: Any) {
        let vc = CropViewController(croppingStyle: .default, image: img!)
        vc.aspectRatioPreset = .presetOriginal
        vc.aspectRatioLockEnabled = false
        vc.toolbarPosition = .bottom
        vc.doneButtonTitle = "Save"
        vc.cancelButtonTitle = "Back"
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func signatureAction(_ sender: Any) {
        
    }
    
    @IBAction func filterAction(_ sender: Any) {
        if collectionIsShown {
            UIView.animate(withDuration: 0.2) {
                self.filterCollectionView.frame.origin.y = self.view.frame.height - self.filterCollectionView.frame.height
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.filterCollectionView.frame.origin.y = self.view.frame.height - 2 * self.filterCollectionView.frame.height
            }
        }
        self.collectionIsShown.toggle()
//        self.img = simpleBlurFilterExample(inputImage: img!)
//        self.editImg.image = self.img
    }
    
    func simpleBlurFilterExample(inputImage: UIImage) -> UIImage {
        // convert UIImage to CIImage
        let inputCIImage = CIImage(image: inputImage)!
        
        // Create Blur CIFilter, and set the input image
        let blurFilter = CIFilter(name: "CIColorControls")!
        blurFilter.setValue(inputCIImage, forKey: kCIInputImageKey)
        blurFilter.setValue(0, forKey: kCIInputSaturationKey)

        // Get the filtered output image and return it
        let outputImage = blurFilter.outputImage!
        return UIImage(ciImage: outputImage)
    }
}

extension EditViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCell.id, for: indexPath) as! FilterCell
        cell.imageView.backgroundColor = .red
        cell.nameLabel.text = data[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = simpleBlurFilterExample(inputImage: img!)
        editImg.image = image
    }
}

extension EditViewController: ReadyImageDelegate {
    func save(_ image: UIImage) {
        self.editImg.image = image
        self.img = image
    }
}

extension EditViewController: CropViewControllerDelegate {
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        save(image)
        navigationController?.popViewController(animated: true)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        navigationController?.popViewController(animated: true)
    }
}
