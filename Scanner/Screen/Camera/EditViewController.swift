//
//  EditViewController.swift
//  Scanner
//
//  Created by Sona on 15.01.24.
//

import UIKit
import CropViewController

class EditViewController: UIViewController {
    
    @IBOutlet weak var editImg: UIImageView!
    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var movableView: UIView!
    @IBOutlet weak var movableImageView: UIImageView!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    @IBOutlet weak var mainBottomBar: UIView!
    @IBOutlet weak var confirmationBottomBar: UIView!
    
    var move = true
    
    let borderWidth: CGFloat = 1
    let resizersWidth: CGFloat = 6
    let rotatersWidth: CGFloat = 16

    var deltaX: CGFloat = 0
    var deltaY: CGFloat = 0
    var diff: CGFloat = .pi
    var prevLocation = CGPoint(x: 0, y: 0)
    var identity = CGAffineTransform.identity
    var identityForDoc = CGAffineTransform.identity
    
    var currentWidth: CGFloat = 0
    var currentHeight: CGFloat = 0
    var collectionIsShown = false
    
    var data = ["Original", "Vivid", "Vivid Warm", "Vivid Cool", "Dramatic", "Dramatic Warm", "Dramatic Cool", "Mono", "Silvertone", "Noir"]
    var filterNames = ["none", "CIColorControls", "CIPhotoEffectChrome", "CIPhotoEffectFade", "CIPhotoEffectInstant", "CIPhotoEffectProcess", "CIPhotoEffectTonal", "CIPhotoEffectTransfer", "CISepiaTone", "CIPhotoEffectNoir"]
    
    var img: UIImage?
    var originalImg = UIImage()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        setupCollectionView()

        movableImageView.layer.borderWidth = 1
        movableImageView.isHidden = true
        
        currentWidth = movableImageView.bounds.width
        currentHeight = movableImageView.bounds.height
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        panGesture.maximumNumberOfTouches = 1
        self.view.addGestureRecognizer(panGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotate(_:)))
        
        pinchGesture.delegate = self
        rotationGesture.delegate = self
        
        self.movableView.addGestureRecognizer(pinchGesture)
        self.movableView.addGestureRecognizer(rotationGesture)

    }
    
    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        let point = sender.location(in: self.view)
        if sender.state == .began {
            if !movableView.frame.contains(point) {
                move = false
                return
            } else {
                move = true
            }
        } else if move {
            var center = movableView.center
            let translation = sender.translation(in:self.view)
                    center = CGPoint(x:center.x + translation.x,
                                         y:center.y + translation.y)
            movableView.center = center
            sender.setTranslation(CGPoint.zero, in: sender.view)
        }
    }
    
    @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .began:
            identity = movableView.transform
            gesture.scale = 1
        case .changed:
            var t = identity.scaledBy(x: gesture.scale, y: gesture.scale)
            movableView.transform = t
            movableImageView.layer.borderWidth = borderWidth / sqrt(t.a*t.a+t.c*t.c) //gesture.scale
        case .cancelled,.ended:
            movableView.transform = identity.scaledBy(x: gesture.scale, y: gesture.scale)
            gesture.scale = 1
        default:
            break
        }
        
    }
    
    @objc func handleRotate(_ gesture: UIRotationGestureRecognizer) {
        if gesture.state == .began, gesture.state == .ended, gesture.state == .cancelled {
            gesture.rotation = 0
        }
        movableView.transform = movableView.transform.rotated(by: gesture.rotation)
    }
    
    private func configUI(){
        if let img = img {
            editImg.contentMode = .scaleAspectFit
            editImg.image = img
            originalImg = img
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
        
        self.filterCollectionView.frame.origin.y = self.view.frame.height
    }

    @IBAction func saveSignAction(_ sender: Any) {
        hideConfirmationBar()
        movableImageView.layer.borderWidth = 0
        movableView.removeFromSuperview()
        let t = movableView.transform
        movableView.transform = .identity
        let frame = self.view.convert(movableView.frame, to: editImg)
        movableView.frame = frame
        movableView.transform = t
        editImg.addSubview(movableView)
        for subview in movableView.subviews {
            subview.isHidden = true
        }
        movableImageView.isHidden = false
        let img = self.getImageFrom(view: self.editImg)
        for subview in editImg.subviews {
            subview.removeFromSuperview()
        }
        save(img ?? UIImage())
    }
    
    @IBAction func cancelSignAction(_ sender: Any) {
        hideConfirmationBar()
        let vc = DrawSignatureViewController()
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
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
        let vc = DrawSignatureViewController()
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
    
    @IBAction func filterAction(_ sender: Any) {
        if collectionIsShown {
            UIView.animate(withDuration: 0.3) {
                self.filterCollectionView.frame.origin.y = self.view.frame.height
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.filterCollectionView.frame.origin.y = self.view.frame.height - 2 * self.filterCollectionView.frame.height
            }
        }
        self.collectionIsShown.toggle()
    }
    
    func setFilter(name: String, inputImage: UIImage) -> UIImage {
        if name == "none" {
            return inputImage
        }
        let inputCIImage = CIImage(image: inputImage)!
        
        let filter = CIFilter(name: name)!
        filter.setDefaults()
        filter.setValue(inputCIImage, forKey: kCIInputImageKey)
        
        if name == "CIColorControls" {
            filter.setValue(1.5, forKey: kCIInputContrastKey)
            filter.setValue(1.2, forKey: kCIInputSaturationKey)
            filter.setValue(0.0, forKey: kCIInputBrightnessKey)
        }

        // Get the filtered output image and return it
        let outputImage = filter.outputImage ?? inputCIImage
        let resultImage = UIImage(ciImage: outputImage)
        return resultImage
    }
    
    func showConfirmationBar() {
        UIView.animate(withDuration: 0.3) {
            self.mainBottomBar.frame.origin.y = self.view.frame.height
            
            if self.filterCollectionView.frame.origin.y != self.view.frame.height {
                self.filterCollectionView.frame.origin.y = self.view.frame.height
            }
            
            self.confirmationBottomBar.frame.origin.y
             = self.view.frame.height - 130
        }
    }
    
    func hideConfirmationBar() {
        UIView.animate(withDuration: 0.3) {
            self.mainBottomBar.frame.origin.y = self.view.frame.height - 130
            self.confirmationBottomBar.frame.origin.y
             = self.view.frame.height
        }
    }
    
    func save(_ image: UIImage) {
        self.editImg.image = image
        self.img = image
        self.originalImg = image
        filterCollectionView.reloadData()
    }
    
    func getImageFrom(view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
}

extension EditViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCell.id, for: indexPath) as! FilterCell
        cell.imageView.image = setFilter(name: filterNames[indexPath.row], inputImage: originalImg)
        cell.nameLabel.text = data[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCell.id, for: indexPath) as! FilterCell
        let image = cell.imageView.image
        editImg.image = image
        img = image
//        let image = setFilter(name: filterNames[indexPath.row], inputImage: img!)
//        img = image
//        editImg.image = image
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

extension EditViewController: SignatureDelegate {
    func addSign(sign: UIImage) {
        movableImageView.image = sign
        movableImageView.isHidden = false
        showConfirmationBar()
    }
}

extension EditViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
