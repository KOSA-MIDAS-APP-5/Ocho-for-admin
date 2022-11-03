//
//  MemberDetailView.swift
//  Attendace-for-admin
//
//  Created by 겸 on 2022/11/03.
//

import UIKit
import Then
import SnapKit
import MapKit


class MemberDetailView: UIViewController {
    
//MARK: - Items
    
    let mapView = MKMapView()
    
    enum MemberStatus{
        case online
        case offline
    }
    
    // 받을 데이터
    let statusCondition = "근무중"
    var memberName = "사원이름"
    var departmentName = "소속 부서"
    
    var statusText = "온라인"
    
    var online : MemberStatus = MemberStatus.online
    var offline : MemberStatus = MemberStatus.offline
    
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
        
        $0.text = statusText
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        view.backgroundColor = .white
        let mark = Marker(
                  title: "홍대입구역",
                  subtitle: "test",
                  coordinate: CLLocationCoordinate2D(latitude: 37.55769, longitude: 126.92450))
        mapView.addAnnotation(mark)
    }
    
    
}


//MARK: - UISetting
extension MemberDetailView {
    
    fileprivate func setUI() {
        addToView()
        setLayout()
        setCircle()
        setStatusLabel()
    }
    
    fileprivate func addToView() {
        view.addSubview(memberNameLabel)
        view.addSubview(memberImageView)
        view.addSubview(departmentNameLabel)
        view.addSubview(statusLabel)
        view.addSubview(mapView)
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
        
        statusLabel.snp.makeConstraints{
            $0.left.equalTo(departmentNameLabel.snp.left).offset(20)
            $0.top.equalTo(departmentNameLabel.snp.bottom).offset(7)
        }
        
        mapView.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.height.equalTo(300)
            $0.top.equalTo(statusLabel.snp.bottom).offset(50)
            $0.left.equalToSuperview().offset(20)
        }
    }
    
    fileprivate func markSetting(){
  
    }
    
    //MARK: - 활성화 상태
    
    /// 상태 바꾸기
    /// - Returns: 근무중이면 online, 아닐 경우 offline
    func changeStatus() -> MemberStatus {
        statusCondition == "근무중" ? (memberStatus = MemberStatus.online) : (memberStatus = MemberStatus.offline)
        
        return memberStatus
    }
    
    func changeStatusLabel() -> String {
        
        statusCondition == "근무중" ? (statusText = "온라인") : (statusText = "오프라인")
        
        return statusText
    }
    
    /// 현재 상태 Circle
    fileprivate func setCircle(){
        
        let circle : UIView = UIView().createCircle(status: changeStatus())
        view.addSubview(circle)
        
        circle.snp.makeConstraints{
            $0.width.equalTo(14)
            $0.height.equalTo(14)

            $0.top.equalTo(departmentNameLabel.snp.bottom).offset(10)
            $0.left.equalTo(departmentNameLabel.snp.left)
        }
    }
    
    fileprivate func setStatusLabel(){
        changeStatusLabel()
        statusLabel.text = statusText
    }
}


//MARK: - Preview Setting
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

