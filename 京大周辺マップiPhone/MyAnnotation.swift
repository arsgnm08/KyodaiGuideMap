//
//  MyAnnotation.swift
//  KyodaiGuideMapApp
//
//  Created by 丸谷 浩永 on 9/1/16.
//  Copyright © 2016 丸谷 浩永. All rights reserved.
//

import UIKit
import MapKit

class MyAnnotation: NSObject, MKAnnotation {
    @objc var coordinate: CLLocationCoordinate2D
    @objc var subtitle: String?
    @objc var title: String?
    
    var restaurantInfo : RestaurantBasic? = nil
    
    init(coordinate: CLLocationCoordinate2D, subtitle: String, title: String){
        self.coordinate = coordinate
        self.subtitle = subtitle
        self.title = title
    }
    
    init(restaurantInfo : RestaurantBasic) {
        coordinate = CLLocationCoordinate2D()
        self.coordinate.latitude = Double(restaurantInfo.latitude!)!
        self.coordinate.longitude = Double(restaurantInfo.longitude!)!
        self.title = restaurantInfo.name
        self.subtitle = restaurantInfo.genre
        self.restaurantInfo = restaurantInfo
    }
    
    
}
