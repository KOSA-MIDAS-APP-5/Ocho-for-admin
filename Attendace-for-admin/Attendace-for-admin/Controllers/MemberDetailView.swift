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
import RxSwift
import RxCocoa
import Moya


class MemberDetailView: UIViewController {
    let userService = MoyaProvider<UserService>(plugins: [MoyaLoggerPlugin()])
//MARK: - Items
    
    var disposeBag = DisposeBag()
    
    var userID: Int?
    
    var result : String!
    
    var longitude : Double = 127.101473808
    var latitude : Double = 37.4001134519
    
    var userLocation = CLLocationCoordinate2D()
    
    lazy var minimumNameLength = 1
    
    let mapView = MKMapView()
    let locationManager = CLLocationManager()
    
    enum MemberStatus{
        case online
        case offline
    }
        
    // 받을 데이터
    var statusCondition = "근무중"
    var memberName = "사원이름"
    var departmentName = "수정 후 이름이 기재될 공간입니다."
    
    var statusText = "온라인"
    
    var workedTime = "3:00시간 일했습니다."
    var leftTime = "5:00시간 남았습니다."
    
    var online : MemberStatus = MemberStatus.online
    var offline : MemberStatus = MemberStatus.offline
    
    var memberStatus = MemberStatus.online
    
    
    let memberImage = UIImage(systemName: "person.circle")
    
    lazy var memberImageView : UIImageView = UIImageView().then{
        $0.image = memberImage
    }
    
    lazy var memberNameLabel : UITextField = UITextField().then{
        $0.attributedPlaceholder = NSAttributedString(
            string: memberName,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        $0.font = .systemFont(ofSize: 24, weight: .heavy)
    }
    
    lazy var changeLabelButton : UIButton = UIButton().then{
        $0.setTitle("교체", for: .normal)
        $0.backgroundColor = .lightGray
        $0.layer.cornerRadius = 5
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
    
    lazy var workDescription : UILabel = UILabel().then{
        $0.text = "일 한 시간"
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    }
    
    lazy var roundView : UIView = UIView().then{
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .systemRed
    }
    
    lazy var workedTimeLabel : kerningLabel = kerningLabel().then{
        $0.text = workedTime
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        $0.textAlignment = .center
    }

    lazy var leftTimeDescription : UILabel = UILabel().then{
        $0.text = "남은 시간"
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    }
    
    lazy var roundView2 : UIView = UIView().then{
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .systemRed
    }
    
    lazy var leftTimeLabel : UILabel = UILabel().then{
        $0.text = leftTime
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        $0.textAlignment = .center
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
         self.view.endEditing(true)
   }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailData()
        view.backgroundColor = .white
        changeLabelButton.addTarget(self, action: #selector(textFieldDidChange), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        userLocation.latitude = latitude
        userLocation.longitude = longitude
        locationManager.delegate = self
        let mark = Marker(
                  title: memberName,
                  subtitle: departmentName,
                  coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        mapView.addAnnotation(mark)
        mapView.setRegion(MKCoordinateRegion(center: userLocation, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)), animated: true)
        
    }
    
    func detailData() {
        userService.request(.userDetail(userID: userID!)) { res in
            switch res {
            case .success(let result):
                switch result.statusCode {
                case 200:
                    if let data = try? JSONDecoder().decode(DetailModel.self, from: result.data) {
                        self.longitude = data.longitude
                        self.latitude = data.latitude
                        self.memberName = data.name
                        self.statusCondition = data.status
                        self.workedTime = data.workTime
                        self.leftTime = data.remainingTime
                        print("온라인 유저 정보 가져옴")
                        self.setUI()
                    } else {
                        print("온라인 유저 디코딩 오류")
                    }
                default:
                    print(result.statusCode)
                }
            case .failure(_):
                print("온라인 유저 오류")
            }
        }
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
        searchLocation(userLocation)
        setRx()
    }
    
    fileprivate func addToView() {
        [memberNameLabel, changeLabelButton, memberImageView, departmentNameLabel, statusLabel, mapView, addressLabel, workDescription, roundView, leftTimeDescription, roundView2].forEach( {
            view.addSubview($0)
        })
        roundView.addSubview(workedTimeLabel)
        roundView2.addSubview(leftTimeLabel)
    }
    
    fileprivate func setLayout() {
        
        memberNameLabel.snp.makeConstraints{
            $0.left.equalTo(memberImageView.snp.right).offset(30)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
        }
        
        changeLabelButton.snp.makeConstraints{
            $0.top.equalTo(memberNameLabel.snp.top)
            $0.right.equalTo(view.safeAreaLayoutGuide.snp.right).inset(20)
            $0.width.equalTo(40)
            $0.height.equalTo(30)
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
        
        workDescription.snp.makeConstraints{
            $0.top.equalTo(addressLabel.snp.bottom).offset(10)
            $0.left.equalTo(addressLabel)
        }
        
        roundView.snp.makeConstraints{
            $0.height.equalTo(50)
            $0.top.equalTo(workDescription.snp.bottom).offset(10)
            $0.left.equalTo(workDescription.snp.left)
            $0.centerX.equalToSuperview()
        }
        
        workedTimeLabel.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        leftTimeDescription.snp.makeConstraints{
            $0.top.equalTo(roundView.snp.bottom).offset(10)
            $0.left.equalTo(roundView)
        }
        
        roundView2.snp.makeConstraints{
            $0.height.equalTo(50)
            $0.top.equalTo(leftTimeDescription.snp.bottom).offset(10)
            $0.left.equalTo(leftTimeDescription.snp.left)
            $0.centerX.equalToSuperview()
        }
        
        leftTimeLabel.snp.makeConstraints{
            $0.edges.equalToSuperview()
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

        let pLocation = CLLocationCoordinate2DMake(latitude, longitude)
        
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

//MARK: - Rx
extension MemberDetailView {
    fileprivate func setRx(){
        
        let idValid = memberNameLabel.rx.text.orEmpty
            .map{ $0.count >= self.minimumNameLength }
            .share(replay : 1)
        
        idValid
            .map { isValid -> UIColor in
                let color : UIColor = isValid ? .systemBlue : .lightGray
                return color
            }
            .bind(to: changeLabelButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        idValid
            .bind(to: self.changeLabelButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
//        changeLabelButton.rx.tap
//            .subscribe(onNext: {[weak self] _ in self?.didTapButton() })
//            .disposed(by: disposeBag)
        
//        changeLabelButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
                    
    }
//    @objc private func textFieldDidChange() {
//        memberNameLabel.rx.text
//            .bind(onNext: { s in
//                self.memberName = s!
//                self.memberNameLabel.placeholder = s
//                self.view.endEditing(true)
//                print(self.memberNameLabel.placeholder)
//            })
//            .disposed(by: disposeBag)
//    }
    
    @objc private func textFieldDidChange(_ sender : UITextField){
        result = memberNameLabel.text!
        departmentNameLabel.text = "\(result!)"
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

