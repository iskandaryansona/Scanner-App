//
//  EditViewController.swift
//  Scanner
//
//  Created by Sona on 15.01.24.
//

import UIKit
import Kingfisher
import CropViewController
import CoreData
import Vision

class EditViewController: UIViewController {
    
    @IBOutlet weak var editImg: UIImageView!
    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var movableView: UIView!
    @IBOutlet weak var movableImageView: UIImageView!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    @IBOutlet weak var mainBottomBar: UIView!
    @IBOutlet weak var confirmationBottomBar: UIView!
    @IBOutlet weak var convertView: UIView!
    @IBOutlet weak var subConvertView: UIView!
    @IBOutlet weak var convertCancelButton: UIButton!
    @IBOutlet weak var filesButton: UIButton!
    @IBOutlet weak var zipButton: UIButton!
    @IBOutlet weak var docTypeStack: UIStackView!
    @IBOutlet weak var zipTypeButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    var move = true
    var isFromHistory = false
    
    var currentItem = SavedFiles()
    
    let borderWidth: CGFloat = 1
    let resizersWidth: CGFloat = 6
    let rotatersWidth: CGFloat = 16
    
    var typeActiveColor = UIColor(red: 29/255, green: 163/255, blue: 238/255, alpha: 1)
    var typeInactiveColor = UIColor(red: 37/255, green: 39/255, blue: 45/255, alpha: 1)
    
    var deltaX: CGFloat = 0
    var deltaY: CGFloat = 0
    var diff: CGFloat = .pi
    var prevLocation = CGPoint(x: 0, y: 0)
    var identity = CGAffineTransform.identity
    var identityForDoc = CGAffineTransform.identity
    
    var currentWidth: CGFloat = 0
    var currentHeight: CGFloat = 0
    var collectionIsShown = false
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var data = ["Original", "Vivid", "Vivid Warm", "Vivid Cool", "Dramatic", "Dramatic Warm", "Dramatic Cool", "Mono", "Silvertone", "Noir"]
    var filterNames = ["none", "CIColorControls", "CIPhotoEffectChrome", "CIPhotoEffectFade", "CIPhotoEffectInstant", "CIPhotoEffectProcess", "CIPhotoEffectTonal", "CIPhotoEffectTransfer", "CISepiaTone", "CIPhotoEffectNoir"]
    var name = "Untitled"
    
    var img: UIImage?

    var imgLink: String?

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
        
        subConvertView.layer.borderWidth = 1
        subConvertView.layer.borderColor = UIColor(red: 123/255, green: 155/255, blue: 190/255, alpha: 1).cgColor
        subConvertView.layer.cornerRadius = 14
        
        convertButton.layer.borderWidth = 1
        convertButton.layer.borderColor = UIColor(red: 123/255, green: 155/255, blue: 190/255, alpha: 1).cgColor
        convertButton.layer.cornerRadius = 13
        
        filesButton.layer.borderWidth = 1
        filesButton.layer.borderColor = UIColor(red: 123/255, green: 155/255, blue: 190/255, alpha: 1).cgColor
        filesButton.layer.cornerRadius = 14
        
        zipButton.layer.borderWidth = 1
        zipButton.layer.borderColor = UIColor(red: 123/255, green: 155/255, blue: 190/255, alpha: 1).cgColor
        zipButton.layer.cornerRadius = 14
        
        convertCancelButton.layer.borderWidth = 1
        convertCancelButton.layer.borderColor = UIColor(red: 123/255, green: 155/255, blue: 190/255, alpha: 1).cgColor
        convertCancelButton.layer.cornerRadius = 16
        
