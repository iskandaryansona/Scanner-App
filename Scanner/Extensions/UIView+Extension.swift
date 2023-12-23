//
//  UIView+Extension.swift
//  Scanner
//
//  Created by Sona on 22.12.23.
//

import Foundation
import UIKit

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get{ return cornerRadius}
        set {self.layer.cornerRadius = newValue}
    }
    
}
