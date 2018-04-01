//
//  FormTextField.swift
//  BPP-Mobile
//
//  Created by Francisco Almeida on 04/01/2018.
//

import Foundation
import UIKit

class FormTextField: UITextField {
    let padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.backgroundColor = UIColor.darkGray
        self.font = UIFont.systemFont(ofSize: 14)
        self.textColor = .white
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes:[NSAttributedStringKey.foregroundColor : UIColor.white])
        return self.newBounds(bounds)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }
    
    fileprivate func newBounds(_ bounds: CGRect) -> CGRect {
        var newBounds = bounds
        newBounds.origin.x += padding.left
        newBounds.origin.y += padding.top
        newBounds.size.height -= padding.top + padding.bottom
        newBounds.size.width -= padding.left + padding.right
        return newBounds
    }
}
