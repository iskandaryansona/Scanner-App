//
//  CameraViewController.swift
//  Scanner
//
//  Created by Petros Gabrielyan on 09.01.24.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    @IBOutlet weak var cameraView: UIView!
    
    var captureSession = AVCaptureSession()
    var sessionOutput = AVCapturePhotoOutput()
    var videoPreviewLayer = AVCaptureVideoPreviewLayer()
    
    private var flashMode: AVCaptureDevice.FlashMode = .auto

    
    var takePicture = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = AVCaptureDevice.default(for: .video)

                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let deviceSession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera, .builtInTelephotoCamera, .builtInTelephotoCamera], mediaType: AVMediaType.video, position: .back)
        
        for device in deviceSession.devices {
            if device.position == AVCaptureDevice.Position.back {
                do {
                    let input = try AVCaptureDeviceInput(device: device)
                    
                    if captureSession.canAddInput(input){
                        captureSession.addInput(input)
                        
                        if captureSession.canAddOutput(sessionOutput) {
                            captureSession.addOutput(sessionOutput)
                            
                            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                            videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                            cameraView.layer.addSublayer(videoPreviewLayer)
                            
                            videoPreviewLayer.position = CGPoint(x: cameraView.frame.width / 2, y: cameraView.frame.height / 2)
                            videoPreviewLayer.bounds = cameraView.frame
                            
                            
                            let output = AVCaptureVideoDataOutput()
                            if captureSession.canAddOutput(output) {
                                captureSession.addOutput(output)
                                output.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: .userInitiated))
                                
                            }
                            
                            DispatchQueue.global(qos: .background).async {
                                // Call AVCaptureSession startRunning on the background thread
                                self.captureSession.startRunning()
                                // Perform any other camera-related tasks here

                                // If you need to update the UI, dispatch it back to the main thread
                                DispatchQueue.main.async {
                                    // Update UI or perform any other main-thread-specific tasks
                                }
                            }
                            
                        }
                    }
                }catch let avError{
                    print(avError)
                }
            }
        }
    }
    
    @IBAction func backCamera(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func flashCamera(_ sender: UIButton){
        
        if let device = AVCaptureDevice.default(for: .video), device.hasTorch {
            do {
                try device.lockForConfiguration()
                
                if device.isTorchActive {
                    device.torchMode = .off
                } else {
                    try device.setTorchModeOn(level: 1.0)
                }
                
                device.unlockForConfiguration()
            } catch {
                print("Error toggling torch mode: \(error.localizedDescription)")
            }
        } else {
            print("Torch is not available on this device.")
        }
    }

    
    @IBAction func makePhoto(_ sender: UIButton){
        takePicture = true
    }
    
}

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if !takePicture {
            return //we have nothing to do with the image buffer
        }
        
        //try and get a CVImageBuffer out of the sample buffer
        guard let cvBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        //get a CIImage out of the CVImageBuffer
        let ciImage = CIImage(cvImageBuffer: cvBuffer)
        
        let uiImage = UIImage(ciImage: ciImage)
        
        DispatchQueue.main.async {
//            self.capturedImageView.image = uiImage
            self.takePicture = false
            
            let vc = EditViewController()

            vc.img = uiImage.rotate(radians: .pi/2)
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
}



extension UIImage {
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return rotatedImage ?? self
        }

        return self
    }
}
