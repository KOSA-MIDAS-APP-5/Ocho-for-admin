//
//  Marker.swift
//  Attendace-for-admin
//
//  Created by 겸 on 2022/11/04.
//

import Foundation
import MapKit

class Marker : NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D
    let subtitle:String?
    
    init(
        title: String?,
        subtitle: String?,
        coordinate: CLLocationCoordinate2D
    ) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        
        super.init()
    }
}
