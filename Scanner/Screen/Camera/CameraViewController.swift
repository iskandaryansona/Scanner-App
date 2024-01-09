//
//  CameraViewController.swift
//  Scanner
//
//  Created by Petros Gabrielyan on 09.01.24.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {

    @IBOutlet weak var previewView: UIView!
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let captureDevice = AVCaptureDevice.default(for: .video)

        var input: AVCaptureDeviceInput?
        
        self.view.backgroundColor = .red
        self.previewView.backgroundColor = .yellow
//        do {
//            input = try AVCaptureDeviceInput(device: captureDevice!)
//        } catch {
//            print(error)
//        }
//        
//        captureSession = AVCaptureSession()
//        captureSession?.addInput(input!)
//        
//        
//        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
//        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
//        videoPreviewLayer?.frame = view.layer.bounds
//        previewView.layer.addSublayer(videoPreviewLayer!)
//        
//        captureSession?.startRunning()
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
