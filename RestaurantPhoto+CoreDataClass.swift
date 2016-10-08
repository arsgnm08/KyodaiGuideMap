//
//  RestaurantPhoto+CoreDataClass.swift
//  KyodaiGuideMapApp
//
//  Created by 丸谷 浩永 on 2016/10/08.
//  Copyright © 2016 丸谷 浩永. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@objc(RestaurantPhoto)
public class RestaurantPhoto: NSManagedObject {

    var photoData : UIImage? {
        get {
            if let storedPhoto = photo {
                return UIImage(data : storedPhoto as Data)
            } else {
                return nil
            }
        }
        set(value) {
            if let value = value{
                photo = UIImageJPEGRepresentation(value, 0.5)
            }
        }
    }
    
}
