//
//  MemberCell.swift
//  Attendace-for-admin
//
//  Created by 겸 on 2022/11/03.
//

import UIKit

class MemberCell: UITableViewCell {
    
    @IBOutlet weak var memberImage: UIImageView!
    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet weak var departmentLabel: UILabel!
    
    var memberName: String = ""
    var department: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUI()
//        self.backgroundColor = .systemGreen
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    
}

//MARK: - Cell 내부 세팅
extension MemberCell {

    fileprivate func setUI() {
        
        let image = UIImage(systemName: "person.circle")
        memberImage.image = image
        
        departmentLabel.textColor = UIColor.lightGray
        departmentLabel.font = .systemFont(ofSize: 16)
        
    }
}