        convertView.frame.origin.y = self.view.frame.height
        
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
        showShareSheet(sender: sender, file: img)
    }
    
    func showShareSheet(sender: Any, file: Any) {
        let shareBtn = sender as! UIButton
        let shareSheet = UIActivityViewController(activityItems: [file], applicationActivities: nil)
        convertButton.setTitleColor(.white, for: .disabled)
        shareSheet.popoverPresentationController?.sourceView = self.view
        shareSheet.popoverPresentationController?.sourceRect = shareBtn.frame
        shareSheet.completionWithItemsHandler = { activity, success, items, error in
            if success {
                self.createFile(name: self.name, thumb: self.img!)
                self.hideConvertView()
            }
        }
        present(shareSheet, animated: true)
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        if isFromHistory {
            updateFile(item: currentItem, thumb: img!)
        } else {
            createFile(name: name, thumb: img!)
        }
        if let imgLink = imgLink {
            editImg?.kf.setImage(with: URL(string: imgLink))
        }
    }

    @IBAction func convertButtonAction(_ sender: Any) {
        self.convertButton.isHidden = true
        showConvertView()
    }
    
    @IBAction func filesButtonAction(_ sender: Any) {
        filesButton.backgroundColor = typeActiveColor
        zipButton.backgroundColor = typeInactiveColor
        zipTypeButton.isHidden = true
        docTypeStack.isHidden = false
    }
    
    @IBAction func zipButtonAction(_ sender: Any) {
        filesButton.backgroundColor = typeInactiveColor
        zipButton.backgroundColor = typeActiveColor
        zipTypeButton.isHidden = false
        docTypeStack.isHidden = true
    }
    
    @IBAction func jpgButtonAction(_ sender: Any) {
        let data = convertPNGtoJPEG(pngImage: img!)
        showShareSheet(sender: sender, file: data)
    }
    
    @IBAction func pdfButtonAction(_ sender: Any) {
        let data = createPDF(from: img!)
        showShareSheet(sender: sender, file: data)
    }
    
    @IBAction func txtButtonAction(_ sender: Any) {
        guard let cgImage = editImg.image?.cgImage else { return }
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation], error == nil else {
                self.showAlert()
                return
            }
            
            let text = observations.compactMap({
            $0.topCandidates(1).first?.string
            }).joined(separator: ", ")
            if text == "" {
                self.showAlert()
            } else {
                self.showShareSheet(sender: sender, file: text)
            }
        }
        request.recognitionLevel = VNRequestTextRecognitionLevel.accurate
        
        do {
            try handler.perform([request])
        } catch {
            //handle error
            print(error)
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Fail", message: "Cannot find text", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func convertToZipButtonAction(_ sender: Any) {
        var a = img!.jpegData(compressionQuality: 0.1)
        showShareSheet(sender: sender, file: a)
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
    
    @IBAction func convertCancelAction(_ sender: Any) {
        hideConvertView()
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
        convertButton.isHidden = true
        saveButton.isEnabled = false
        shareButton.isEnabled = false
        
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
        convertButton.isHidden = false
        saveButton.isEnabled = true
        shareButton.isEnabled = true
        
        UIView.animate(withDuration: 0.3) {
            self.mainBottomBar.frame.origin.y = self.view.frame.height - 130
            self.confirmationBottomBar.frame.origin.y
             = self.view.frame.height
        }
    }
    
    func showConvertView() {
        self.confirmationBottomBar.isHidden = true
        UIView.animate(withDuration: 0.3) {
            self.mainBottomBar.frame.origin.y = self.view.frame.height
            
            if self.filterCollectionView.frame.origin.y != self.view.frame.height {
                self.filterCollectionView.frame.origin.y = self.view.frame.height
            }
            
            self.convertView.frame.origin.y
             = self.view.frame.height - 340
        }
    }
    
    func hideConvertView() {
        UIView.animate(withDuration: 0.3) {
            self.mainBottomBar.frame.origin.y = self.view.frame.height - 130
            self.convertView.frame.origin.y
             = self.view.frame.height
        } completion: { _ in
            self.confirmationBottomBar.isHidden = false
        }
        self.convertButton.isHidden = false
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
    
    func createPDF(from image: UIImage) -> Data {
        let pdfPageSize = image.size
        var pdfData = NSMutableData()
            
        UIGraphicsBeginPDFContextToData(pdfData, CGRect(origin: .zero, size: pdfPageSize), nil)
        UIGraphicsBeginPDFPage()
            
        let imageRect = CGRect(origin: .zero, size: pdfPageSize)
        image.draw(in: imageRect)
            
        UIGraphicsEndPDFContext()
        
        return pdfData as Data
    }
    
    func convertPNGtoJPEG(pngImage: UIImage) -> Data? {
        guard let pngData = pngImage.pngData() else {
            return nil
        }
        
        guard let image = UIImage(data: pngData) else {
            return nil
        }
        
        // Set the compression quality (0.0 to 1.0)
        let compressionQuality: CGFloat = 0.8
        
        guard let jpegData = image.jpegData(compressionQuality: compressionQuality) else {
            return nil
        }
        
        return jpegData
    }
    
    //MARK: - Work with Entity
    func createFile(name: String, thumb: UIImage) {
        let newFile = SavedFiles(context: context)
        newFile.name = name
        newFile.thumb = thumb.pngData() ?? UIImage().pngData()
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let formattedDate = dateFormatter.string(from: currentDate)
        newFile.date = formattedDate
        
        do {
            try context.save()
//                getAllFolders()
        }
        catch {
            
        }
        
        self.navigationController?.popViewController(animated: true)
    }
        
    func updateFile(item: SavedFiles, thumb: UIImage) {
        item.thumb = thumb.pngData()
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let formattedDate = dateFormatter.string(from: currentDate)
        item.date = formattedDate
    
        do {
            try context.save()
//                getAllFolders()
        }
        catch {
            
        }
        
        self.navigationController?.popViewController(animated: true)
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
        let cell = collectionView.cellForItem(at: indexPath) as! FilterCell
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
