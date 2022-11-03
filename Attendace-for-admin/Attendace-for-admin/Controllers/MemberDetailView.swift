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
    
    
    var longtitude : Double = 127.101473808
    var latitude : Double = 37.4001134519
    
    var testLocation = CLLocationCoordinate2D(latitude: 37.4001134519, longitude: 127.101473808)

    
    let mapView = MKMapView()
    let locationManager = CLLocationManager()
    
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
    
    lazy var addressLabel : UILabel = UILabel().then{
        $0.text = ""
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        view.backgroundColor = .white
        locationManager.delegate = self
        let mark = Marker(
                  title: memberName,
                  subtitle: departmentName,
                  coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longtitude))
        mapView.addAnnotation(mark)
        
        mapView.setRegion(MKCoordinateRegion(center: testLocation, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)), animated: true)
    }
    
    
}


//MARK: - UISetting
extension MemberDetailView {
    
    fileprivate func setUI() {
        addToView()
        setLayout()
        setCircle()
        setStatusLabel()
        mapSetting()
        searchLocation(testLocation)
    }
    
    fileprivate func addToView() {
        view.addSubview(memberNameLabel)
        view.addSubview(memberImageView)
        view.addSubview(departmentNameLabel)
        view.addSubview(statusLabel)
        view.addSubview(mapView)
        view.addSubview(addressLabel)
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
        
        addressLabel.snp.makeConstraints{
            $0.top.equalTo(mapView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.left.equalTo(20)
            
        }
    }
    
    fileprivate func mapSetting(){
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // 위치 데이터 추적을 위해 사용자에게 승인 요구
        locationManager.requestWhenInUseAuthorization()
        
        // 위치 업데이트 시작
        locationManager.startUpdatingLocation()
//        mapView.showsUserLocation = true
        
        

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

extension MemberDetailView : CLLocationManagerDelegate {
    
    func goLocation(latitudeValue : CLLocationDegrees, longitudeValue : CLLocationDegrees, delta span :Double)->CLLocationCoordinate2D{

        let pLocation = CLLocationCoordinate2DMake(latitude, longtitude)
        
        let spanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        
        let pRegion = MKCoordinateRegion(center: pLocation, span: spanValue)
        
        mapView.setRegion(pRegion, animated: true)
        
        return pLocation
    }
    
    
 /// 해당 포인트의 주소를 검색
 private func searchLocation(_ point: CLLocationCoordinate2D) {
     let geocoder: CLGeocoder = CLGeocoder()
     let location = CLLocation(latitude: point.latitude, longitude: point.longitude)
                 
     geocoder.reverseGeocodeLocation(location) { (placeMarks, error) in
         if error == nil, let marks = placeMarks {
             marks.forEach { (placeMark) in
                 let annotation = MKPointAnnotation()
                 annotation.coordinate = CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
                 
                 self.addressLabel.text = "\(placeMark.administrativeArea ?? "") \(placeMark.locality ?? "") \(placeMark.thoroughfare ?? "")"
                 
                 self.mapView.addAnnotation(annotation)
                }
           } else {
             self.addressLabel.text = "검색 실패"
           }
       }
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

