//
//  MemberStatusViewController.swift
//  Attendace-for-admin
//
//  Created by 겸 on 2022/11/03.
//

import UIKit

class MemberStatusViewController: UIViewController {
    
    
    @IBOutlet weak var onlineTableView: UITableView!
    @IBOutlet weak var onlineTableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var offlineTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        // Do any additional setup after loading the view.
    
    }
    
    override func viewWillLayoutSubviews() {
        self.onlineTableViewHeight.constant = self.onlineTableView.contentSize.height
    }
}

extension MemberStatusViewController {
    
    fileprivate func setTableView() {
        
        // -- 온라인 테이블 뷰 --
        onlineTableView.delegate = self
        onlineTableView.dataSource = self
        
//        onlineTableView.backgroundColor = .systemYellow
        onlineTableView.isScrollEnabled = false
        
        onlineTableView.reloadData()
        // 셀 개수에 따른 높이
        self.onlineTableView.invalidateIntrinsicContentSize()
        
        // -- 오프라인 테이블 뷰 --
        offlineTableView.delegate = self
        offlineTableView.dataSource = self
        
        offlineTableView.isScrollEnabled = false
        offlineTableView.reloadData()
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
            count = 5
        }
        
        if tableView == self.offlineTableView {
            count =  3
        }
        
        return count!
    }
    
    // tableView select -> action
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        return cell
    }
}

