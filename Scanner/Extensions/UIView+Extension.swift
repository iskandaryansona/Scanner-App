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

extension UIButton {
    
    func underLine(text: String){
        
        let yourAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.white,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        let attributeString = NSMutableAttributedString(
            string: text,
            attributes: yourAttributes
        )
        self.setAttributedTitle(attributeString, for: .normal)
    }
}
