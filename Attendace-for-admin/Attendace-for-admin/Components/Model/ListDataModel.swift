//
//  ListDataModel.swift
//  Attendace-for-admin
//
//  Created by 조병진 on 2022/11/04.
//

import Foundation

struct ListDataElement: Codable {
    let name, status: String
    let id: Int
}

typealias ListDataModel = [ListDataElement]

struct PostListModel: Hashable {
    var id: Int = .init()
    var name: String = .init()
    var status: String = .init()
}
