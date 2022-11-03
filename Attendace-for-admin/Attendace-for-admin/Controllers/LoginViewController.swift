//
//  ViewController.swift
//  Attendace-for-admin
//
//  Created by 겸 on 2022/11/03.
//

import UIKit
import Then
import SnapKit
import RxCocoa
import RxSwift

class LoginViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    lazy var titleLabel : UILabel = UILabel().then {
        $0.text = "출퇴근 관리 시스템"
        $0.font = UIFont.systemFont(ofSize: 30, weight: .bold)
    }
    
    lazy var adminLabel : UILabel = UILabel().then{
        $0.text = "관리자를 위한"
        $0.font = UIFont.systemFont(ofSize: 22, weight: .bold)
    }
    
    lazy var idValidLabel : UILabel = UILabel().then {
        $0.text = "아이디 틀림"
    }
    
    lazy var pwValidLabel : UILabel = UILabel().then {
        $0.text = "패스워드 틀림"
    }
    
    lazy var loginButton : UIButton = UIButton().then {
        $0.setTitle("로그인", for: .normal)
        $0.backgroundColor = UIColor.lightGray
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        $0.layer.cornerRadius = 8
    }
    
    lazy var idTextField = InputTextField().makeTextField("ID 입력")
    
    lazy var pwTextField = InputTextField().makePwTextField("비밀번호 입력")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        setUI()
        
    }
    
    @objc private func didTapLogin() {
        
        
        guard let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "MemberStatusVC") as? MemberStatusViewController else { return }
        // 화면 전환 애니메이션 설정
        secondViewController.modalTransitionStyle = .coverVertical
        // 전환된 화면이 보여지는 방법 설정 (fullScreen)
        secondViewController.modalPresentationStyle = .fullScreen
        self.present(secondViewController, animated: true, completion: nil)
    }
}

extension LoginViewController {
    
    fileprivate func setUI(){
        addToView()
        setAutoLayout()
        setRx()
    }
    
    fileprivate func addToView(){
        view.addSubview(adminLabel)
        view.addSubview(titleLabel)
        view.addSubview(idTextField)
        view.addSubview(idValidLabel)
        view.addSubview(pwTextField)
        view.addSubview(pwValidLabel)
        view.addSubview(loginButton)
    }
    
    fileprivate func setAutoLayout(){
        adminLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(150)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(adminLabel.snp.bottom ).offset(3)
            
        }
        
        idTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.width.equalTo(330)
            $0.height.equalTo(40)
        }
        
        idValidLabel.snp.makeConstraints {
            $0.right.equalTo(idTextField.snp.right)
            $0.top.equalTo(idTextField.snp.bottom)
            
        }
        
        pwTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(idTextField.snp.bottom).offset(40)
            $0.width.equalTo(330)
            $0.height.equalTo(40)
        }
        
        pwValidLabel.snp.makeConstraints {
            $0.right.equalTo(pwTextField.snp.right)
            $0.top.equalTo(pwTextField.snp.bottom)
        }
        
        loginButton.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(pwTextField.snp.bottom).offset(50)
            $0.left.equalToSuperview().offset(30)
        }
        
        
    }
    
    
        

    
    
    fileprivate func setRx(){
        
        idTextField.rx.text
            .subscribe { s in
                print(s)
            }
        
        let idValid = idTextField.rx.text.orEmpty
            .map{ $0.count >= 5 }
            .share(replay : 1)
    
        
        let pwValid = pwTextField.rx.text.orEmpty
            .map{$0.count >= 5}
            .share(replay: 1)
        
        let everythingValid = Observable.combineLatest(idValid, pwValid) { $0 && $1 }
            .share(replay: 1)
        
        idValid
            .bind(to: pwTextField.rx.isEnabled)
            .disposed(by: disposeBag)
        
        idValid
            .bind(to: idValidLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        pwValid
            .bind(to: pwValidLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        everythingValid
            .map { isValid -> UIColor in
                let color : UIColor = isValid ? .systemBlue : .lightGray
                return color
            }
            .bind(to: loginButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        everythingValid
            .bind(to: self.loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .subscribe(onNext: {[weak self] _ in self?.didTapLogin() })
            .disposed(by: disposeBag)
        
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

