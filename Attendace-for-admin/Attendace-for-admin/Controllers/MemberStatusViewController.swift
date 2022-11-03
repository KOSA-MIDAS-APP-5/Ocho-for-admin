//
//  MemberStatusViewController.swift
//  Attendace-for-admin
//
//  Created by 겸 on 2022/11/03.
//

import UIKit
import Moya

class MemberStatusViewController: UIViewController {
    var onlineUserData: [PostListModel] = []
    var offlineUserData: [PostListModel] = []
    
    let userService = MoyaProvider<UserService>(plugins: [MoyaLoggerPlugin()])
    
    @IBOutlet weak var onlineTableView: UITableView!{
        didSet{
//            onlineTableView.register(MemberCell.self, forCellReuseIdentifier: "onlinecell")
            self.onlineTableView.delegate = self
            self.onlineTableView.dataSource = self
        }
    }
    @IBOutlet weak var onlineTableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var offlineTableView: UITableView!{
        didSet{
//            offlineTableView.register(MemberCell.self, forCellReuseIdentifier: "offlinecell")
            self.offlineTableView.delegate = self
            self.offlineTableView.dataSource = self
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "임직원 현황"
        getUserDatas()
        setTableView()
        // Do any additional setup after loading the view.
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let vc = segue.destination as! MemberDetailView
            if let index = sender as? Int {
                vc.userID = index
            }
        }
    }
    
    func getUserDatas() {
        userService.request(.onlineUser) { res in
            switch res {
            case .success(let result):
                switch result.statusCode {
                case 200:
                    if let data = try? JSONDecoder().decode(ListDataModel.self, from: result.data) {
                        self.onlineUserData = data.map {
                            let name = $0.name
                            let status = $0.status
                            let id = $0.id
                            
                            return PostListModel(id: id, name: name, status: status)
                        }
                        print("온라인 유저 정보 가져옴")
                        self.onlineTableView.reloadData()
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
        
        userService.request(.offlineUser) { res in
            switch res {
            case .success(let result):
                switch result.statusCode {
                case 200:
                    if let data = try? JSONDecoder().decode(ListDataModel.self, from: result.data) {
                        self.offlineUserData = data.map {
                            let name = $0.name
                            let status = $0.status
                            let id = $0.id
                            
                            return PostListModel(id: id, name: name, status: status)
                        }
                        print("오프라인 유저 정보 가져옴")
                        self.offlineTableView.reloadData()
                    } else {
                        print("오프라인 유저 디코딩 오류")
                    }
                default:
                    print(result.statusCode)
                }
            case .failure(_):
                print("오프라인 유저 오류")
            }
        }
        
        
    }
}

extension MemberStatusViewController {
    
    fileprivate func setTableView() {
        
        // -- 온라인 테이블 뷰 --

    
        
//        onlineTableView.backgroundColor = .systemYellow
        onlineTableView.isScrollEnabled = false
        
//        onlineTableView.reloadData()
        // 셀 개수에 따른 높이
        self.onlineTableView.invalidateIntrinsicContentSize()
        
        // -- 오프라인 테이블 뷰 --

        
        offlineTableView.isScrollEnabled = false
//        offlineTableView.reloadData()
        self.offlineTableView.invalidateIntrinsicContentSize()

    }
    
}


extension MemberStatusViewController : UITableViewDelegate {
    
}

extension MemberStatusViewController : UITableViewDataSource {
    // Header Height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    // Header Text
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var headerMessage : String?
        
        if tableView == self.onlineTableView {
            headerMessage = "현재 온라인"
        }
        
        if tableView == self.offlineTableView {
            headerMessage = "현재 오프라인"
        }
        
        return headerMessage
    }
    
    // Number of Row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count:Int?
        
        if tableView == self.onlineTableView {
            count = onlineUserData.count
        }
        
        if tableView == self.offlineTableView {
            count =  offlineUserData.count
        }
        
        return count!
    }
    
    // tableView select -> action
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == onlineTableView {
//            let vc = segue.des
            onlineTableView.deselectRow(at: indexPath, animated: true)
            performSegue(withIdentifier: "showDetail", sender: onlineUserData[indexPath.row].id)
        } else {
            offlineTableView.deselectRow(at: indexPath, animated: true)
            performSegue(withIdentifier: "showDetail", sender: offlineUserData[indexPath.row].id)
        }
        
        print("tapped")
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    // Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == onlineTableView {
            let cell = onlineTableView.dequeueReusableCell(withIdentifier: "onlinecell", for: indexPath) as! MemberCell
            cell.memberNameLabel?.text = onlineUserData[indexPath.row].name
            cell.departmentLabel?.text = onlineUserData[indexPath.row].status
            return cell
        } else {
            let cell = offlineTableView.dequeueReusableCell(withIdentifier: "offlinecell", for: indexPath) as! MemberCell
            cell.memberNameLabel?.text = offlineUserData[indexPath.row].name
            cell.departmentLabel?.text = offlineUserData[indexPath.row].status
            return cell
        }
        
    }
    
}
