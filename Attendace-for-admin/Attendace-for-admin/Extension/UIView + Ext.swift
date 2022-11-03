//
//  UIView + Ext.swift
//  Attendace-for-admin
//
//  Created by 겸 on 2022/11/03.
//

import Foundation
import UIKit

extension UIView {

    
    func createCircle(status : MemberDetailView.MemberStatus = .online) -> UIView {
        
        let circle : UIView = UIView()
        
        let centerX = UIScreen.main.bounds.size.width * 0.5
        let centerY = UIScreen.main.bounds.size.height * 0.5
           
        // circle의 위치 및 크기 설정
        circle.frame = CGRect(x: centerX, y: centerY , width: 100, height: 100)
        // circle의 색깔 설정
        if status == MemberDetailView.MemberStatus.online
        {
            circle.layer.backgroundColor = UIColor.systemGreen.cgColor
        }else{
            circle.layer.backgroundColor = UIColor.systemRed.cgColor
        }
        // circle의 radius를 width(height)의 반으로 설정하여 원 모양으로 만듬
        circle.layer.cornerRadius = 7
//        // circle의 그림자 설정
//        circle.layer.shadowOpacity = 0.5
//        circle.layer.shadowRadius = 7
        return circle
    }
}
