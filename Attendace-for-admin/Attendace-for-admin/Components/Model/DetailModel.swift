//
//  DetailModel.swift
//  Attendace-for-admin
//
//  Created by 조병진 on 2022/11/04.
//

import Foundation

/*
 "latitude": 0,
   "longitude": 0,
   "name": "새로운남세원",
   "status": "근무중",
   "workTime": "00:00:00",
   "remainingTime": "00:00:00"
 */

struct DetailModel: Codable {
    let latitude, longitude: Double
    let name, status, workTime, remainingTime: String
}
