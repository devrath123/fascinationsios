//
//  Location.swift
//  Fascinations
//
//  Created by Devrath Rathee on 07/02/2017 A.
//  Copyright © 2019 Fascinations. All rights reserved.
//

import Foundation
import MapKit

class Location : NSObject, MKAnnotation{
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(title:String, coordinate : CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
        super.init()
    }
}
