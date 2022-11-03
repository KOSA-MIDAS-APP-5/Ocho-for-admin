//
//  ViewController.swift
//  Attendace-for-admin
//
//  Created by 겸 on 2022/11/03.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}


#if DEBUG

import SwiftUI

struct LoginViewControllerPresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        LoginViewController()
    }
}


struct LoginViewControllerPrepresentable_PreviewProvider : PreviewProvider {
    static var previews: some View {
        LoginViewControllerPresentable()
            .ignoresSafeArea()
    }
}

#endif

