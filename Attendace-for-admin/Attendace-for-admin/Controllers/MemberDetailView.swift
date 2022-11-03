//
//  MemberDetailView.swift
//  Attendace-for-admin
//
//  Created by 겸 on 2022/11/03.
//

import UIKit
import Then
import SnapKit



class MemberDetailView: UIViewController {
    
    enum MemberStatus{
        case online
        case offline
    }
    
    var memberName = "사원이름"
    var departmentName = "소속 부서"
    var memberStatus = MemberStatus.online
    
    
    let memberImage = UIImage(systemName: "person.circle")
    
    
    lazy var memberImageView : UIImageView = UIImageView().then{
        $0.image = memberImage
    }
    
    lazy var memberNameLabel : UILabel = UILabel().then{
        $0.text = memberName
        $0.font = .systemFont(ofSize: 24, weight: .heavy)
    }
    
    lazy var departmentNameLabel : UILabel = UILabel().then{
        $0.text = departmentName
        $0.textColor = .lightGray
        $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    }
    
    lazy var statusLabel : UILabel = UILabel().then{
        $0.text = ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        view.backgroundColor = .white
        
        
    }
}

extension MemberDetailView {
    
    
    fileprivate func setUI() {
        addToView()
        setLayout()
    }
    
    fileprivate func addToView() {
        view.addSubview(memberNameLabel)
        view.addSubview(memberImageView)
        view.addSubview(departmentNameLabel)
//        view.addSubview(circle)
    }
    
    fileprivate func setLayout() {
        
        memberNameLabel.snp.makeConstraints{
            $0.left.equalTo(memberImageView.snp.right).offset(30)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
        }
        
        memberImageView.snp.makeConstraints{
            $0.width.equalTo(110)
            $0.height.equalTo(110)
            
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            $0.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(16)
        }
        
        departmentNameLabel.snp.makeConstraints{
            $0.top.equalTo(memberNameLabel.snp.bottom).offset(10)
            $0.left.equalTo(memberNameLabel.snp.left)
        }
        
//        circle.snp.makeConstraints{
//            $0.width.equalTo(14)
//            $0.height.equalTo(14)
//            
//            $0.top.equalTo(departmentNameLabel.snp.bottom).offset(10)
//            $0.left.equalTo(departmentNameLabel.snp.left)
//        }
        
    }
}

#if DEBUG

import SwiftUI

struct MemberDetailViewPresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        MemberDetailView()
    }
}


struct MemberDetailViewPrepresentable_PreviewProvider : PreviewProvider {
    static var previews: some View {
        MemberDetailViewPresentable()
            .ignoresSafeArea()
    }
}

#endif

