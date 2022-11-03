//
//  UILabel + Ext.swift
//  Attendace-for-admin
//
//  Created by 겸 on 2022/11/04.
//

import Foundation
import UIKit

extension UILabel {
    func addCharacterSpacing(_ value: Double = 0.5) {
        let kernValue = self.font.pointSize * CGFloat(value)
        guard let text = text, !text.isEmpty else { return }
        let string = NSMutableAttributedString(string: text)
        string.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: string.length - 1))
        attributedText = string
    }
}
