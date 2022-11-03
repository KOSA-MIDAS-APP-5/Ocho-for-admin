//
//  kerningLabel.swift
//  Attendace-for-admin
//
//  Created by 겸 on 2022/11/04.
//

import Foundation
import UIKit

class kerningLabel : UILabel {
    @IBInspectable open var characterSpacing:CGFloat = 2 {
        didSet {
            let attributedString = NSMutableAttributedString(string: self.text!)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: self.characterSpacing, range: NSRange(location: 0, length: attributedString.length))
            self.attributedText = attributedString
        }
    }
}
