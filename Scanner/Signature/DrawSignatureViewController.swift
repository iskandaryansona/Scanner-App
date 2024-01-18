//
//  DrawSignatureViewController.swift
//  Scanner
//
//  Created by Petros Gabrielyan on 16.01.24.
//

import UIKit

protocol SignatureDelegate: AnyObject {
    func addSign(sign: UIImage)
}

class DrawSignatureViewController: UIViewController {

    @IBOutlet weak var drawingView: DrawingView!
    
    weak var delegate: SignatureDelegate!
    
    var lastPoint = CGPoint.zero
    var pathColor = UIColor.black
    var pathWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var swiped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        drawingView.reset()
    }
    
    @IBAction func clearButtonAction(_ sender: Any) {
        drawingView.reset()
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func submitButtonAction(_ sender: Any) {
        guard let image = drawingView.save() else { return }
        delegate?.addSign(sign: image)
        self.dismiss(animated: true)
        self.dismiss(animated: true)
    }
}
