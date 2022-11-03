//
//  InputTextField.swift
//  Attendace-for-admin
//
//  Created by 겸 on 2022/11/03.
//

import UIKit
import Then

class InputTextField : UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

extension InputTextField {

    // TextField 설정
    func makeTextField(_ placeholder : String ) -> UITextField{
       
       let view : UITextField = UITextField().then{
           $0.textColor = .black
           $0.attributedPlaceholder = NSAttributedString(string: placeholder)
           $0.borderStyle = .roundedRect
        }
        return view
    }
    
    func makePwTextField(_ placeholder : String ) -> UITextField{
       
       let view : UITextField = UITextField().then{
           $0.textColor = .black
           $0.attributedPlaceholder = NSAttributedString(string: placeholder)
           $0.borderStyle = .roundedRect
           $0.isSecureTextEntry = true
           $0.passwordRules = UITextInputPasswordRules(descriptor: "required: -().&@?'#,/&quot;+")
        }
        return view
    }
    
}


