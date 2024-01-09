//
//  UIImage+Crop.swift
//  Scanner
//
//  Created by Petros Gabrielyan on 09.01.24.
//

import Foundation
import UIKit

extension UIImage {
    func cropAlpha() -> UIImage {
        
        let cgImage = self.cgImage!;
        
        let width = cgImage.width
        let height = cgImage.height
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerPixel:Int = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        let bitmapInfo: UInt32 = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
        
        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo),
            let ptr = context.data?.assumingMemoryBound(to: UInt8.self) else {
                return self
        }
        
        context.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        var minX = width
        var minY = height
        var maxX: Int = 0
        var maxY: Int = 0
        
        for x in 1 ..< width {
            for y in 1 ..< height {
                
                let i = bytesPerRow * Int(y) + bytesPerPixel * Int(x)
                let a = CGFloat(ptr[i + 3]) / 255.0
                
                if(a>0) {
                    if (x < minX) { minX = x };
                    if (x > maxX) { maxX = x };
                    if (y < minY) { minY = y};
                    if (y > maxY) { maxY = y};
                }
            }
        }
        
        let rect = CGRect(x: CGFloat(minX),y: CGFloat(minY), width: CGFloat(maxX-minX), height: CGFloat(maxY-minY))
        let imageScale:CGFloat = self.scale
        let croppedImage =  self.cgImage!.cropping(to: rect)!
        let ret = UIImage(cgImage: croppedImage, scale: imageScale, orientation: self.imageOrientation)
        
        return ret;
    }
}

import UIKit

extension UIImage {

    func fixedOrientation() -> UIImage {
        // No-op if the orientation is already correct
        if (imageOrientation == UIImage.Orientation.up) {
            return self
        }

        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform:CGAffineTransform = CGAffineTransform.identity

        if (imageOrientation == UIImage.Orientation.down
            || imageOrientation == UIImage.Orientation.downMirrored) {

            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        }

        if (imageOrientation == UIImage.Orientation.left
            || imageOrientation == UIImage.Orientation.leftMirrored) {

            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi/2))
        }

        if (imageOrientation == UIImage.Orientation.right
            || imageOrientation == UIImage.Orientation.rightMirrored) {

            transform = transform.translatedBy(x: 0, y: size.height);
            transform = transform.rotated(by: CGFloat(-Double.pi/2));
        }

        if (imageOrientation == UIImage.Orientation.upMirrored
            || imageOrientation == UIImage.Orientation.downMirrored) {

            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        }

        if (imageOrientation == UIImage.Orientation.leftMirrored
            || imageOrientation == UIImage.Orientation.rightMirrored) {

            transform = transform.translatedBy(x: size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1);
        }


        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let ctx:CGContext = CGContext(data: nil, width: Int(size.width), height: Int(size.height),
                                      bitsPerComponent: cgImage!.bitsPerComponent, bytesPerRow: 0,
                                      space: cgImage!.colorSpace!,
                                      bitmapInfo: cgImage!.bitmapInfo.rawValue)!

        ctx.concatenate(transform)


        if (imageOrientation == UIImage.Orientation.left
            || imageOrientation == UIImage.Orientation.leftMirrored
            || imageOrientation == UIImage.Orientation.right
            || imageOrientation == UIImage.Orientation.rightMirrored
            ) {


            ctx.draw(cgImage!, in: CGRect(x:0,y:0,width:size.height,height:size.width))

        } else {
            ctx.draw(cgImage!, in: CGRect(x:0,y:0,width:size.width,height:size.height))
        }


        // And now we just create a new UIImage from the drawing context
        let cgimg:CGImage = ctx.makeImage()!
        let imgEnd:UIImage = UIImage(cgImage: cgimg)

        return imgEnd
    }
}
